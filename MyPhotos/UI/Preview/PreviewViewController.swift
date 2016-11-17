//
//  PreviewViewController.swift
//  MyPhotos
//
//  Created by Артем Соловьенко on 13.11.16.
//  Copyright © 2016 Artem Solovenko. All rights reserved.
//

import UIKit
import Photos

class PreviewViewController: UIViewController {
    
    var photoImage: UIImage? {
        didSet {
            imageView.image = photoImage
        }
    }
    
    fileprivate let imageView = UIImageView()
    private let scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let rect = UIEdgeInsetsInsetRect(view.bounds, UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0))
        scrollView.frame = rect
        imageView.frame = scrollView.bounds
    }
}

extension PreviewViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
