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
    
    private let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let rect = UIEdgeInsetsInsetRect(view.bounds, UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0))
        imageView.frame = rect
    }
}
