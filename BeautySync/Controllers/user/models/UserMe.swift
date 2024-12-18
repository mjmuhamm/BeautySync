//
//  UserMe.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/17/24.
//

import Foundation


struct Reviews {
    
    let itemType: String
    let itemTitle: String
    let orderDate: String
    let userThoughts: String
    let doesTheUserRecommend: String
    let expectations: Int
    let quality: Int
    let beauticianRating: Int
    let userLikes: [String]
    
}

struct Beauticians {
    
    let beauticianCity: String
    let beauticianImageId: String
    let beauticianPassion: String
    let beauticianState: String
    let beauticianUsername: String
    let itemCount: Int
    let documentId: String
    
}
