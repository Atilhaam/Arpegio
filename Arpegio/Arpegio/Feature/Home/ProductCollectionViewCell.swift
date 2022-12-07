//
//  GameCollectionViewCell.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 17/11/22.
//

import Foundation
import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ProductCollectionViewCell"
    
    let coverImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        return image
    }()
    
    let productName: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.textAlignment = .left
        title.numberOfLines = 1
        return title
    }()
    
    let productPrice: UILabel = {
        let releaseDate = UILabel()
        releaseDate.textColor = .white
        releaseDate.textAlignment = .left
        return releaseDate
    }()
    
    let location: UILabel = {
        let score = UILabel()
        score.textColor = .white
        score.textAlignment = .left
        return score
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        layer.cornerRadius = 5
        configureConstraint()
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraint() {
        addSubview(coverImage)
        addSubview(productName)
        addSubview(productPrice)
        addSubview(location)
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        productName.translatesAutoresizingMaskIntoConstraints = false
        productPrice.translatesAutoresizingMaskIntoConstraints = false
        location.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            coverImage.heightAnchor.constraint(equalToConstant: contentView.frame.size.height-100),
            coverImage.widthAnchor.constraint(equalToConstant: contentView.frame.size.width-10),
            coverImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            productName.topAnchor.constraint(equalTo: coverImage.bottomAnchor),
            productName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productPrice.topAnchor.constraint(equalTo: productName.bottomAnchor),
            productPrice.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productPrice.trailingAnchor.constraint(equalTo: trailingAnchor),
            location.topAnchor.constraint(equalTo: productPrice.bottomAnchor),
            location.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            location.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            location.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        ])
    }
}

