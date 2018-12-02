//
//  Constants.swift
//  NewsRecommender
//
//  Created by mun on 11/19/18.
//  Copyright © 2018 mun. All rights reserved.
//

import Foundation

class Constants {
    // App constants
    static let animationDuration = 0.25
    
    //API key
    static let newsAPIKey = "235f1a015d2a49ad861d8668d4a70db1"
    static let keywordAPIKey = "d4afad90-f4ae-11e8-bb65-69ed2d3c7927"
    
    // Base URLs
    static let newsBaseURL = "https://newsapi.org/v2"
    static let keywordBaseURL = "http://api.cortical.io/rest"
    
    // Paths
    static let topNewsPath = "/top-headlines"
    static let extractkeyWordPath = "/text/keywords"
}

