//
//  Album.swift
//  MyPhotos
//
//  Created by Артем Соловьенко on 06.11.16.
//  Copyright © 2016 Artem Solovenko. All rights reserved.
//

import UIKit

class Album: NSObject {
    
    var name: String?
    var photos: [Photo]

    var identifier: String
    
    init(with identifier: String, name: String?, photos: [Photo]) {
        self.identifier = identifier
        self.name = name
        self.photos = photos
        super.init()
    }
}

extension Album {
    
    var photosCount: Int {
        return photos.count
    }
}
