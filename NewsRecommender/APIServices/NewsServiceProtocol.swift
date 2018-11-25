//
//  NewsServiceProtocol.swift
//  NewsRecommender
//
//  Created by mun on 11/24/18.
//  Copyright © 2018 mun. All rights reserved.
//

import Foundation

protocol NewsServiceProtocol {
    func getNews(category: String, limit:Int , onSuccess: @escaping (Array<News>) -> Void, onError: @escaping (Error) -> Void)
}
