//
//  ServiceItem.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/7/24.
//

import Foundation
import UIKit

struct ServiceImage {
    let image: UIImage
    let imgPath: String
}

struct ServiceItems {
    
    let itemType: String
    let itemTitle: String
    var itemImage: UIImage?
    let itemDescription: String
    let itemPrice: String
    let imageCount: Int
    let beauticianUsername: String
    var beauticianUserImage: UIImage?
    let beauticianPassion: String
    let beauticianCity: String
    let beauticianState: String
    let beauticianImageId: String
    var liked: [String]
    let itemOrders: Int
    let itemRating: [Int]
    let hashtags: [String]
    let documentId: String
    
}
