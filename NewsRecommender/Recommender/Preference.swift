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

    @objc dynamic var TF = 0.0                        //keywordCount / totalKeywordCount
    override static func primaryKey() -> String? {
        return "keyword"
    }
}


class TotalNews: Object {
    @objc dynamic var count = 0
}


class KeywordPreferenceManager: NSObject {
    class func processNews(newsArray:Array<News>, done: @escaping () -> Void){
        var textArray : [String] = []
        for news in newsArray{
            let text = (news.titleText ?? "") + " " + (news.descriptionText ?? "")
            textArray.append(text)
        }
        // Get the default Realm
        let realm = try! Realm()
        
        
        ServicesContainer.shared.keywordServices().getKeywords(texts: textArray,onSuccess: {  array in
            
            let totalNewsCount = realm.objects(TotalNews.self).first
            if totalNewsCount == nil{
                let count = TotalNews()
                count.count = array.count
                try! realm.write {
                    realm.add(count)
                }
            }else{
                try! realm.write {
                    totalNewsCount?.count = totalNewsCount!.count + array.count
                }
            }
            
            for news in array{
                let totalKeywordCount =  news.map({$0.count}).reduce(0, +)
                for keyword in news{
                    let keywordPreference = realm.objects(KeywordPreference.self).filter("keyword = '\(keyword.keyword)'").first
                    if keywordPreference == nil{
                        let keywordPreference = KeywordPreference()
                        keywordPreference.keyword = keyword.keyword
                        keywordPreference.keywordCount = keyword.count
                        keywordPreference.newsCount = 1
                        keywordPreference.totalKeywordCount = totalKeywordCount
                        keywordPreference.TF = Double(keyword.count) / Double(totalKeywordCount)
                        try! realm.write {
                            realm.add(keywordPreference)
                        }
                        
                    }
                    else{
                        let updatedkeywordPreference = KeywordPreference()
                        updatedkeywordPreference.keyword = keyword.keyword
                        updatedkeywordPreference.keywordCount = keyword.count + (keywordPreference?.keywordCount ?? 0)
                        updatedkeywordPreference.newsCount = 1 + (keywordPreference?.newsCount ?? 0)
                        updatedkeywordPreference.totalKeywordCount = totalKeywordCount + (keywordPreference?.totalKeywordCount ?? 0)
                        updatedkeywordPreference.TF = Double(updatedkeywordPreference.keywordCount) / Double(updatedkeywordPreference.totalKeywordCount)
                        try! realm.write {
                            realm.add(updatedkeywordPreference, update:  true)
                        }
                                            }
                }
                done()

            }
        }) { (error) in
            done()
        }
    }
    
    class func likeNews(news:News?, done: @escaping () -> Void){
        if let news = news{
            KeywordPreferenceManager.processNews(newsArray:[news], done: {
                done()
            })
        }
    }
    
    class func unlikeNews(news:News?){
        if let news = news{
            let realm = try! Realm()
        let text = (news.titleText ?? "") + " " + (news.descriptionText ?? "")
        ServicesContainer.shared.keywordServices().getKeywords(text: text,onSuccess: {  array in
            
            let totalNewsCount = realm.objects(TotalNews.self).first
            if totalNewsCount == nil{
                let count = TotalNews()
                count.count = 0
                try! realm.write {
                    realm.add(count)
                }
            }else{
                try! realm.write {
                    if totalNewsCount!.count > 0{
                        totalNewsCount?.count = totalNewsCount!.count - 1}
                    else{
                        totalNewsCount?.count = 0
                    }
                }
            }
            
                let totalKeywordCount =  array.map({$0.count}).reduce(0, +)
                for keyword in array{
                    let keywordPreference = realm.objects(KeywordPreference.self).filter("keyword = '\(keyword.keyword)'").first
                    if keywordPreference != nil{
                        let updatedkeywordPreference = KeywordPreference()
                        updatedkeywordPreference.keyword = keyword.keyword
                        updatedkeywordPreference.keywordCount =  (keywordPreference?.keywordCount ?? 0) - keyword.count
                        updatedkeywordPreference.newsCount =  (keywordPreference?.newsCount ?? 0) - 1
                        updatedkeywordPreference.totalKeywordCount = (keywordPreference?.totalKeywordCount ?? 0) - totalKeywordCount
                        updatedkeywordPreference.TF = Double(updatedkeywordPreference.keywordCount) / Double(updatedkeywordPreference.totalKeywordCount)
                        try! realm.write {
                            realm.add(updatedkeywordPreference, update:  true)
                        }
                    }
                }
            
        }) { (error) in
            
        }
        }
    }
    
    class func dislikeNews(news:News?){
        if let news = news{
            let realm = try! Realm()
            let text = (news.titleText ?? "") + " " + (news.descriptionText ?? "")
            ServicesContainer.shared.keywordServices().getKeywords(text: text,onSuccess: {  array in
                for keyword in array{
                    let keywordPreference = realm.objects(KeywordPreference.self).filter("keyword = '\(keyword.keyword)'").first
                    if keywordPreference != nil{
                        if (keywordPreference!.newsCount > 0){
                        let updatedkeywordPreference = KeywordPreference()
                        updatedkeywordPreference.keyword = keyword.keyword
                        updatedkeywordPreference.keywordCount =  (keywordPreference!.keywordCount) - (keywordPreference!.keywordCount / keywordPreference!.newsCount)
                        updatedkeywordPreference.newsCount =  (keywordPreference?.newsCount ?? 0) - 1
                       
                        updatedkeywordPreference.TF = Double(updatedkeywordPreference.keywordCount) / Double(updatedkeywordPreference.totalKeywordCount)
                        try! realm.write {
                            realm.add(updatedkeywordPreference, update:  true)
                        }
                        }
                    }
                }
            }) { (error) in
                
            }
        }
    }
    
}
