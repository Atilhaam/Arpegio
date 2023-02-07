//
//  ProfileSecondRowTableViewCell.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 18/01/23.
//

import UIKit

class ProfileSecondRowTableViewCell: UITableViewCell {

    static let identifier = "SettingTableViewCell"
        
        private let iconContainer : UIView = {
            let view = UIView()
            view.clipsToBounds = true
            view.layer.cornerRadius = 8
            view.layer.masksToBounds = true
            return view
        }()
        
        private let iconImageView : UIImageView = {
            let imageView = UIImageView()
            imageView.tintColor = .black
            imageView.image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        private let label : UILabel = {
            let label = UILabel()
            label.text = "Logout Sekarang"
            label.numberOfLines = 1
            return label
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            contentView.addSubview(label)
            contentView.addSubview(iconContainer)
            iconContainer.addSubview(iconImageView)
            contentView.clipsToBounds = true
            accessoryType = .disclosureIndicator
        }
        
        required init?(coder: NSCoder) {
            fatalError()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let size : CGFloat = contentView.frame.size.height - 12
            iconContainer.frame = CGRect(x: 15, y: 6, width: size, height: size)
            
            let imageSize : CGFloat = size / 1.5
            iconImageView.frame = CGRect(x: (size - imageSize)/2, y: (size - imageSize)/2, width: imageSize, height: imageSize)
            
            label.frame = CGRect(x: 25 + iconContainer.frame.size.width,
                                 y: 0,
                                 width: contentView.frame.size.width - 20 - iconContainer.frame.size.width,
                                 height: contentView.frame.size.height)
        }

}
