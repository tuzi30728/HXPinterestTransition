//
//  PinterestViewController.swift
//  HXPinterestTransitionDemo
//
//  Created by HongXiangWen on 2018/8/8.
//  Copyright © 2018年 WHX. All rights reserved.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
let kNavigationBarHeight: CGFloat = kScreenHeight == 812 ? 88 : 64

class PinterestViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var images: [UIImage] = {
        var images = [UIImage]()
        for i in 1 ... 10 {
            let image = UIImage(named: "\(i).jpeg")
            images.append(image!)
        }
        return images
    }()
    
    private let pinterestTransitionManager = HXPinterestTransitionManager()
    
    // MARK: -  Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 设置导航控制器代理为pinterestTransitionManager
        navigationController?.delegate = pinterestTransitionManager
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else { return }
        if segueId == "pushToDetailVC" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.image = sender as? UIImage
        }
    }
    
    private func setupUI() {
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        let layout = HXWaterFallFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        collectionView.collectionViewLayout = layout
    }
    
}

// MARK: -  UICollectionViewDataSource
extension PinterestViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 35
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PintersetCell", for: indexPath) as! PintersetCell
        cell.imageView.image = images[indexPath.item % 10]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "pushToDetailVC", sender: images[indexPath.item % 10])
    }
    
}

// MARK: -  UICollectionViewDelegateWaterFallFlowLayout
extension PinterestViewController: UICollectionViewDelegateWaterFallFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountForSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let image = images[indexPath.item % 10]
        let cellWidth: CGFloat = floor((kScreenWidth - 45) / 2)
        let cellHeight: CGFloat = floor(image.size.height / image.size.width * cellWidth)
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}

// MARK: -  HXPinterestTransitionView
extension PinterestViewController: HXPinterestTransitionView {
    
    func fromTransitionView() -> UIView? {
        guard let selectedItem = collectionView.indexPathsForSelectedItems?.first,
            let cell = collectionView.cellForItem(at: selectedItem) as? PintersetCell else { return nil }
        return cell.imageView
    }
    
    func toTransitionView() -> UIView? {
        return nil
    }
    
}







