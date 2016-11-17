//
//  PhotoDataSource.swift
//  MyPhotos
//
//  Created by Артем Соловьенко on 17.11.16.
//  Copyright © 2016 Artem Solovenko. All rights reserved.
//

import UIKit

protocol PhotoDataSource: NSObjectProtocol {
    
    var thumbnailSize: CGSize { get set }
    var preheatRect: CGRect { get set }
    
    func fullImageAtIndexPath(indexPath: IndexPath, completion: @escaping (UIImage?) -> Void)
}
