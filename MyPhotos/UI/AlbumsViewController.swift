//
//  AlbumsViewController.swift
//  MyPhotos
//
//  Created by Артем Соловьенко on 01.11.16.
//  Copyright © 2016 Artem Solovenko. All rights reserved.
//

import UIKit
import Photos

enum FetchOptions {
    static let creationDateAscending: PHFetchOptions = {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return options

    }()
}

class AlbumsViewController: UIViewController {
    
    enum AlbumSection: Int {
        case allPhotos = 0
        case smartAlbums
        case userCollections
        
        static let count = 3
        
        func name() -> String {
            switch self {
            case .allPhotos:
                return "All Photos"
            case .smartAlbums:
                return "Smart Albums"
            case .userCollections:
                return "User Collections"
            }
        }
    }
    
    var allPhotos: PHFetchResult<PHAsset>?
    var smartAlbums: PHFetchResult<PHAssetCollection>?
    var userCollections: PHFetchResult<PHCollection>?
    
    fileprivate var tableView: UITableView!
    fileprivate var messageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Albums"
        
        view.backgroundColor = UIColor.groupTableViewBackground
        
        tableView = UITableView(frame: CGRect(), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlbumTableViewCell.self, forCellReuseIdentifier: AlbumTableViewCell.cellId)
        view.addSubview(tableView)
        
        messageLabel = UILabel()
        messageLabel.isUserInteractionEnabled = false
        messageLabel.backgroundColor = UIColor.white
        messageLabel.textColor = UIColor.black
        messageLabel.font = UIFont.systemFont(ofSize: 30)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        view.addSubview(messageLabel)
        
        PHPhotoLibrary.shared().register(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PhotoLibrary.shared.authorize { result in
            if result {
                self.showMessage(nil)
            } else {
                self.showMessage("This app does not have access to your photos.\n\nYou can enable access in Privacy Settings.")
            }
        }
        
        reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let w = view.bounds.width
        let h = view.bounds.height

        let msgSize = messageLabel.sizeThatFits(CGSize(width: w - 50, height: 0))
        messageLabel.frame = CGRect(x: (w - msgSize.width) / 2, y: (h - msgSize.height) / 2,
                                      width: msgSize.width, height: msgSize.height)
        tableView.frame = view.bounds
    }
    
    private func reloadData() {
        fetchData()
    }
    
    private func fetchData() {
        fetchAllPhotosSection()
        fetchSmartAlbumsSection()
        fetchUserCollections()
    }
    
    private func fetchAllPhotosSection() {
        DispatchQueue.global().async {
            self.allPhotos = PHAsset.fetchAssets(with: FetchOptions.creationDateAscending)
            DispatchQueue.main.async {
                self.tableView.reloadData()
//                self.tableView.reloadSections(IndexSet(integer: AlbumSection.allPhotos.rawValue), with: .automatic)
            }
        }
    }
    
    private func fetchSmartAlbumsSection() {
        DispatchQueue.global().async {
            self.smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
            DispatchQueue.main.async {
                self.tableView.reloadData()
//                self.tableView.reloadSections(IndexSet(integer: AlbumSection.smartAlbums.rawValue), with: .automatic)
            }
        }
    }
    
    private func fetchUserCollections() {
        DispatchQueue.global().async {
            self.userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
            DispatchQueue.main.async {
                self.tableView.reloadData()
//                self.tableView.reloadSections(IndexSet(integer: AlbumSection.userCollections.rawValue), with: .automatic)
            }
        }
    }
    
    func showMessage(_ message: String?, showTime: TimeInterval = 0) {
        
        messageLabel.text = message
        messageLabel.alpha = message == nil ? 0 : 1
        view.setNeedsLayout()
        
        if showTime > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + showTime, execute: {
                self.messageLabel.alpha = 0
            })
        }
    }
}


// MARK: - UITableViewDelegate and UITableViewDataSource' methods

extension AlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return AlbumSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch AlbumSection(rawValue: section)! {
        case .allPhotos:
            return 1
        case .smartAlbums:
            return smartAlbums?.count ?? 0
        case .userCollections:
            return userCollections?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return AlbumSection(rawValue: section)!.name()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AlbumTableViewCell
        
