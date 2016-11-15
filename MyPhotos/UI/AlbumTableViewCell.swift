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
            coverImageView.image = albumCoverImage
        }
    }
    
    var albumName: String? {
        didSet {
            nameLabel.text = albumName
            setNeedsLayout()
        }
    }
    
    var photosCount: String? {
        didSet {
            countLabel.text = photosCount
            setNeedsLayout()
        }
    }
    
    private var coverImageView = UIImageView()
    private var nameLabel = UILabel()
    private var countLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.backgroundColor = UIColor.lightGray
        coverImageView.clipsToBounds = true
        contentView.addSubview(coverImageView)
        
        nameLabel.textColor = UIConstants.textColor
        nameLabel.font = UIConstants.albumCellFont
        nameLabel.textAlignment = .left
        contentView.addSubview(nameLabel)
        
        countLabel.textColor = UIConstants.textColor
        countLabel.font = UIConstants.albumCellFont
        countLabel.textAlignment = .right
        contentView.addSubview(countLabel)
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
        
        coverImageView.frame = CGRect(x: margin, y: (h - elementH) / 2,
                                        width: elementH, height: elementH)
        
        let countW = countLabel.sizeThatFits(CGSize()).width
        countLabel.frame = CGRect(x: w - countW - margin, y: (h - elementH) / 2,
                                  width: countW, height: elementH)
        
        let nameW = nameLabel.sizeThatFits(CGSize()).width
        nameLabel.frame = CGRect(x: coverImageView.frame.maxX + padding / 2, y: (h - elementH) / 2,
                                   width: nameW, height: elementH)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.albumCoverImage = nil
        self.albumName = nil
        self.photosCount = nil
    }
}
