//
//  IOS9PhotoDataSource.swift
//  MyPhotos
//
//  Created by Артем Соловьенко on 17.11.16.
//  Copyright © 2016 Artem Solovenko. All rights reserved.
//

import UIKit
import Photos

class IOS9PhotoDataSource: NSObject, PhotoDataSource {
    
    var thumbnailSize: CGSize = CGSize.zero
    
    var fetchResults: PHFetchResult<PHAsset>!
    var assetCollection: PHAssetCollection! {
        didSet {
            if assetCollection != nil {
                DispatchQueue.global().async {
                    let fetchOptions = PHFetchOptions()
                    fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
                    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
                    
                    self.fetchResults = PHAsset.fetchAssets(in: self.assetCollection, options: fetchOptions)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    
    fileprivate var imageManager: PHCachingImageManager!
    fileprivate weak var collectionView: UICollectionView?
    
    override init() {
        super.init()
        
        imageManager = PHCachingImageManager()
    }
    
    func fullImageAtIndexPath(indexPath: IndexPath, completion: @escaping (UIImage?) -> Void) {
        
        let asset = fetchResults.object(at: indexPath.item)
        
        let scale = UIScreen.main.scale
        let size = UIScreen.main.bounds.size
        let targetSize = CGSize(width: size.width * scale, height: size.height * scale)
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.progressHandler = { progress, error, stop, info in
            //
        }
        
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { (result, info) in
            completion(result)
        }
    }
}

extension IOS9PhotoDataSource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.collectionView = collectionView
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let asset = fetchResults.object(at: indexPath.item)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.cellId,
                                                      for: indexPath) as! PhotosCollectionViewCell
        cell.identifier = asset.localIdentifier // Assign the unique id to the cell
        DispatchQueue.global().async {
            self.imageManager.requestImage(for: asset, targetSize: self.thumbnailSize, contentMode: .aspectFill, options: nil) { (result, info) in
                // Check the correctness of id 
                if cell.identifier == asset.localIdentifier {
                    DispatchQueue.main.async {
                        cell.imageView.image = result
                    }
                }
            }
            
        }
        
        return cell
    }
}
