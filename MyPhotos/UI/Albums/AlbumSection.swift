//
//  AlbumSection.swift
//  MyPhotos
//
//  Created by Артем Соловьенко on 15.11.16.
//  Copyright © 2016 Artem Solovenko. All rights reserved.
//

import UIKit
import Photos

class Album: NSObject {
    
    var localizeName: String? {
        return assetCollection.localizedTitle
    }
    
    var photos: [PHAsset] = []
    
    let assetCollection: PHAssetCollection
    
    init(by assetCollection: PHAssetCollection) {
        self.assetCollection = assetCollection
        super.init()
    }
    
    func fetchPhotos(withOptions fetchOption: PHFetchOptions, completion: () -> ()) {
        let fetchAssets = PHAsset.fetchAssets(in: assetCollection, options: fetchOption)
        
        photos = formPhotos(from: fetchAssets)
        completion()
    }
    
    private func formPhotos(from fetchResult: PHFetchResult<PHAsset>) -> [PHAsset] {
        var assets: [PHAsset] = []
        
        fetchResult.enumerateObjects({ (asset, _, _) in
            assets.append(asset)
        })
        return assets
    }
}

class AlbumSection: NSObject {
    
    let name: String
    
    var albums: [Album] = []
    
    private(set) var rawValue: PHFetchResult<PHAssetCollection>!
    
    init(withName name: String) {
        self.name = name
        super.init()
    }
    
    func fetchAlbums(completion: () -> ()) {
        rawValue = fetchAssetCollections()
        albums = formAlbums(from: rawValue)
        completion()
    }
    
    func applyChanges(changes: PHFetchResultChangeDetails<PHAssetCollection>, completion: () -> ()) {
        rawValue = changes.fetchResultAfterChanges
        albums = formAlbums(from: rawValue)
        completion()
    }
    
    internal func fetchAssetCollections() -> PHFetchResult<PHAssetCollection> {
        return PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
    }
    
    private func formAlbums(from fetchResult: PHFetchResult<PHAssetCollection>!) -> [Album] {
        var collection: [PHAssetCollection] = []
        
        fetchResult?.enumerateObjects({ (asset, _, _) in
            collection.append(asset)
        })
        return collection.map({ Album(by: $0) })
    }
}

final class SmartAlbumSection: AlbumSection {
    
    init() {
        super.init(withName: Localized(LocalizeKeys.smartAlbumsName))
    }
    
    private override init(withName name: String) {
        super.init(withName: name)
    }
    
    override func fetchAssetCollections() -> PHFetchResult<PHAssetCollection> {
        return PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
    }
}

final class UsersAlbumSection: AlbumSection {
    
    init() {
        super.init(withName: Localized(LocalizeKeys.userCollectionsName))
    }
    
    private override init(withName name: String) {
        super.init(withName: name)
    }
    
    override func fetchAssetCollections() -> PHFetchResult<PHAssetCollection> {
        return PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
    }
}

