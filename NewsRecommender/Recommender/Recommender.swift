//
//  Recommender.swift
//  NewsRecommender
//
//  Created by mun on 12/5/18.
//  Copyright © 2018 mun. All rights reserved.
//

import Foundation
import RealmSwift

class Recommender: NSObject{
    static let maxNewsForEachCategory = 20
    static let maxRecommendNews = 10
    
    class func getRecommendedNews(onSuccess: @escaping ([News]) -> Void){
        let savedCategories = NewsCategoryManager.getSavedCategories()
        var newsArray : [News] = []
        var count = 0
        for category in savedCategories{
            Recommender.getTopNews(category: category, maxNews: Int((Double(Recommender.maxRecommendNews)/Double(savedCategories.count)).rounded(.up)), onSuccess: {array in
                newsArray.append(contentsOf: array)
                count += 1
                if count == savedCategories.count{
                    onSuccess(newsArray)
                }
            })
        }
    }
    
    class func getTopNews(category: String, maxNews: Int,onSuccess: @escaping ([News]) -> Void){
        var newNewsArray : [News] = []
       var count = 0
        
        let sort = {
            newNewsArray = newNewsArray.sorted(by: { $0.cosineValue > $1.cosineValue })
            onSuccess(Array(newNewsArray.prefix(maxNews)))
        }
        ServicesContainer.shared.newsServices().getNews(category:category,limit:Recommender.maxNewsForEachCategory,onSuccess: {  array in
            
            for news in array{
                Recommender.getCosineSimilarity(news: news, onSuccess: {
                    cosineValue in
                    var newNews = news
                    newNews.cosineValue = cosineValue
                    newNewsArray.append(newNews)
                    count += 1
                    if count == Recommender.maxNewsForEachCategory{
                        sort()
                    }
                }, onError: {error in
                    count += 1
                    if count == Recommender.maxNewsForEachCategory{
                        sort()
                    }
                    
                })
            }
        }) { (error) in
            onSuccess([])
        }
       
        
    }
    
    
    
    class func getCosineSimilarity(news: News, onSuccess: @escaping (Double) -> Void, onError: @escaping (Error) -> Void){
        let realm = try! Realm()
        let keywordPreferences = realm.objects(KeywordPreference.self)
        
        let text = (news.titleText ?? "") + " " + (news.descriptionText ?? "")
        ServicesContainer.shared.keywordServices().getKeywords(text: text, onSuccess: {  keywordArray in
            let totalKeywordCount =  keywordArray.map({$0.count}).reduce(0, +)
            var keywordValueArray : [KeywordPreference] = []
            for keyword in keywordArray{
                let keywordPreference = KeywordPreference()
                keywordPreference.keyword = keyword.keyword
                keywordPreference.keywordCount = keyword.count
                keywordPreference.totalKeywordCount = totalKeywordCount
                keywordPreference.TF = Double(keyword.count) / Double(totalKeywordCount)
                keywordValueArray.append(keywordPreference)
            }
            
            var value = 0.0 //sum(ai*bi)
            for keyword in keywordValueArray{
                let keywordPreference = keywordPreferences.filter("keyword = '\(keyword.keyword)'").first
                if keywordPreference != nil{
                    value += keywordPreference!.TF * keyword.TF
                }
            }
            
            var value2 = 0.0 //sqrt(sum(ai))
            let realm = try! Realm()
            for keyword in realm.objects(KeywordPreference.self){
                value2 += keyword.TF * keyword.TF
            }
            value2 = sqrt(value2)
            
            var value3 = 0.0 //sqrt(sum(bi))
            for keyword in keywordValueArray{
                value3 += keyword.TF * keyword.TF
            }
            value3 = sqrt(value3)
            
            let cosineValue = value / (value2 * value3)
            onSuccess(cosineValue)
        }, onError: {error in
            onError(error)
        })
    }
}
