//
//  Photo.swift
//  MyPhotos
//
//  Created by Артем Соловьенко on 06.11.16.
//  Copyright © 2016 Artem Solovenko. All rights reserved.
//

import UIKit

class Photo: NSObject {
    
    var identifier: String
    
    init(with identifier: String) {
        self.identifier = identifier
        super.init()
    }
}
