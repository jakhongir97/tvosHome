//
//  PageViewController.swift
//  tvosHome
//
//  Created by Jakhongir Nematov on 11/4/20.
//

import UIKit
import SnapKit

class PageViewController: UIViewController {
    
    let imageView : UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "wallpaper")
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

    }

}
