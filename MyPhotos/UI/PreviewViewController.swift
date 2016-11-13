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
    
    var fetchResult: PHFetchResult<PHAsset>!
    var assetCollection: PHAssetCollection!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
