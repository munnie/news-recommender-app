//
//  NewsTableViewCell.swift
//  NewsRecommender
//
//  Created by mun on 11/26/18.
//  Copyright © 2018 mun. All rights reserved.
//

import UIKit
import AlamofireImage

protocol NewsTableViewCellDelegate: class{
    func newsTableViewCellDidLikeNews(news:News?)
    func newsTableViewCellDidDislikeNews(news:News?)
}

class NewsTableViewCell: UITableViewCell {
    @IBOutlet var imgView: UIImageView?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var contentLabel: UILabel?
    
    @IBOutlet var dislikeButtonHeight: NSLayoutConstraint?
    @IBOutlet var imageViewHeight: NSLayoutConstraint?
    
    @IBOutlet var likeImageView : UIImageView?
    @IBOutlet var dislikeImageView : UIImageView?

    @IBOutlet var likeButton : UIView?
    @IBOutlet var dislikeButton : UIView?
    
    @IBAction func tapLikeButton(){
        delegate?.newsTableViewCellDidLikeNews(news: self.news ?? nil)
    }
    
    @IBAction func tapDislikeButton(){
        delegate?.newsTableViewCellDidDislikeNews(news: self.news ?? nil)
    }
    
    var news: News?
    weak var delegate: NewsTableViewCellDelegate?
    
    func loadData(news: News){
        self.news = news
        likeImageView?.tintColor = UIColor.white
        imgView?.image = nil
        if let url = URL.init(string: news.urlToImage ?? ""){
            imgView?.af_setImage(withURL: url)
            imageViewHeight?.constant = 170
        }
        else{
            imageViewHeight?.constant = 0
        }
        titleLabel?.text = news.titleText
        contentLabel?.text = news.descriptionText
    }
}
