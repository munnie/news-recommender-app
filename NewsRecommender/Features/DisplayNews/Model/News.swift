//
//  News.swift
//  NewsRecommender
//
//  Created by mun on 11/25/18.
//  Copyright © 2018 mun. All rights reserved.
//

import Foundation
import ObjectMapper

struct News: Mappable {
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        titleText    <- map["title"]
        descriptionText    <- map["description"]
        url    <- map["url"]
        urlToImage    <- map["urlToImage"]
    }
    
    var titleText: String?
    var descriptionText : String?
    var url: String?
    var urlToImage: String?
    var cosineValue = 0.0
}
