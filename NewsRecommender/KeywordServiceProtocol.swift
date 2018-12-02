//
//  KeywordServiceProtocol.swift
//  NewsRecommender
//
//  Created by mun on 11/30/18.
//  Copyright © 2018 mun. All rights reserved.
//

import Foundation

protocol KeywordServiceProtocol {
    func getKeywords(text: String , onSuccess: @escaping (Array<String>) -> Void, onError: @escaping (Error) -> Void)
     func getKeywords(texts: Array<String>, onSuccess: @escaping (Array<Array<(keyword: String, count: Int)>>) -> Void, onError: @escaping (Error) -> Void) 
}
