//
//  IOS9AlbumDataSource.swift
//  MyPhotos
//
//  Created by Артем Соловьенко on 15.11.16.
//  Copyright © 2016 Artem Solovenko. All rights reserved.
//

import UIKit
import Photos

class IOS9AlbumDataSource: NSObject, AlbumDataSource {
    
    var sections: [AlbumSection] = []
    
    weak fileprivate var tableView: UITableView?
    
    fileprivate var imageManager: PHCachingImageManager!
    
    fileprivate let fetchOptions: PHFetchOptions = {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return options
    }()
    
    override init() {
        super.init()
        
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    func authorize(completion: @escaping (Bool) -> ()) {
        
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
                sections = [SmartAlbumSection(), UsersAlbumSection()]
                fetchSectionsAssets()
                completion(true)
            } else {
                imageManager = nil
                sections = []
                completion(false)
            }
        }
    }
    
    func requestPhotoDataSource(for indexPath: IndexPath, photoDataSource: (PhotoDataSource) -> ()) {
        let dataSource = IOS9PhotoDataSource()
        dataSource.assetCollection = sections[indexPath.section].albums[indexPath.row].assetCollection
        photoDataSource(dataSource)
    }
    
    private func fetchSectionsAssets() {
        for section in sections {
            DispatchQueue.global(qos: .userInitiated).async {
                section.fetchAlbums(completion: { [weak self] in
                    DispatchQueue.main.async {
                        self?.tableView?.reloadData()
                    }
                })
            }
        }
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource implementations

extension IOS9AlbumDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.tableView = tableView
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].albums.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.cellId, for: indexPath) as! AlbumTableViewCell
        
        let album = sections[indexPath.section].albums[indexPath.row]
        
        cell.albumName = album.localizeName
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            album.fetchPhotos(withOptions: self.fetchOptions, completion: { [weak self] in
                
                DispatchQueue.main.async {
                    cell.photosCount = "\(album.photos.count)"
                }
                
                guard let asset = album.photos.last else { return }
                self?.requestImage(for: asset, completion: { (image) in
                    DispatchQueue.main.async {
                        cell.albumCoverImage = image
                    }
                })
            })
        }
        
        return cell
    }
    
    private func requestSortedAssets(for assetCollection: PHAssetCollection) -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        return PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
    }
    
    private func requestImage(for asset: PHAsset, completion: @escaping (UIImage?) -> Void) {
        let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        
        /* For faster performance, and maybe degraded image */
        let imageOptions = PHImageRequestOptions()
        imageOptions.deliveryMode = .fastFormat
        imageOptions.isSynchronous = true
        
        imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: imageOptions, resultHandler: { (image, info) in
            
            completion(image)
        })
    }
}

extension IOS9AlbumDataSource: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        Logger("\(#function), line: \(#line)")
        
        for section in sections {
            guard let changeDetails = changeInstance.changeDetails(for: section.rawValue) else { continue }
            
            DispatchQueue.global(qos: .userInitiated).async {
                section.applyChanges(changes: changeDetails, completion: {
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self, let index = strongSelf.sections.index(of: section) else { return }
                        
                        strongSelf.tableView?.reloadSections(IndexSet(integer: index), with: .automatic)
                    }
                })
            }
        }
    }
}
