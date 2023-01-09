//
//  FavoriteTableViewCell.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 02/01/23.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    static let identifier = "FavoriteTableViewCell"
    
    let imagePoster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        return image
    }()
    
    let productName: UILabel = {
        let title = UILabel()
        title.textAlignment = .left
        title.numberOfLines = 1
        return title
    }()
    
    let productPrice: UILabel = {
        let releaseDate = UILabel()
        releaseDate.textAlignment = .left
        return releaseDate
    }()
    
    let location: UILabel = {
        let score = UILabel()
        score.textAlignment = .left
        return score
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraint() {
        addSubview(imagePoster)
        addSubview(productName)
        addSubview(productPrice)
        addSubview(location)
        imagePoster.translatesAutoresizingMaskIntoConstraints = false
        productName.translatesAutoresizingMaskIntoConstraints = false
        productPrice.translatesAutoresizingMaskIntoConstraints = false
        location.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imagePoster.heightAnchor.constraint(equalToConstant: 125),
            imagePoster.widthAnchor.constraint(equalToConstant: 125),
            imagePoster.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            imagePoster.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            productPrice.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            productPrice.leadingAnchor.constraint(equalTo: imagePoster.trailingAnchor, constant: 16),
            productPrice.trailingAnchor.constraint(equalTo: trailingAnchor),
            productName.topAnchor.constraint(equalTo: productPrice.bottomAnchor, constant: 4),
            productName.leadingAnchor.constraint(equalTo: imagePoster.trailingAnchor, constant: 16),
            productName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            location.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: 4),
            location.leadingAnchor.constraint(equalTo: imagePoster.trailingAnchor, constant: 16),
            location.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
    }

}
