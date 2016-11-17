//
//  PhotosViewController.swift
//  MyPhotos
//
//  Created by Артем Соловьенко on 04.11.16.
//  Copyright © 2016 Artem Solovenko. All rights reserved.
//

import UIKit
import Photos

class PhotosViewController: UIViewController {
    
    var dataSource: PhotoDataSource! {
        didSet {
            if dataSource != nil {
                collectionView?.dataSource = dataSource as? UICollectionViewDataSource
                collectionView?.reloadData()
            }
        }
    }
    
    fileprivate var collectionView: UICollectionView!
    fileprivate var collectionViewLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Localized("Photos").capitalized
        
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        collectionView.delegate = self
        collectionView.dataSource = dataSource as? UICollectionViewDataSource
        collectionView.register(PhotosCollectionViewCell.self,
                                     forCellWithReuseIdentifier: PhotosCollectionViewCell.cellId)
        view.addSubview(collectionView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        dataSource?.fullImageAtIndexPath(indexPath: indexPath, completion: { [weak self] (image) in
            guard let strongSelf = self, let image = image else { return }
            
            let vc = PreviewViewController()
            vc.photoImage = image
            strongSelf.navigationController?.pushViewController(vc, animated: true)
        })
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.bounds.width - 3) / 4
        let scale = UIScreen.main.scale
        
        dataSource?.thumbnailSize = CGSize(width: size * scale, height: size * scale)
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
