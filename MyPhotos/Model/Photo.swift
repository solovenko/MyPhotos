//
//  Photo.swift
//  MyPhotos
//
//  Created by Артем Соловьенко on 06.11.16.
//  Copyright © 2016 Artem Solovenko. All rights reserved.
//

import UIKit
import Photos

class Photo: NSObject {
    
    private let asset: PHAsset
    
    var identifier: String!
    
    init(with asset: PHAsset) {
        self.asset = asset
        super.init()
    }
}
