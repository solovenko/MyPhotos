//
//  AlbumTableViewCell.swift
//  MyPhotos
//
//  Created by Артем Соловьенко on 04.11.16.
//  Copyright © 2016 Artem Solovenko. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {
    
    static let cellId = NSStringFromClass(AlbumTableViewCell.self)
    
    var albumCoverImage: UIImage? {
        didSet {
            __coverImageView.image = albumCoverImage
        }
    }
    
    var albumName: String? {
        didSet {
            __nameLabel.text = albumName
            setNeedsLayout()
        }
    }
    
    var photosCount: String? {
        didSet {
            __countLabel.text = photosCount
            setNeedsLayout()
        }
    }
    
    private var __coverImageView = UIImageView()
    private var __nameLabel = UILabel()
    private var __countLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        __coverImageView.contentMode = .scaleAspectFill
        __coverImageView.backgroundColor = UIColor.lightGray
        __coverImageView.clipsToBounds = true
        contentView.addSubview(__coverImageView)
        
        __nameLabel.textColor = UIColor.black
        __nameLabel.font = UIFont.systemFont(ofSize: 16)
        __nameLabel.textAlignment = .left
        contentView.addSubview(__nameLabel)
        
        __countLabel.textColor = UIColor.black
        __countLabel.font = UIFont.systemFont(ofSize: 15)
        __countLabel.textAlignment = .right
        contentView.addSubview(__countLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = contentView.bounds.width
        let h = contentView.bounds.height
        
        let padding: CGFloat = 15
        let margin: CGFloat = 5
        
        let elementH = h - margin * 2
        
        __coverImageView.frame = CGRect(x: margin, y: (h - elementH) / 2,
                                        width: elementH, height: elementH)
        
        let countW = __countLabel.sizeThatFits(CGSize()).width
        __countLabel.frame = CGRect(x: w - countW - margin, y: (h - elementH) / 2, width: countW, height: elementH)
        
        let nameW = __nameLabel.sizeThatFits(CGSize()).width
        __nameLabel.frame = CGRect(x: __coverImageView.frame.maxX + padding / 2, y: (h - elementH) / 2,
                                   width: nameW, height: elementH)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.albumCoverImage = nil
        self.albumName = nil
        self.photosCount = nil
    }
}