        if let dequeueCell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.cellId, for: indexPath) as? AlbumTableViewCell {
            cell = dequeueCell
        } else {
            cell = AlbumTableViewCell(style: .default, reuseIdentifier: AlbumTableViewCell.cellId)
        }
                
        let imageManager = PHCachingImageManager()
        
        switch AlbumSection(rawValue: indexPath.section)! {
        case .allPhotos:
            guard let allPhotos = allPhotos
                else { return cell }
            
            cell.albumName = "All photos"
            cell.photosCount = "\(allPhotos.count)"
            
            let asset = allPhotos.lastObject!
            let imageSize = CGSize(width: asset.pixelWidth,
                                   height: asset.pixelHeight)
            
            DispatchQueue.global().async {
                /* For faster performance, and maybe degraded image */
                let options = PHImageRequestOptions()
                options.deliveryMode = .fastFormat
                options.isSynchronous = false
                
                imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: options, resultHandler: { (image, info) in
                    
                    DispatchQueue.main.async {
                        cell.albumCoverImage = image
                    }
                })
            }
        case .smartAlbums:
            guard let smartAlbum: PHAssetCollection = smartAlbums?.object(at: indexPath.row)
                else { return cell }
            
            cell.albumName = smartAlbum.localizedTitle
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType == %d OR mediaType == %d",
                                                 PHAssetMediaType.image.rawValue,
                                                 PHAssetMediaType.video.rawValue)
            DispatchQueue.global().async {
                let result = PHAsset.fetchAssets(in: smartAlbum, options: fetchOptions)
                DispatchQueue.main.async {
                    cell.photosCount = "\(result.count)"
                }
            }
            
            DispatchQueue.global().async {
                if let asset = PHAsset.fetchAssets(in: smartAlbum, options: FetchOptions.creationDateAscending).lastObject {
                    
                    let imageSize = CGSize(width: asset.pixelWidth,
                                           height: asset.pixelHeight)
                    
                    /* For faster performance, and maybe degraded image */
                    let imageOptions = PHImageRequestOptions()
                    imageOptions.deliveryMode = .fastFormat
                    imageOptions.isSynchronous = false
                    
                    imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: imageOptions, resultHandler: { (image, info) in
                        
                        DispatchQueue.main.async {
                            cell.albumCoverImage = image!
                        }
                    })
                }
            }
        case .userCollections:
            guard let userCollection: PHAssetCollection = userCollections?.object(at: indexPath.row) as? PHAssetCollection
                else { return cell }
            
            cell.albumName = userCollection.localizedTitle
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType == %d OR mediaType == %d",
                                                 PHAssetMediaType.image.rawValue,
                                                 PHAssetMediaType.video.rawValue)
            
            DispatchQueue.global(qos: .background).async {
                let result = PHAsset.fetchAssets(in: userCollection, options: fetchOptions)
                DispatchQueue.main.async {
                    cell.photosCount = "\(result.count)"
                }
            }
            
            DispatchQueue.global().async {
                if let asset = PHAsset.fetchAssets(in: userCollection, options: FetchOptions.creationDateAscending).lastObject {
                    
                    let imageSize = CGSize(width: asset.pixelWidth,
                                           height: asset.pixelHeight)
                    
                    /* For faster performance, and maybe degraded image */
                    let imageOptions = PHImageRequestOptions()
                    imageOptions.deliveryMode = .fastFormat
                    imageOptions.isSynchronous = false
                    
                    imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: imageOptions, resultHandler: { (image, info) in
                        
                        DispatchQueue.main.async {
                            cell.albumCoverImage = image!
                        }
                    })
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.navigationController?.pushViewController(vc as! UIViewController, animated: true)
        
//        var fetchOptions = PHFetchOptions()
//        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
//        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.Image.rawValue)
//        let allImages:PHFetchResult = PHAsset.fetchKeyAssetsInAssetCollection(albumList[index].collection, options: fetchOptions)
    }
}

extension AlbumsViewController: PHPhotoLibraryChangeObserver {
    
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        print("\(#function), line: \(#line)")
        
        DispatchQueue.main.sync {
            
            if let changeDetails = changeInstance.changeDetails(for: allPhotos!) {
                allPhotos = changeDetails.fetchResultAfterChanges
                tableView.reloadSections(IndexSet(integer: AlbumSection.allPhotos.rawValue), with: .automatic)
            }
            if let changeDetails = changeInstance.changeDetails(for: smartAlbums!) {
                smartAlbums = changeDetails.fetchResultAfterChanges
                tableView.reloadSections(IndexSet(integer: AlbumSection.smartAlbums.rawValue), with: .automatic)
            }
            if let changeDetails = changeInstance.changeDetails(for: userCollections!) {
                userCollections = changeDetails.fetchResultAfterChanges
                tableView.reloadSections(IndexSet(integer: AlbumSection.userCollections.rawValue), with: .automatic)
            }
            
        }
    }
}

extension AlbumsViewController {
    
    class Album: NSObject {
        
        var name: String?
        var photoCount: Int?
        var lastPhotoImage: UIImage?
        
    }
}


// TODO: - Перенести
extension PHAssetCollection {
    var photosCount: Int {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d OR mediaType == %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        let result = PHAsset.fetchAssets(in: self, options: fetchOptions)
        return result.count
    }
}

