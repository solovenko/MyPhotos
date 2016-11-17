////
////  PhotoLibrary.swift
////  MyPhotos
////
////  Created by Артем Соловьенко on 04.11.16.
////  Copyright © 2016 Artem Solovenko. All rights reserved.
////
//
//import UIKit
//import Photos
//
//enum PhotoAlbumType: Int {
//    case smartAlbums, userCollections
//}
//
//enum PhotoQuality {
//    case low, high
//}
//
//class PhotoLibrary: NSObject {
//    
//    static var shared: PhotoLibrary = PhotoLibrary()
//    
//    fileprivate var imageManager: PHCachingImageManager!
//    fileprivate var fetchResults: PHFetchResult<PHObject>!
//    fileprivate var fetchOptions: PHFetchOptions!
//    
//    fileprivate var previousPreheatRect: CGRect = CGRect()
//    
//    override init() {
//        super.init()
//        
//        imageManager = PHCachingImageManager()
//        
//        fetchOptions = PHFetchOptions()
//        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
//        
////        let fetchOptions = PHFetchOptions()
////        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
////        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
////        PhotoManager.fetchResults = PHAsset.fetchAssets(with: fetchOptions)
//        
//        PHPhotoLibrary.shared().register(self)
//    }
//    
//    
//    // MARK: - Authorize
//    
//    func authorize(completion: @escaping (Bool) -> Void) {
//        
//        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
//            PHPhotoLibrary.requestAuthorization({ status in
//                DispatchQueue.main.async {
//                    self.authorize(completion: completion)
//                }
//            })
//        }
//        else {
//            if PHPhotoLibrary.authorizationStatus() == .authorized {
//                imageManager = PHCachingImageManager()
//                completion(true)
//            } else {
////                imageManager = nil
//                completion(false)
//            }
//        }
//    }
//    
//    func getAlbums(for albumType: PhotoAlbumType) -> [Album] {
//        
//        var albums = [Album]()
//        
//        switch albumType {
//        case .smartAlbums:
//            let assets = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
//            
//            for i in 0..<assets.count {
//                let assetCollection = assets.object(at: i)
//                albums.append(Album(with: assetCollection.localIdentifier,
//                                    name: assetCollection.localizedTitle,
//                                    photos: getPhotos(from: assetCollection)))
//            }
//        case .userCollections:
//            let assets = PHCollection.fetchTopLevelUserCollections(with: nil)
//            
//            for i in 0..<assets.count {
//                guard let assetCollection = assets.object(at: i) as? PHAssetCollection else { continue }
//                albums.append(Album(with: assetCollection.localIdentifier,
//                                    name: assetCollection.localizedTitle,
//                                    photos: getPhotos(from: assetCollection)))
//            }
//        }
//        
//        return albums
//    }
//    
//    private func getPhotos(from assetCollection: PHAssetCollection) -> [Photo] {
//        let fetchOption = PHFetchOptions()
//        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
//        fetchOption.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
//        
//        let assets = PHAsset.fetchAssets(in: assetCollection, options: fetchOption)
//        
//        var photos: [Photo] = []
//        for i in 0..<assets.count {
//            let asset = assets.object(at: i)
//            photos.append(Photo(with: asset.localIdentifier))
//        }
//        
//        return photos
//    }
//    
//    private func formAsset(from photo: Photo) -> PHAsset? {
//        return PHAsset.fetchAssets(withLocalIdentifiers: [photo.identifier], options: nil).firstObject
//    }
//    
//    func requestImage(for photo: Photo, withQuality quality: PhotoQuality, completion: @escaping ((UIImage?) -> Void)) {
//        
//        guard let asset = formAsset(from: photo) else { return }
//        
//        let imageSize = CGSize(width: asset.pixelWidth,
//                               height: asset.pixelHeight)
//        
//        /* For faster performance, and maybe degraded image */
//        let imageOptions = PHImageRequestOptions()
//        
//        switch quality {
//        case .low:
//            imageOptions.deliveryMode = .fastFormat
//        case .high:
//            imageOptions.deliveryMode = .highQualityFormat
//        }
//        
//        imageOptions.isSynchronous = true
//        
//        imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: imageOptions, resultHandler: { (image, info) in
//            completion(image)
//        })
//    }
//    
////    func getAlbumName(_ identifier: String) -> String {
////        // TODO: realize code
////        return ""
////    }
////
////    func getPhotos(from album: Album) -> [Photo] {
////        
////    }
////    
////    private func findAlbum(with localizedName: String) -> PHAssetCollection? {
////        
////        return nil
////    }
//    
////    func getAlbum
//}
//
//extension PhotoLibrary: PHPhotoLibraryChangeObserver {
//
//    func photoLibraryDidChange(_ changeInstance: PHChange) {
//        DispatchQueue.main.async {
//            
////            if let changeDetails = changeInstance.changeDetails(for: self.fetchResults as PHFetchResult<PHObject>) {
////                
////                self.fetchResults = changeDetails.fetchResultAfterChanges
//////                PhotoManager.collectionView?.reloadData()
////            }
//        }
//    }
//}
