//
//  DetailViewController.swift
//  HXPinterestTransitionDemo
//
//  Created by HongXiangWen on 2018/8/8.
//  Copyright © 2018年 WHX. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        guard let image = image else { return }
        imageView.image = image
        let imageViewHeight = (kScreenWidth - 30) * image.size.height / image.size.width
        imageView.frame = CGRect(x: 15, y: kNavigationBarHeight + 15, width: kScreenWidth - 30, height: imageViewHeight)
        view.addSubview(imageView)
    }
    
}


// MARK: -  HXPinterestTransitionView
extension DetailViewController: HXPinterestTransitionView {
    
    func fromTransitionView() -> UIView? {
        return nil
    }
    
    func toTransitionView() -> UIView? {
        return imageView
    }
    
}
