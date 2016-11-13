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

fileprivate enum AlbumSection: Int {
    
    case smartAlbums = 0
    case userCollections
    
    static let count = 2
    
    func name() -> String {
        switch self {
        case .smartAlbums:
            return "Smart Albums"
        case .userCollections:
            return "User Collections"
        }
    }
}

class AlbumsViewController: UIViewController {
    
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    var userCollections: PHFetchResult<PHCollection>!
    
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
        messageLabel.backgroundColor = UIColor.clear
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont.systemFont(ofSize: 25)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        view.addSubview(messageLabel)
        
        PHPhotoLibrary.shared().register(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PhotoLibrary.shared.authorize { result in
            
            if result {
                self.shouldShowTable(true)
                self.showMessage(nil)
                self.reloadData()
            } else {
                self.shouldShowTable(false)
                self.showMessage("This app does not have access to your photos.\n\nYou can enable access in Privacy Settings.")
            }
        }
    }
    
    deinit {
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
        fetchSmartAlbumsSection()
        fetchUserCollectionsSection()
    }

    func fetchSmartAlbumsSection() {
        DispatchQueue.global().async {
            self.smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
            DispatchQueue.main.async {
                print("Smart Albums reload data request: \(Date())")
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchUserCollectionsSection() {
        DispatchQueue.global().async {
            self.userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
            DispatchQueue.main.async {
                print("User Collections reload data request: \(Date())")
                self.tableView.reloadData()
            }
        }
    }
    
    func showMessage(_ message: String?, showTime: TimeInterval = 0) {
        messageLabel.text = message
        messageLabel.alpha = message == nil ? 0 : 1
        
        view.setNeedsLayout()
    }
    
    private func shouldShowTable(_ flag: Bool) {
        if flag {
            if tableView.superview == nil {
                view.insertSubview(tableView, belowSubview: messageLabel)
            }
        } else {
            tableView.removeFromSuperview()
        }
    }
}


// MARK: - UITableViewDelegate and UITableViewDataSource' methods

extension AlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("\(#function) at line: \(#line) was called at \(Date())")
        return AlbumSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch AlbumSection(rawValue: section)! {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.cellId, for: indexPath) as! AlbumTableViewCell
     
        let imageManager = PHCachingImageManager()
        
        switch AlbumSection(rawValue: indexPath.section)! {
        case .smartAlbums:
            guard let smartAlbum: PHAssetCollection = smartAlbums?.object(at: indexPath.row)
                else { return cell }
            
            cell.albumName = smartAlbum.localizedTitle
            
//            DispatchQueue.global().async {
//                guard let photo = album.photos.last else { return }
//                PhotoLibrary.shared.requestImage(for: photo, withQuality: .low, completion: { (image) in
//                    DispatchQueue.main.async {
//                        cell.albumCoverImage = image
//                    }
//                })
//                
//            }
            
//            DispatchQueue.global().async {
//                let fetchOptions = PHFetchOptions()
//                fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
//                
//                let result = PHAsset.fetchAssets(in: smartAlbum, options: fetchOptions)
//                DispatchQueue.main.async {
//                    cell.photosCount = "\(result.count)"
//                }
//            }
            
            DispatchQueue.global().async {
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
                
                let assets = PHAsset.fetchAssets(in: smartAlbum, options: fetchOptions)
                
                DispatchQueue.main.async {
                    cell.photosCount = "\(assets.count)"
                }
                
                if let asset = assets.lastObject {
                    
                    let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                    
                    /* For faster performance, and maybe degraded image */
                    let imageOptions = PHImageRequestOptions()
                    imageOptions.deliveryMode = .fastFormat
                    imageOptions.isSynchronous = true
                    
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

            DispatchQueue.global().async {
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
                
                let assets = PHAsset.fetchAssets(in: userCollection, options: fetchOptions)
                
                DispatchQueue.main.async {
                    cell.photosCount = "\(assets.count)"
                }
                
                if let asset = assets.lastObject {
                    
                    let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                    
                    /* For faster performance, and maybe degraded image */
                    let imageOptions = PHImageRequestOptions()
                    imageOptions.deliveryMode = .fastFormat
                    imageOptions.isSynchronous = true
                    
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
        let vc = PhotosViewController()
        
        let collection: PHCollection
        
        switch AlbumSection(rawValue: indexPath.section)! {
        case .smartAlbums:
            collection = smartAlbums.object(at: indexPath.row)
        case .userCollections:
            collection = userCollections.object(at: indexPath.row)
        }
        
        // configure the view controller with the asset collection
        guard let assetCollection = collection as? PHAssetCollection
            else { fatalError("expected asset collection") }
        
//        vc.fetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
        vc.assetCollection = assetCollection
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AlbumsViewController: PHPhotoLibraryChangeObserver {
    
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        print("\(#function), line: \(#line)")
        
        DispatchQueue.main.sync {
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


// TODO: - Перенести
extension PHAssetCollection {
    var photosCount: Int {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d OR mediaType == %d", PHAssetMediaType.image.rawValue)
        let result = PHAsset.fetchAssets(in: self, options: fetchOptions)
        return result.count
    }
}

