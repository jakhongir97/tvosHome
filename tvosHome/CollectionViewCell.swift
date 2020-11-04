//
//  CollectionViewCell.swift
//  tvosHome
//
//  Created by Jakhongir Nematov on 11/3/20.
//

import TVUIKit
import SnapKit

class CollectionViewCell: UICollectionViewCell {
    
    let posterView = TVPosterView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(posterView)
        
        posterView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
