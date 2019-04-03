//
//  PostMetadataCollectionViewCell.swift
//  Blog Nerd Ranch
//
//  Created by Chris Downie on 8/28/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import UIKit

class PostMetadataCollectionViewCell: UICollectionViewCell {
    
    // Public Vars
    public static let cellIdentifier = "PostMetadataCollectionViewCell"
    
    // IBOutlets
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var authorLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var summaryLabel : UILabel!
    
    override func awakeFromNib() {
        // Style the content view with a border & a drop-shadow
        contentView.backgroundColor = .white
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 0.5
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowRadius = 2
        contentView.layer.shadowOffset = CGSize(width: 0, height: 5)
        contentView.layer.shadowOpacity = 0.2
    }
    
    public func setup(withPostMetadata metadata: PostMetadata) {
        titleLabel.text = metadata.title
        authorLabel.text = metadata.author["name"]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        dateLabel.text = dateFormatter.string(from: metadata.publishDate)
        summaryLabel.text = metadata.summary
    }
    
}
