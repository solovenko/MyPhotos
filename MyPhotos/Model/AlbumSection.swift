//
//  AlbumSection.swift
//  MyPhotos
//
//  Created by Артем Соловьенко on 15.11.16.
//  Copyright © 2016 Artem Solovenko. All rights reserved.
//

import UIKit

class AlbumSection: NSObject {
    
    let name: String
    
    override init() {
        self.name = ""
        super.init()
    }
    
    init(withName name: String) {
        self.name = name
        super.init()
    }
    
    func localizedName() -> String {
        return NSLocalizedString(name, comment: "")
    }
}

final class SmartAlbumSection: AlbumSection {
    
    override init() {
        super.init(withName: "SmartAlbums")
    }
    
    private override init(withName name: String) {
        super.init(withName: name)
    }
}

final class UserCollectionsAlbumSection: AlbumSection {
    
    override init() {
        super.init(withName: "UserCollections")
    }
    
    private override init(withName name: String) {
        super.init(withName: name)
    }
}
