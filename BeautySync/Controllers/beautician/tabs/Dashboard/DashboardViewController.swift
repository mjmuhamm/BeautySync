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

    @IBOutlet weak var itemType: MDCOutlinedTextField!
    @IBOutlet weak var itemTitle: MDCOutlinedTextField!
    
    let itemTypeMenu = DropDown()
    let itemMenu = DropDown()
    
    @IBOutlet weak var weeklyButton: MDCButton!
    @IBOutlet weak var monthlyButton: MDCButton!
    @IBOutlet weak var totalButton: MDCButton!
    
    @IBOutlet weak var weeklyBarChart: BarChartView!
    @IBOutlet weak var monthlyBarChart: BarChartView!
    @IBOutlet weak var totalPieChart: PieChartView!
    
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
        itemTypeMenu.dataSource = ["Hair Items", "Makeup Items", "Lash Items"]
        itemTypeMenu.anchorView = itemType
        
        itemTypeMenu.selectionAction = { index, item in
            self.itemType.text = item
            if self.time != "Yearly" {
//            self.loadFoodItems(itemType: item)
            } else {
//            self.loadItemYearlyData(itemTitle: item)
            }
        }
        itemMenu.anchorView = itemTitle
        itemMenu.selectionAction = { index, item in
            self.itemTitle.text = item
            if self.time == "Weekly" {
//                self.loadItemWeeklyData(itemTitle: item)
            } else if self.time == "Monthly" {
//                self.loadItemMonthlyData(itemTitle: item)
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
        weeklyBarChart.isHidden = false
        monthlyBarChart.isHidden = true
        totalPieChart.isHidden = true
        
        weeklyButton.setTitleColor(UIColor.white, for: .normal)
        weeklyButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        monthlyButton.backgroundColor = UIColor.white
        monthlyButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        totalButton.backgroundColor = UIColor.white
        totalButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        
        
        
    }
    
    @IBAction func monthlyButtonPressed(_ sender: Any) {
        weeklyBarChart.isHidden = true
        monthlyBarChart.isHidden = false
        totalPieChart.isHidden = true
        
        weeklyButton.backgroundColor = UIColor.white
        weeklyButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        monthlyButton.setTitleColor(UIColor.white, for: .normal)
        monthlyButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        totalButton.backgroundColor = UIColor.white
        totalButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func totalButtonPressed(_ sender: Any) {
        weeklyBarChart.isHidden = true
        monthlyBarChart.isHidden = true
        totalPieChart.isHidden = false
        
        weeklyButton.backgroundColor = UIColor.white
        weeklyButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        monthlyButton.backgroundColor = UIColor.white
        monthlyButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        totalButton.setTitleColor(UIColor.white, for: .normal)
        totalButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
    }
    
}
