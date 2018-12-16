//
//  KeywordService.swift
//  NewsRecommender
//
//  Created by mun on 11/30/18.
//  Copyright © 2018 mun. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class KeywordService: KeywordServiceProtocol {
    
    static var cachedKeywords : [(text: String , keywords: [(keyword: String, count: Int)])] = []
    
    func getKeywords(texts: Array<String>, onSuccess: @escaping (Array<Array<(keyword: String, count: Int)>>) -> Void, onError: @escaping (Error) -> Void) {
        var keywordsArray : Array<Array<(keyword: String, count: Int)>> = []
        var count = 0
        
        for text in texts{
            self.getKeywords(text: text, onSuccess: {keywords in
                keywordsArray.append(keywords)
                count += 1
                if count == texts.count{
                    onSuccess(keywordsArray)
                }
            }, onError: {
                error in onError(error)
            })
        }
        
    }
    
    func getKeywords(text: String, onSuccess: @escaping (Array<(keyword: String, count: Int)>) -> Void, onError: @escaping (Error) -> Void) {
        
        if let cached = KeywordService.cachedKeywords.filter({$0.text == text}).first {
            onSuccess(cached.keywords)
            return
        }
        
        let url = Constants.keywordBaseURL + Constants.extractkeyWordPath + "?retina_name=en_associative"
        var parameter : Dictionary<String, String> = [:]
       
        //parameter.updateValue("en_associative", forKey: "retina_name")
        parameter.updateValue(text, forKey: "")
        let headers: HTTPHeaders = [
            "api-key": Constants.keywordAPIKey,
            "Content-Type": "text/plain"
        ]
        
        Alamofire.request(url, method: .post, parameters: parameter,
                         // encoding: JSONStringArrayEncoding.init(string: text),
            headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
                 print(response)
            switch response.result {
            case .success(let data):
               
                guard let data = data as? Array<String>
                    else  {
                        onError(NSError.init(domain: "", code: 404, userInfo: nil))
                        return
                }
                var keywordsCountArray: [(keyword: String, count: Int)] = []
                for keyword in data{
                    let keyword_count = text.countInstances(of: keyword)
                    let result = (keyword: keyword, count : keyword_count)
                    keywordsCountArray.append(result)
                }
                
                KeywordService.cachedKeywords.append((text: text, keywords: keywordsCountArray))
                onSuccess(keywordsCountArray)
                
            case .failure(let error):
                onError(error)
            }
        }
        
    }
    
    deinit {
        print("Service has been released!")
    }
}


struct JSONStringArrayEncoding: ParameterEncoding {
    private let myString: String
    
    init(string: String) {
        self.myString = string
    }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest.urlRequest
        
        let data = myString.data(using: .utf8)!
        
        if urlRequest?.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest?.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest?.httpBody = data
        
        return urlRequest!
    }}
