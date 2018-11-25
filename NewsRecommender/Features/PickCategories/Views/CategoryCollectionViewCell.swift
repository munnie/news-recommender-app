//
//  CategoryCollectionViewCell.swift
//  NewsRecommender
//
//  Created by mun on 11/24/18.
//  Copyright © 2018 mun. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet var backgroundImgView: UIImageView?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var pickView: UIView?
    
    func loadData(data: NewsCategory, pickedArray: Array<String>){
        backgroundImgView?.image = UIImage.init(named: data.image)
        titleLabel?.text = data.displayName
        if pickedArray.contains(data.name){
            pickView?.alpha = 1
        }
        else{
            pickView?.alpha = 0
        }
    }
}
