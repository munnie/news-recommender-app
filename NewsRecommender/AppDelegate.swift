//
//  AppDelegate.swift
//  NewsRecommender
//
//  Created by mun on 11/19/18.
//  Copyright © 2018 mun. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let tabBarController = UIApplication.shared.delegate?.window??.rootViewController as! UITabBarController
        let savedCategories = NewsCategoryManager.getSavedCategories()
        if savedCategories.count == 0 {
            let vc = PickCategoriesViewController.initWithStoryBoard(storyBoardName: "Main", identifier: "PickCategoriesViewController") as! PickCategoriesViewController
            vc.setUpNavigationbar()
            let nav = UINavigationController.init(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.window?.makeKeyAndVisible()
            tabBarController.present(nav, animated: true, completion: {})
        }
        else{
            let realm = try! Realm()
            let keyword = realm.objects(KeywordPreference.self)
            
            if keyword.count == 0 && (keyword.map({$0.newsCount}).reduce(0, +) <= 0 ){
                let vc = RateInitialNewsViewController.initWithStoryBoard(storyBoardName: "Main", identifier: "RateInitialNewsViewController") as! RateInitialNewsViewController
                let nav = UINavigationController.init(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.window?.makeKeyAndVisible()
                tabBarController.present(nav, animated: true, completion: {})
            }
        }
       
//        ServicesContainer.shared.keywordServices().getKeywords(texts: ["'Worthless' Bitcoin Has Entered Death Spiral: Finance Professor Finance professor Atuyla Sarin wrote in an op-ed that the bitcoin price has entered a \"death spiral\" and that the crypto is \"close to worthless.\""],onSuccess: {  array in
//            for news in array{
//                let totalKeywordCount =  news.map({$0.count}).reduce(0, +)
//            }}){ (error) in
//                
//        }
        
        
        UITabBar.appearance().tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

