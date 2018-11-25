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
    }
    
    func loanServices() -> NewsServiceProtocol {
        return container.resolve(NewsServiceProtocol.self)!
    }
    
}
