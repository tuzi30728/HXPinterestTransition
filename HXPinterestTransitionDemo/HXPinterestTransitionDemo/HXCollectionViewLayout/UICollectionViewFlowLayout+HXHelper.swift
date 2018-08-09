//
//  UICollectionViewFlowLayout+HXHelper.swift
//  HXPinterestTransitionDemo
//
//  Created by HongXiangWen on 2018/8/8.
//  Copyright © 2018年 WHX. All rights reserved.
//

import UIKit

extension UICollectionViewFlowLayout {
    
    weak var delegate: UICollectionViewDelegateFlowLayout? {
        return collectionView?.delegate as? UICollectionViewDelegateFlowLayout
    }
    
    func headerHeightForSection(_ section: Int) -> CGFloat {
        return delegate?.collectionView?(collectionView!, layout: self, referenceSizeForHeaderInSection: section).height ?? headerReferenceSize.height
    }
    
    func footerHeightForSection(_ section: Int) -> CGFloat {
        return delegate?.collectionView?(collectionView!, layout: self, referenceSizeForFooterInSection: section).height ?? footerReferenceSize.height
    }
    
    func sectionInsetForSection(_ section: Int) -> UIEdgeInsets {
        return delegate?.collectionView?(collectionView!, layout: self, insetForSectionAt: section) ?? sectionInset
    }
    
    func minimumInteritemSpacingForSection(_ section: Int) -> CGFloat {
        return delegate?.collectionView?(collectionView!, layout: self, minimumInteritemSpacingForSectionAt: section) ?? minimumInteritemSpacing
    }
    
    func minimumLineSpacingForSection(_ section: Int) -> CGFloat {
        return delegate?.collectionView?(collectionView!, layout: self, minimumLineSpacingForSectionAt: section) ?? minimumLineSpacing
    }
    
    func itemSizeForIndexPath(_ indexPath: IndexPath) -> CGSize {
        return delegate?.collectionView?(collectionView!, layout: self, sizeForItemAt: indexPath) ?? CGSize.zero
    }
    
}
