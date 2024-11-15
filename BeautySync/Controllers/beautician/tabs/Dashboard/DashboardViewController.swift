//
//  DashboardViewController.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/14/24.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import DropDown
import DGCharts
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming
import MaterialComponents.MaterialTextControls_FilledTextAreasTheming
import MaterialComponents.MaterialTextControls_FilledTextFieldsTheming
import MaterialComponents.MaterialTextControls_OutlinedTextAreasTheming
import MaterialComponents.MaterialTextControls_OutlinedTextFieldsTheming
import DGCharts

class DashboardViewController: UIViewController, ChartViewDelegate {
    
    let db = Firestore.firestore()

    @IBOutlet weak var itemTypeButton: UIButton!
    @IBOutlet weak var itemType: MDCOutlinedTextField!
    @IBOutlet weak var itemTitle: MDCOutlinedTextField!
    @IBOutlet weak var itemTitleButton: UIButton!
    
    let itemTypeMenu = DropDown()
    let itemMenu = DropDown()
    
    @IBOutlet weak var weeklyButton: MDCButton!
    @IBOutlet weak var monthlyButton: MDCButton!
    @IBOutlet weak var totalButton: MDCButton!
    
    @IBOutlet weak var weeklyBarChart: BarChartView!
    @IBOutlet weak var monthlyBarChart: BarChartView!
    @IBOutlet weak var totalPieChart: PieChartView!
    
    var items: [DashboardItems] = []
    var yearlyItems : [String] = ["All", "Hair Items", "Makeup Items", "Lash Items"]
    private var time = "Weekly"
    
    let date = Date()
    let df = DateFormatter()
    
    //Date
    private var year = ""
    private var month = ""
    private var yearMonth = ""
    private var quarter = "1"
    private var monthStart = "01"
    private var monthEnd = "07"
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.monthlyBarChart.isHidden = true
        self.totalPieChart.isHidden = true
        itemTypeMenu.dataSource = ["Hair Items", "Makeup Items", "Lash Items"]
        itemTypeMenu.anchorView = itemType
        
        itemTypeMenu.selectionAction = { index, item in
            self.itemType.text = item
            if self.time != "Yearly" {
                self.loadItemTitles(item: item)
            } else {
//            self.loadItemYearlyData(itemTitle: item)
            }
        }
        itemMenu.anchorView = itemTitle
        itemMenu.selectionAction = { index, item in
            self.itemTitle.text = item
            if self.time == "Weekly" {
                self.loadItemWeeklyData(itemTitle: item)
            } else if self.time == "Monthly" {
                self.loadItemMonthlyData(itemTitle: item)
            }
        }
        
        // Date
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
      
        let dateString = df.string(from: date)
        year = "\(dateString.prefix(4))"
        month = "\(dateString.prefix(7).suffix(2))"
        yearMonth = "\(year), \(month)"
        
            print("month number first\(self.month)")
        if Int(month)! < 7 {
            quarter = "1"
            monthStart = "01"
            monthEnd = "7"
        } else {
            quarter = "2"
            monthStart = "07"
            monthEnd = "13"
        }
        //
        
        weeklyBarChart.delegate = self
        monthlyBarChart.delegate = self
        totalPieChart.delegate = self

