//
//  ViewController.swift
//  tvosHome
//
//  Created by Jakhongir Nematov on 11/3/20.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    //var pageController: UIPageViewController!
    var controllers = [UIViewController]()
    var pageControl = UIPageControl(frame: .zero)
    let focusGuide = UIFocusGuide()
    
    var currentPage = 0
    var pagingMode = false
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    
    let pageController: UIPageViewController = {
        var pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.view.isUserInteractionEnabled = false
        return pageController
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CollectionViewCell.self))
        collectionView.collectionViewLayout = CollectionViewFlowLayout()
        collectionView.remembersLastFocusedIndexPath = true
        return collectionView
    }()
    
    let blurEffectView: UIVisualEffectView = {
        var blurView = UIVisualEffectView()
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.isUserInteractionEnabled = false
        return blurView
    }()
    
    let watchButton : UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Смотреть", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .primaryActionTriggered)
        return button
    }()
    
    let moreButton : UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Подробнее", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .primaryActionTriggered)
        return button
    }()
    
    let rightArrowImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right.circle.fill")
        return imageView
    }()
    
    let leftArrowImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.left.circle.fill")
        return imageView
    }()
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        get {
            return [self.collectionView]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageController()
        setupViews()
        setupGestures()
        setupFocusGuide()
        setupInitialValues()
    }
    
    func setupViews() {
        view.addSubview(pageController.view)
        pageController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        view.addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1080)
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height - 350)
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(collectionView.snp.top).offset(-20)
        }

        view.addSubview(moreButton)
        moreButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(80)
            make.bottom.equalTo(pageControl.snp.top).offset(-20)
        }
        
        view.addSubview(watchButton)
        watchButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(80)
            make.bottom.equalTo(moreButton.snp.top).offset(-20)
        }
        
        view.addSubview(rightArrowImageView)
        rightArrowImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(50)
            make.width.height.equalTo(50)
        }
        
        view.addSubview(leftArrowImageView)
        leftArrowImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(50)
            make.width.height.equalTo(50)
        }
    }
    
    func setupFocusGuide() {
        focusGuide.preferredFocusEnvironments = [watchButton]
        
        view.addLayoutGuide(focusGuide)
        focusGuide.topAnchor.constraint(equalTo: watchButton.topAnchor).isActive = true
        focusGuide.leftAnchor.constraint(equalTo: collectionView.leftAnchor).isActive = true
        focusGuide.rightAnchor.constraint(equalTo: collectionView.rightAnchor).isActive = true
        focusGuide.bottomAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
    }
    
    func setupPageController() {
        addChild(pageController)

        for _ in 1 ... 5 {
            let vc = PageViewController()
            controllers.append(vc)
        }

        pageController.setViewControllers([controllers[currentPage]], direction: .forward, animated: false)

        pageControl.numberOfPages = controllers.count
        pageControl.currentPage = 0
        pageControl.alpha = 0
    }
    
    func setupGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    func setupInitialValues() {
        leftArrowImageView.alpha = 0
        rightArrowImageView.alpha = 0
        watchButton.alpha = 0.01
        moreButton.alpha = 0.01
        pageControl.alpha = 0
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if pagingMode {
            if gesture.direction == .right {
                if currentPage < controllers.count - 1 {
                    currentPage += 1
                    pageControl.currentPage = currentPage
                    pageController.setViewControllers([controllers[currentPage]], direction: .forward, animated: true)
                }
            }
            else if gesture.direction == .left {
                if currentPage > 0 {
                    currentPage -= 1
                    pageControl.currentPage = currentPage
                    pageController.setViewControllers([controllers[currentPage]], direction: .reverse, animated: true)
                }
            }
        }
    }
    
    @objc func buttonPressed() {
        print("working")
    }
    
    func showPagingMode(){
        pagingMode = true
        
        self.collectionView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height)
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.leftArrowImageView.alpha = 0.5
            self.rightArrowImageView.alpha = 0.5
            self.watchButton.alpha = 1
            self.moreButton.alpha = 1
            self.pageControl.alpha = 1
            self.view.layoutIfNeeded()
        })
    }
    
    func showInitialMode(){
        pagingMode = false
        
        self.collectionView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height - 370)
        }

        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.leftArrowImageView.alpha = 0
            self.rightArrowImageView.alpha = 0
            self.watchButton.alpha = 0.01
            self.moreButton.alpha = 0.01
            self.pageControl.alpha = 1
            self.blurEffectView.effect = nil
            self.view.layoutIfNeeded()
        })
    }
    
    func showFullMode(){
        pagingMode = false
        self.collectionView.snp.updateConstraints { (make) in
            make.top.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.6) {
            self.pageControl.alpha = 0
            self.blurEffectView.effect = self.blurEffect
        }

        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
}

extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self), for: indexPath) as? CollectionViewCell else { return CollectionViewCell()}
        cell.posterView.image = randomColor()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if collectionView == self.collectionView {
            if let index = context.nextFocusedIndexPath?.row {
                if index <= 4 {
                    showInitialMode()
                } else {
                    showFullMode()
                }
            } else {
                showPagingMode()
            }
        }
    }
    
}

extension ViewController {
    func randomCGFloat() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }

    func randomColor() -> UIImage {
        return UIColor(red: randomCGFloat(), green: randomCGFloat(), blue: randomCGFloat(), alpha: 1).image()
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

