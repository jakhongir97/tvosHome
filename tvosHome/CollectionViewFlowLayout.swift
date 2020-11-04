//
//  CollectionViewFlowLayout.swift
//  tvosHome
//
//  Created by Jakhongir Nematov on 11/3/20.
//

import UIKit

class BaseCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setupLayout()
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
        scrollDirection = .vertical
        sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override var itemSize: CGSize {
        set { }
        get {
            if let collectionViewWidth = collectionView?.frame.width {
                return itemSize(width: collectionViewWidth)
            }
            return CGSize.zero
        }
    }
    
    func itemSize(width: CGFloat) -> CGSize {
        return CGSize.zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CollectionViewFlowLayout: BaseCollectionViewFlowLayout {
    
    override func itemSize(width: CGFloat) -> CGSize {
        let numberOfItems: CGFloat = 5
        let itemWidth = (width - 10*(numberOfItems + 1) - 1) / numberOfItems
        let itemHeight = itemWidth * 0.8
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