        itemType.layer.cornerRadius = 2
        itemTitle.layer.cornerRadius = 2
        
    }
    @IBAction func weeklyButtonPressed(_ sender: Any) {
        time = "Weekly"
        self.itemTitle.text = ""
        self.itemType.text = ""
        weeklyBarChart.isHidden = false
        monthlyBarChart.isHidden = true
        totalPieChart.isHidden = true
        
        itemTitle.isHidden = false
        itemTitleButton.isHidden = false
        
        weeklyButton.setTitleColor(UIColor.white, for: .normal)
        weeklyButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        monthlyButton.backgroundColor = UIColor.white
        monthlyButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        totalButton.backgroundColor = UIColor.white
        totalButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        
        
        
    }
    
    @IBAction func monthlyButtonPressed(_ sender: Any) {
        time = "Monthly"
        self.itemTitle.text = ""
        self.itemType.text = ""
        weeklyBarChart.isHidden = true
        monthlyBarChart.isHidden = false
        totalPieChart.isHidden = true
        
        itemTitle.isHidden = false
        itemTitleButton.isHidden = false
        
        weeklyButton.backgroundColor = UIColor.white
        weeklyButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        monthlyButton.setTitleColor(UIColor.white, for: .normal)
        monthlyButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        totalButton.backgroundColor = UIColor.white
        totalButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func totalButtonPressed(_ sender: Any) {
        time = "Yearly"
        self.itemTitle.text = ""
        self.itemType.text = ""
        weeklyBarChart.isHidden = true
        monthlyBarChart.isHidden = true
        totalPieChart.isHidden = false
        
        itemTitle.isHidden = true
        itemTitleButton.isHidden = true
        
        weeklyButton.backgroundColor = UIColor.white
        weeklyButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        monthlyButton.backgroundColor = UIColor.white
        monthlyButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        totalButton.setTitleColor(UIColor.white, for: .normal)
        totalButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
    }
    
    @IBAction func itemTypeButtonPressed(_ sender: Any) {
        itemTypeMenu.show()
    }
    
    @IBAction func itemTitleButtonPressed(_ sender: Any) {
        itemMenu.show()
    }
    
    
    private func loadItemTitles(item: String) {
        var itemType = ""
        self.items.removeAll()
        self.itemMenu.dataSource.removeAll()
        self.itemTitle.text = ""
        
        if item == "Hair Items" { itemType = "hairItems" } else if item == "Makeup Items" { itemType = "makeupItems" } else if item == "Lash Items" { itemType = "lashItems" }
        db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection(itemType).getDocuments { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        
                        if let itemTitle = data["itemTitle"] as? String {
                            self.items.append(DashboardItems(itemTitle: itemTitle, documentId: doc.documentID))
                            self.itemMenu.dataSource.append(itemTitle)
                        }
                    }
                    
                }
                if documents?.documents.count == 0 {
                    self.items.append(DashboardItems(itemTitle: "There are no \(item).", documentId: ""))
                    self.itemMenu.dataSource.append("There are no \(item).")
                }
            }
        }
    }
    
    
    private func loadItemWeeklyData(itemTitle: String) {
        var itemType = ""
        if self.itemType.text == "Hair Items" { itemType = "hairItems" } else if self.itemType.text == "Makeup Items" { itemType = "makeupItems" } else if self.itemType.text == "Lash Items" { itemType = "lashItems" }
        if Auth.auth().currentUser != nil {
            let month = "\(df.string(from: date))".prefix(7).suffix(2)
            let year = "\(df.string(from: date))".prefix(4)
            let yearMonth = "\(year), \(month)"
            var itemId = ""
            for i in 0..<items.count {
                if items[i].itemTitle == itemTitle {
                    itemId = items[i].documentId
                }
            }
            //        var entries = [BarChartDataEntry]()
            var weeklyData : [BarChartDataEntry] = [BarChartDataEntry(x: 0, y: 0), BarChartDataEntry(x: 1, y: 0), BarChartDataEntry(x: 2, y: 0), BarChartDataEntry(x: 3, y: 0)]
            let labels = ["Week 1", "Week 2", "Week 3", "Week 4"]
            weeklyBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:labels)
            if itemId != "" {
                for i in 1..<5 {
                    db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Dashboard").document("\(itemType)").collection(itemId).document("Month").collection(yearMonth).document("Week").collection("Week \(i)").getDocuments { documents, error in
                        
                        if error == nil {
                            if documents != nil {
                                
                                for doc in documents!.documents {
                                    
                                    let data = doc.data()
                                    
                                    if let total = data["totalPay"] {
                                        //                                self.weeklyData[i-1] = "\(total)"
                                        weeklyData[i-1] = BarChartDataEntry(x: Double(i), y: Double("\(total)")!)
                                        
                                        
                                        self.weeklyBarChart.data?.notifyDataChanged()
                                        print("2 \(i-1)")
                                        
                                        let set = BarChartDataSet(entries: weeklyData)
                                        set.colors = ChartColorTemplates.pastel()
                                        let data = BarChartData(dataSet: set)
                                        self.weeklyBarChart.data = data
                                        self.weeklyBarChart.xAxis.granularityEnabled = true
                                        self.weeklyBarChart.xAxis.drawGridLinesEnabled = false
                                        //            weeklyBarChart.xAxis.drawAxisLineEnabled = true
                                        self.weeklyBarChart.leftAxis.drawAxisLineEnabled = false
                                        self.weeklyBarChart.rightAxis.drawGridLinesEnabled = false
                                        self.weeklyBarChart.xAxis.drawAxisLineEnabled = true
                                        self.weeklyBarChart.leftAxis.drawAxisLineEnabled = true
                                        self.weeklyBarChart.rightAxis.drawAxisLineEnabled = true
                                        self.weeklyBarChart.leftAxis.drawGridLinesEnabled = false
                                        self.weeklyBarChart.xAxis.axisMinimum = 0.2
                                        self.weeklyBarChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
                                        self.weeklyBarChart.xAxis.labelCount = labels.count
                                        self.weeklyBarChart.xAxis.centerAxisLabelsEnabled = true
                                        
                                        let groupSpace = 0.1
                                        let barSpace = 0.05
                                        let barWidth = 0.25
                                        
                                        let gg = data.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
                                        //                weeklyBarChart.xAxis.axisMaximum = Double(0) + gg * 6
                                        self.weeklyBarChart.xAxis.axisMaximum = 4
                                        data.groupBars(fromX:0, groupSpace: groupSpace, barSpace: barSpace)
                                        self.weeklyBarChart.xAxis.labelCount = labels.count
                                        self.weeklyBarChart.xAxis.centerAxisLabelsEnabled = true
//                                        data.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
                                        
                                        self.weeklyBarChart.xAxis.granularityEnabled = true
                                        //            weeklyBarChart.xAxis.spaceMin = 0.3
                                        self.weeklyBarChart.xAxis.labelWidth = 1
                                        self.weeklyBarChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInOutQuart)
                                    }}}
                        }
                    }}
                
                
                //            entries.append(BarChartDataEntry(x: Double(total)!, y: i))
                //            entries.append(BarChartDataEntry(x: Double(total)!, y: i))
                //            entries.append(BarChartDataEntry(x: Double(total)!, y: i))
                //            entries.append(BarChartDataEntry(x: Double(total)!, y: i))
                
                
                
                
            }
        }
    }
    
    
    private func loadItemMonthlyData(itemTitle: String) {
        var itemType = ""
        if self.itemType.text == "Hair Items" { itemType = "hairItems" } else if self.itemType.text == "Makeup Items" { itemType = "makeupItems" } else if self.itemType.text == "Lash Items" { itemType = "lashItems" }
        if Auth.auth().currentUser != nil {
            var itemId = ""
            let year = "\(df.string(from: date))".prefix(4)
            var yearMonth = "\(year), \(month)"
            
            var monthlyData : [BarChartDataEntry] = [BarChartDataEntry(x: 0, y: 0), BarChartDataEntry(x: 1, y: 0), BarChartDataEntry(x: 2, y: 0), BarChartDataEntry(x: 3, y: 0), BarChartDataEntry(x: 4, y: 0), BarChartDataEntry(x: 5, y: 0)]
            var labels = ["January", "February", "March", "April", "May", "June"]
            
            print("date \(year), \(month)")
            if Int(month)! > 6 {
                labels = ["July", "August", "September", "October", "November", "December"]
            }
            
            var newMonth = monthStart
            
            for i in 0..<items.count {
                if items[i].itemTitle == itemTitle {
                    itemId = items[i].documentId
                }
            }
            
            for i in Int(monthStart)!-1..<Int(monthEnd)!-1 {
                
                print("month number statr \(newMonth)")
                if i != 1 || i != 7 {
                    newMonth = "\(i + 1)"
                    if Int(newMonth)! < 10 {
                        newMonth = "0\(newMonth)"
                    }
                }
                yearMonth = "\(year), \(newMonth)"
                print("path Beautician/\(Auth.auth().currentUser!.uid)/Dashboard/\(itemType)/\(itemId)/Month/\(yearMonth)")
               
                db.collection("Beautician").document(Auth.auth().currentUser!.uid).collection("Dashboard").document("\(itemType)").collection(itemId).document("Month").collection(yearMonth).document("Total").getDocument { document, error in
                    
                    if error == nil {
                        if document != nil {
                            if let total = document!.get("totalPay") {
                                if self.monthStart == "01" {
                                    monthlyData[i] = BarChartDataEntry(x: Double(i), y: Double("\(total)")!)
                                } else {
                                    monthlyData[i-6] = BarChartDataEntry(x: Double(i-6), y: Double("\(total)")!)
                                }
                                
                                self.monthlyBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:labels)
                                let set = BarChartDataSet(entries: monthlyData)
                                set.colors = ChartColorTemplates.pastel()
                                let data = BarChartData(dataSet: set)
                                
                                let groupSpace = 0.1
                                let barSpace = 0.05
                                let barWidth = 0.25
                                
                                let gg = data.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
                                //            monthlyBarChart.xAxis.axisMaximum = Double(0) + gg * 6
                                self.monthlyBarChart.xAxis.axisMaximum = 6
                                self.monthlyBarChart.xAxis.axisMinimum = 0
                                data.groupBars(fromX:0, groupSpace: groupSpace, barSpace: barSpace)
//                                data.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
                                
                                self.monthlyBarChart.xAxis.granularityEnabled = true
                                self.monthlyBarChart.data = data
                                self.monthlyBarChart.xAxis.drawGridLinesEnabled = false
                                //        monthlyBarChart.xAxis.drawAxisLineEnabled = true
                                self.monthlyBarChart.leftAxis.drawAxisLineEnabled = false
                                self.monthlyBarChart.rightAxis.drawGridLinesEnabled = false
                                self.monthlyBarChart.leftAxis.drawGridLinesEnabled = false
                                self.monthlyBarChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
                                //        monthlyBarChart.xAxis.axisMinimum = 4.0
                                
                                self.monthlyBarChart.leftAxis.drawAxisLineEnabled = true
                                self.monthlyBarChart.rightAxis.drawAxisLineEnabled = true
                                self.monthlyBarChart.leftAxis.drawGridLinesEnabled = false
                                self.monthlyBarChart.xAxis.axisMinimum = 0.2
                                self.monthlyBarChart.xAxis.labelCount = labels.count
                                self.monthlyBarChart.xAxis.centerAxisLabelsEnabled = true
                                
                                //        monthlyBarChart.xAxis.spaceMin = 0.8
                                self.monthlyBarChart.xAxis.labelWidth = 1
                                self.monthlyBarChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInOutQuart)
                                
                            }
                        }
                    }
                }
            }
        }
        
           
    
    }
    
    
}
