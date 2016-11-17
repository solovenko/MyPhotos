//
//  AlbumDataSource.swift
//  MyPhotos
//
//  Created by Артем Соловьенко on 15.11.16.
//  Copyright © 2016 Artem Solovenko. All rights reserved.
//

import UIKit

protocol AlbumDataSource: NSObjectProtocol {
    
    func authorize(completion: @escaping (Bool) -> ())
    func requestPhotoDataSource(for indexPath: IndexPath, photoDataSource: (PhotoDataSource) -> ())
}
