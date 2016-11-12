//
//  PhotoLibrary.swift
//  MyPhotos
//
//  Created by Артем Соловьенко on 04.11.16.
//  Copyright © 2016 Artem Solovenko. All rights reserved.
//

import UIKit
import Photos

enum PhotoAlbumType: Int {
    case smartAlbums, userCollections
}

class PhotoLibrary: NSObject {
    
    static var shared: PhotoLibrary = PhotoLibrary()
    
    fileprivate var imageManager: PHCachingImageManager!
    fileprivate var fetchResults: PHFetchResult<PHObject>!
    fileprivate var fetchOptions: PHFetchOptions!
    
    fileprivate var previousPreheatRect: CGRect = CGRect()
    
    override init() {
        super.init()
        
        imageManager = PHCachingImageManager()
        
        fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
//        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//        PhotoManager.fetchResults = PHAsset.fetchAssets(with: fetchOptions)
        
        PHPhotoLibrary.shared().register(self)
    }
    
    
    // MARK: - Authorize
    
    func authorize(completion: @escaping (Bool) -> Void) {
        
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ status in
                DispatchQueue.main.async {
                    self.authorize(completion: completion)
                }
            })
        }
        else {
            if PHPhotoLibrary.authorizationStatus() == .authorized {
                imageManager = PHCachingImageManager()
                completion(true)
            } else {
                imageManager = nil
                completion(false)
            }
        }
    }
    
//    func getAlbum(_ albumType: PhotoAlbumType? = nil) -> Album {
//        // TODO: realize code
//        
//        guard let type = albumType else {
//            
//            let album = Album()
//            
//            let assets: PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: fetchOptions)
//            
//            
//            return
//        }
//        
//        return []
//    }
    
//    func getAlbumName(_ identifier: String) -> String {
//        // TODO: realize code
//        return ""
//    }
//    
//    func getPhotos(from album: Album) -> [Photo] {
//        
//    }
//    
//    private func findAlbum(with localizedName: String) -> PHAssetCollection? {
//        
//        return nil
//    }
    
//    func getAlbum
}

extension PhotoLibrary: PHPhotoLibraryChangeObserver {

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            
//            if let changeDetails = changeInstance.changeDetails(for: self.fetchResults as PHFetchResult<PHObject>) {
//                
//                self.fetchResults = changeDetails.fetchResultAfterChanges
////                PhotoManager.collectionView?.reloadData()
//            }
        }
    }
}
