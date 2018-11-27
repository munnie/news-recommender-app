//
//  PickCategoriesViewController.swift
//  NewsRecommender
//
//  Created by mun on 11/24/18.
//  Copyright © 2018 mun. All rights reserved.
//

import UIKit

class PickCategoriesViewController: UIViewController {
    var pickedCategories:Array<String> = []
    @IBOutlet var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView?.register(UINib.init(nibName: "CategoryCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
       
    }
    
    func setUpNavigationbar(){
        self.navigationItem.title = "Favorite Categories"
        let next = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(nextTapped))
        
        navigationItem.rightBarButtonItems = [next]
    }
    
    @objc func nextTapped(){
        if pickedCategories.count > 0 {
            NewsCategoryManager.saveCategories(data: pickedCategories)
            let vc = RateInitialNewsViewController.initWithStoryBoard(storyBoardName: "Main", identifier: "RateInitialNewsViewController")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let alert = UIAlertController.init(title: nil, message: "Please pick at least 1 category", preferredStyle: .alert)
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

extension PickCategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NewsCategoryManager.sharedInstance.allCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        let category = NewsCategoryManager.sharedInstance.allCategories[indexPath.row]
        cell.loadData(data: category, pickedArray: pickedCategories)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2 - 1, height: collectionView.frame.size.width / 2 - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let category = NewsCategoryManager.sharedInstance.allCategories[indexPath.row]
        if let index = pickedCategories.firstIndex(of: category.name){
            pickedCategories.remove(at: index)
        }
        else{
            pickedCategories.append(category.name)
        }
        collectionView.reloadData()
    }
}


