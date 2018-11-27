//
//  NewsService.swift
//  NewsRecommender
//
//  Created by mun on 11/25/18.
//  Copyright © 2018 mun. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class NewsService: NewsServiceProtocol {
    
    func getNews(categories: Array<String>, limit: Int, onSuccess: @escaping (Array<News>) -> Void, onError: @escaping (Error) -> Void) {
        var newsArray : Array<News> = []
        var count = 0
        
        for category in categories{
            self.getNews(category: category, limit: (limit/categories.count > 0) ? limit/categories.count : 1, onSuccess: {news in
                newsArray.append(contentsOf: news)
                count += 1
                if count == categories.count{
                    onSuccess(newsArray)
                }
            }, onError: {
                error in onError(error)
            })
        }
        
    }
    
    func getNews(category: String, limit:Int, onSuccess: @escaping (Array<News>) -> Void, onError: @escaping (Error) -> Void) {
        let url = Constants.newsBaseURL + Constants.topNewsPath
        var parameter : Dictionary<String, String> = [:]
        parameter.updateValue(String(limit), forKey: "pageSize")
        parameter.updateValue("us", forKey: "country")
        if category != "" {
            parameter.updateValue(category, forKey: "category")
        }
        
        let headers: HTTPHeaders = [
            "Authorization": Constants.newsAPIKey,
            "Accept": "application/json"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: headers).validate().responseJSON { (response) in
            switch response.result {
            case .success(let data):
                var arr : Array<News> = []
                
                guard let data = data as? [String: Any], let array = data["articles"] as? Array<[String:Any]>
                    else  {
                    onError(NSError.init(domain: "", code: 404, userInfo: nil))
                    return
                }
                
                for value in array{
                    if let news = News(JSON: value){
                        arr.append(news)
                    }
                }
                onSuccess(arr)
                
            case .failure(let error):
                onError(error)
            }
        }
        
    }
    
    deinit {
        print("Service has been released!")
    }
}
