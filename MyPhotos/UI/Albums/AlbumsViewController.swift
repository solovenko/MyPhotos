//
//  AlbumsViewController.swift
//  MyPhotos
//
//  Created by Артем Соловьенко on 01.11.16.
//  Copyright © 2016 Artem Solovenko. All rights reserved.
//

import UIKit

class AlbumsViewController: UIViewController {
    
    var dataSource: AlbumDataSource!

    fileprivate var tableView: UITableView!
    fileprivate var messageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Localized("Albums").capitalized
        
        dataSource = IOS9AlbumDataSource() // Delegate table data source
        
        view.backgroundColor = UIColor.groupTableViewBackground

        tableView = UITableView(frame: CGRect(), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = (dataSource as! UITableViewDataSource)
        tableView.register(AlbumTableViewCell.self, forCellReuseIdentifier: AlbumTableViewCell.cellId)
        view.addSubview(tableView)
        
        messageLabel = UILabel()
        messageLabel.isUserInteractionEnabled = false
        messageLabel.backgroundColor = UIColor.clear
        messageLabel.textColor = UIConstants.Color.privacyMessageColor
        messageLabel.font = UIConstants.Font.privacyMessageFont
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        view.addSubview(messageLabel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataSource.authorize { result in
            self.shouldShowTable(result)
            
            if result {
                self.showMessage(nil)
            } else {
                self.showMessage(Localized(LocalizeKeys.privacyAccessMessage))
            }
        }
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

    func showMessage(_ message: String?) {
        messageLabel.text = message
        messageLabel.alpha = message == nil ? 0 : 1
        
        view.setNeedsLayout()
    }
    
    private func shouldShowTable(_ needShow: Bool) {
        if needShow {
            if tableView.superview == nil {
                view.insertSubview(tableView, belowSubview: messageLabel)
            }
        } else {
            tableView.removeFromSuperview()
        }
    }
}


// MARK: - UITableViewDelegate

extension AlbumsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIConstants.Dimension.albumCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dataSource.requestPhotoDataSource(for: indexPath, photoDataSource: { [weak self] (photoDataSource) in
            let vc = PhotosViewController()
            vc.dataSource = photoDataSource
            self?.navigationController?.pushViewController(vc, animated: true)
        })
    }
}


