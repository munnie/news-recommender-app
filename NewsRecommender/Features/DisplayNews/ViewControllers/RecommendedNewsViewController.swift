//
//  RecommendedNewsViewController.swift
//  NewsRecommender
//
//  Created by mun on 12/14/18.
//  Copyright © 2018 mun. All rights reserved.
//

import UIKit
import SkeletonView
import RealmSwift
import SVProgressHUD
class RecommendedNewsViewController: UIViewController {
    var pickedNews:Array<News> = []
    var allNews:Array<News> = []
    @IBOutlet var tableView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpNavigationbar()
        tableView?.register(UINib.init(nibName: "NewsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NewsTableViewCell")
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 300
        tableView?.isSkeletonable = true
        //tableView?.showSkeleton()
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let savedCategories = NewsCategoryManager.getSavedCategories()
        let realm = try! Realm()
        let keyword = realm.objects(KeywordPreference.self)
        
        if savedCategories.count > 0 && keyword.count > 0 && (keyword.map({$0.newsCount}).reduce(0, +) > 0 ) {
        if(self.allNews.count == 0){
        SVProgressHUD.show()
        Recommender.getRecommendedNews(onSuccess: { [weak self] array in
            SVProgressHUD.dismiss()
            self?.allNews = array
            self?.tableView?.hideSkeleton()
            self?.tableView?.reloadData()
        })
        }
        }
    }
    
    func setUpNavigationbar(){
        self.navigationItem.title = "Top news for you"
        let next = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadTapped))
        
        navigationItem.rightBarButtonItems = [next]
    }
    
    @objc func reloadTapped(){
        SVProgressHUD.show()
        Recommender.getRecommendedNews(onSuccess: { [weak self] array in
             SVProgressHUD.dismiss()
            self?.allNews = array
            self?.tableView?.hideSkeleton()
            self?.tableView?.reloadData()
        })
    }
}


extension RecommendedNewsViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell") as! NewsTableViewCell
        cell.delegate = self
        let news = allNews[indexPath.row]
        cell.loadData(news: news)
        //cell.dislikeButtonHeight?.constant = 0
        
        if pickedNews.contains(where: {$0.titleText == news.titleText}){
            cell.likeButton?.backgroundColor = UIColor.pomegranate
        }
        else{
            cell.likeButton?.backgroundColor = UIColor.nephritis
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = WebViewController.initWithStoryBoard(storyBoardName: "Main", identifier: "WebViewController") as! WebViewController
        let news = allNews[indexPath.row]
        vc.urlString = news.url
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
}

extension RecommendedNewsViewController: NewsTableViewCellDelegate{
    func newsTableViewCellDidLikeNews(news: News?) {
        if let news = news{
            if pickedNews.contains(where: {$0.titleText == news.titleText}){
                pickedNews.removeAll(where: {$0.titleText == news.titleText})
                KeywordPreferenceManager.unlikeNews(news: news)
            }
            else{
                pickedNews.append(news)
                SVProgressHUD.show()
                KeywordPreferenceManager.likeNews(news: news, done: {
                    SVProgressHUD.dismiss()
                })
            }
            tableView?.reloadData()
            
            
            
        }
    }
    
    func newsTableViewCellDidDislikeNews(news: News?) {
        KeywordPreferenceManager.dislikeNews(news: news)
        if let news = news{
            
     
            if let index = allNews.firstIndex(where: {$0.titleText == news.titleText}){
                allNews.removeAll(where: {$0.titleText == news.titleText})
           let indexPath = IndexPath.init(row: index, section: 0)
                tableView?.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            }
            
            tableView?.reloadData()
            
        }
        
    }
    
    
    
    
}


extension RecommendedNewsViewController: SkeletonTableViewDataSource {
    
 
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "NewsTableViewCell"
    }
    
    
}
