//
//  ViewController.swift
//  UPVideoCarousel
//
//  Created by erbittuu on 08/25/2020.
//  Copyright (c) 2020 erbittuu. All rights reserved.
//

import UIKit
import ASPVideoPlayer

@objc public protocol CarouselDelegate: AnyObject {
    func carouselDidScroll()
}

final public class Carousel: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Properties
    private var timer: Timer = Timer()
    public var interval: Double = 1.0
    public var delegate: CarouselDelegate?
    
    public var slides: [CarouselSlide] = [] {
        didSet {
            updateUI()
        }
    }
    
    /// Calculates the index of the currently visible CarouselCell
    public var currentlyVisibleIndex: Int? {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return collectionView.indexPathForItem(at: visiblePoint)?.item
    }
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(tap:)))
        return tap
    }()
    
    public lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.hidesForSinglePage = true
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.0)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.register(CarouselCell.self, forCellWithReuseIdentifier: "slideCell")
        cv.clipsToBounds = true
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.bounces = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: - Default Methods
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupCarousel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCarousel()
    }
    
    // MARK: - Internal Methods
    private func setupCarousel() {
        backgroundColor = .clear
        
        addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.addGestureRecognizer(tapGesture)
        
        addSubview(pageControl)
        pageControl.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        pageControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 25).isActive = true
        bringSubviewToFront(pageControl)
    }
    
    @objc private func tapGestureHandler(tap: UITapGestureRecognizer?) {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint) ?? IndexPath(item: 0, section: 0)
        let index = visibleIndexPath.item

        if index == (slides.count-1) {
            let indexPathToShow = IndexPath(item: 0, section: 0)
            collectionView.selectItem(at: indexPathToShow, animated: false, scrollPosition: .centeredHorizontally)
        } else {
            let indexPathToShow = IndexPath(item: (index + 1), section: 0)
            collectionView.selectItem(at: indexPathToShow, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.pageControl.numberOfPages = self.slides.count
            self.pageControl.size(forNumberOfPages: self.slides.count)
        }
    }
    
    // MARK: - Exposed Methods
    public func start() {
        timer = Timer.scheduledTimer(timeInterval: interval,
                                     target: self,
                                     selector: #selector(tapGestureHandler(tap:)),
                                     userInfo: nil,
                                     repeats: true)
        timer.fire()
    }
    
    public func stop() {
        timer.invalidate()
    }
    
    public func disableTap() {
        /* This method is provided in case you want to remove the
         * default gesture and provide your own. The default gesture
         * changes the slides on tap.
         */
        collectionView.removeGestureRecognizer(tapGesture)
    }
    
    // MARK: - UICollectionViewDelegate & DataSource
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slideCell", for: indexPath) as! CarouselCell
        cell.slide = slides[indexPath.item]
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            cell.play()
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        return size
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - UIScrollViewDelegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let index = currentlyVisibleIndex {
            pageControl.currentPage = index
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.carouselDidScroll()
    }
    
}

public struct CarouselSlide {
    public var videoURL : URL
    public init(url: URL) {
        self.videoURL = url
    }
}

public class CarouselCell: UICollectionViewCell {
    
    let videoPlayer = ASPVideoPlayerView()
    // MARK: - Properties
    public var slide : CarouselSlide? {
        didSet {
            guard let slide = slide else {
                print("Carousel could not parse the slide you provided.")
                return
            }
            parseData(forSlide: slide)
        }
    }
    
    // MARK: - Default Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    private func setup() {
        backgroundColor = .clear
        clipsToBounds = true
        
        videoPlayer.shouldLoop = true
        videoPlayer.gravity = .aspectFill
        videoPlayer.volume = 0 
        
        videoPlayer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(videoPlayer)
        videoPlayer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        videoPlayer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        videoPlayer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        videoPlayer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
    
    
    private func parseData(forSlide slide: CarouselSlide) {
        videoPlayer.videoURL = slide.videoURL
    }
    
    func play() {
        videoPlayer.playVideo()
    }
}
