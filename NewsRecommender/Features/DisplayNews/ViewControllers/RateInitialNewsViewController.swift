//
//  RateInitialNewsViewController.swift
//  NewsRecommender
//
//  Created by mun on 11/26/18.
//  Copyright © 2018 mun. All rights reserved.
//

import UIKit
import SkeletonView

class RateInitialNewsViewController: UIViewController {
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let categories = NewsCategoryManager.getSavedCategories()
        
        ServicesContainer.shared.newsServices().getNews(categories:categories,limit:20,onSuccess: { [weak self] array in
                self?.allNews = array
                self?.tableView?.reloadData()
        }) { (error) in
            
        }
    }
    
    func setUpNavigationbar(){
        self.navigationItem.title = "Rate some news"
        let next = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        
        navigationItem.rightBarButtonItems = [next]
    }
    
    @objc func doneTapped(){
        if pickedNews.count >= 1 {
            KeywordPreferenceManager.processNews(newsArray: pickedNews)
        }
        else{
            let alert = UIAlertController.init(title: nil, message: "Please pick at least 5 news", preferredStyle: .alert)
            let cancelAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension RateInitialNewsViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell") as! NewsTableViewCell
        cell.delegate = self
        let news = allNews[indexPath.row]
        cell.loadData(news: news)
        cell.dislikeButtonHeight?.constant = 0
        
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

extension RateInitialNewsViewController: NewsTableViewCellDelegate{
    func newsTableViewCellDidLikeNews(news: News?) {
        if let news = news{
        if pickedNews.contains(where: {$0.titleText == news.titleText}){
            pickedNews.removeAll(where: {$0.titleText == news.titleText})
        }
        else{
            pickedNews.append(news)
        }
        tableView?.reloadData()
            
            
            
        }
    }
    
    func newsTableViewCellDidDislikeNews(news: News?    ) {
        
    }
    
    
    
}
