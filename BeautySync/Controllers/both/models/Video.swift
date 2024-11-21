//
//  Video.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/20/24.
//

import Foundation

struct VideoModel {
    
    let dataUri: String
    let documentId: String
    let userImageId: String
    let user: String
    let description: String
    let views: Int
    var liked: [String]
    var comments: Int
    var shared: Int
    var thumbNailUrl: String
    
}
