//
//  ServiceContainer.swift
//  NewsRecommender
//
//  Created by mun on 11/25/18.
//  Copyright © 2018 mun. All rights reserved.
//

import Foundation
import Swinject

class ServicesContainer: NSObject {
    
    static let shared = ServicesContainer()
    private let container: Container
    
    override init() {
        container = Container()
        container.register(NewsServiceProtocol.self) { _ in
            return NewsService()
        }
        container.register(KeywordServiceProtocol.self) { _ in
            return KeywordService()
        }
    }
    
    func newsServices() -> NewsServiceProtocol {
        return container.resolve(NewsServiceProtocol.self)!
    }
    
    func keywordServices() -> KeywordServiceProtocol {
        return container.resolve(KeywordServiceProtocol.self)!
    }
    
}
