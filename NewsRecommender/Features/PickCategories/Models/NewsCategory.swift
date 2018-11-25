//
//  NewsCategory.swift
//  NewsRecommender
//
//  Created by mun on 11/24/18.
//  Copyright © 2018 mun. All rights reserved.
//

import UIKit

struct NewsCategory {
    let name: String!
    let displayName: String!
    let image: String!
}

class NewsCategoryManager: NSObject{
    static let kCategoryBusiness = "business"
    static let kCategoryEntertainment = "entertainment"
    static let kCategoryGeneral = "general"
    static let kCategoryHealth = "health"
    static let kCategoryScience = "science"
    static let kCategorySports = "sports"
    static let kCategoryTechnology = "technology"

    static let kPickedCategories = "kPickedCategories"
    
    static let sharedInstance = NewsCategoryManager()
    lazy var allCategories: Array<NewsCategory> = {
        return [NewsCategory.init(name: NewsCategoryManager.kCategoryBusiness, displayName: "Business", image: ""),
                NewsCategory.init(name: NewsCategoryManager.kCategoryEntertainment, displayName: "Entertainment", image: ""),
                NewsCategory.init(name: NewsCategoryManager.kCategoryGeneral, displayName: "General", image: "general"),
                NewsCategory.init(name: NewsCategoryManager.kCategoryHealth, displayName: "Health", image: ""),
                NewsCategory.init(name: NewsCategoryManager.kCategoryScience, displayName: "Science", image: ""),
                NewsCategory.init(name: NewsCategoryManager.kCategorySports, displayName: "Sports", image: ""),
                NewsCategory.init(name: NewsCategoryManager.kCategoryTechnology, displayName: "Technology", image: "")]
    }()
    
    class func saveCategories(data: Array<String>){
        UserDefaults.standard.set(data, forKey: kPickedCategories)
    }
    
    class func getSavedCategories() -> Array<String>{
        if let value = UserDefaults.standard.value(forKey: kPickedCategories) as? Array<String>{
            return value
        }
        return []
    }
}
