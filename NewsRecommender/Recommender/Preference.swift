//
//  Preference.swift
//  NewsRecommender
//
//  Created by mun on 11/27/18.
//  Copyright © 2018 mun. All rights reserved.
//

import Foundation
import RealmSwift

class KeywordPreference: Object {
    @objc dynamic var keyword = ""
    @objc dynamic var keywordCount = 0              //number of times this keyword appear
    @objc dynamic var totalKeywordCount = 0         //number of times all keyword appear
    @objc dynamic var newsCount = 0                 //number of news have this keyword
}


class TotalNews: Object {
    @objc dynamic var count = 0
}
