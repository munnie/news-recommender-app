//
//  UIViewControllerExtension.swift
//  NewsRecommender
//
//  Created by mun on 11/25/18.
//  Copyright © 2018 mun. All rights reserved.
//

import UIKit

extension UIViewController{
    class func initWithStoryBoard(storyBoardName: String, identifier: String) -> UIViewController{
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let identifier = String(describing: self)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        return controller
    }
}
