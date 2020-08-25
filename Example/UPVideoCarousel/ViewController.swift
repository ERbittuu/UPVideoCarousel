//
//  ViewController.swift
//  UPVideoCarousel
//
//  Created by erbittuu on 08/25/2020.
//  Copyright (c) 2020 erbittuu. All rights reserved.
//

import UIKit
import UPVideoCarousel

class ViewController: UIViewController {

    @IBOutlet var carousel: Carousel! = Carousel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCarousel()
    }
    
    private func setupCarousel() {
        let urls: [URL] = [ "video1.mp4", "video2.mov", "video1.mp4", "video2.mov"].map({ (names) -> URL in
            return Bundle.main.url(forResource: names, withExtension:"")!
        })
        // Create as many slides as you'd like to show in the carousel
        let slide = CarouselSlide(url: urls[0])
        let slide1 = CarouselSlide(url: urls[1])
        let slide2 = CarouselSlide(url: urls[2])
        let slide3 = CarouselSlide(url: urls[3])
        
        // Add the slides to the carousel
        self.carousel.slides = [slide, slide1, slide2, slide3]
        
        
        // You can optionally use the 'interval' property to set the timing for automatic slide changes. The default is 1 second.
        self.carousel.interval = 4
        
        // OPTIONAL - use this function to automatically start traversing slides.
        self.carousel.start()
        
        // OPTIONAL - use this function to stop automatically traversing slides.
        // self.carousel.stop()
    }

}
