//
//  AlbumSection+FetchResult.swift
//  MyPhotos
//
//  Created by Артем Соловьенко on 15.11.16.
//  Copyright © 2016 Artem Solovenko. All rights reserved.
//

import Foundation
import Photos

extension AlbumSection {
    
    func fetchAssets() -> PHFetchResult<PHAssetCollection> {
        return PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
    }
}

extension SmartAlbumSection {
    
    override func fetchAssets() -> PHFetchResult<PHAssetCollection> {
        return PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
    }
}

extension UserCollectionsAlbumSection {
    override func fetchAssets() -> PHFetchResult<PHAssetCollection> {
        return PHCollectionList.fetchTopLevelUserCollections(with: nil) as? PHAssetCollection
    }
}
