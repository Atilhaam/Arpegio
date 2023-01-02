//
//  DetailProductTableViewCell.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 02/12/22.
//

import UIKit

class DetailProductTableViewCell: UITableViewCell {
    
    static let identifier = "DetailGameTableViewCell"
    
    let imagePoster: UIImageView = {
        let imagePoster = UIImageView()
//        imageView.image = UIImage(systemName: "photo.fill")
        imagePoster.tintColor = .gray
        imagePoster.contentMode = .scaleToFill
        imagePoster.layer.masksToBounds = true
        imagePoster.layer.borderWidth = 2
        imagePoster.layer.borderColor = UIColor.lightGray.cgColor
        return imagePoster
    }()
    
    let priceContent: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 30.0)
        return title
    }()
    
    let nameContent: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 30.0)
        return title
    }()
    
    let descLabel: UILabel = {
        let title = UILabel()
        title.text = "Deskripsi"
        title.textAlignment = .left
        title.numberOfLines = 1
        title.font = UIFont.boldSystemFont(ofSize: 20.0)
        return title
    }()
    
    let descContent: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.textAlignment = .justified
        title.font = UIFont.boldSystemFont(ofSize: 16)
        return title
    }()
    
    let categoryLabel: UILabel = {
        let categoryLabel = UILabel()
        categoryLabel.textAlignment = .left
        categoryLabel.text = "Category"
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        return categoryLabel
    }()

    let categoryContent: UILabel = {
        let categoryContent = UILabel()
        categoryContent.textAlignment = .left
        categoryContent.font = UIFont.boldSystemFont(ofSize: 16)
        categoryContent.numberOfLines = 0
        return categoryContent
    }()

    let conditionLabel: UILabel = {
        let conditionLabel = UILabel()
        conditionLabel.text = "Kondisi"
        conditionLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        conditionLabel.textAlignment = .left
        return conditionLabel
    }()

    let conditionContent: UILabel = {
        let conditionContent = UILabel()
        conditionContent.textAlignment = .left
        conditionContent.font = UIFont.boldSystemFont(ofSize: 16)
        return conditionContent
    }()
    
    let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.text = "Lokasi"
        locationLabel.font = UIFont.boldSystemFont(ofSize: 20)
        return locationLabel
    }()

    let locationContent: UILabel = {
        let locationContent = UILabel()
        locationContent.textAlignment = .left
        locationContent.numberOfLines = 0
        locationContent.font = UIFont.boldSystemFont(ofSize: 16)
        return locationContent
    }()
    
    let contactLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.text = "Nomor Telpon"
        locationLabel.font = UIFont.boldSystemFont(ofSize: 20)
        return locationLabel
    }()

    let contactContent: UILabel = {
        let locationContent = UILabel()
        locationContent.textAlignment = .left
        locationContent.numberOfLines = 0
        locationContent.font = UIFont.boldSystemFont(ofSize: 16)
        return locationContent
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
        addSubview(priceContent)
        addSubview(nameContent)
        addSubview(descLabel)
        addSubview(descContent)
        addSubview(categoryLabel)
        addSubview(categoryContent)
        addSubview(conditionLabel)
        addSubview(conditionContent)
        addSubview(locationLabel)
        addSubview(locationContent)
        addSubview(contactLabel)
        addSubview(contactContent)
        imagePoster.translatesAutoresizingMaskIntoConstraints = false
        priceContent.translatesAutoresizingMaskIntoConstraints = false
        nameContent.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descContent.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryContent.translatesAutoresizingMaskIntoConstraints = false
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        conditionContent.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationContent.translatesAutoresizingMaskIntoConstraints = false
        contactLabel.translatesAutoresizingMaskIntoConstraints = false
        contactContent.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            imagePoster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            imagePoster.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/2),
            imagePoster.widthAnchor.constraint(equalToConstant: contentView.frame.width),
//            imagePoster.
            imagePoster.centerXAnchor.constraint(equalTo: centerXAnchor),
            imagePoster.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagePoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            priceContent.topAnchor.constraint(equalTo: imagePoster.bottomAnchor, constant: 22),
            priceContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            priceContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            nameContent.topAnchor.constraint(equalTo: priceContent.bottomAnchor, constant: 16),
            nameContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            descLabel.topAnchor.constraint(equalTo: nameContent.bottomAnchor, constant: 16),
            descLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            descContent.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 16),
            descContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            categoryLabel.topAnchor.constraint(equalTo: descContent.bottomAnchor, constant: 16),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            categoryContent.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 16),
            categoryContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            conditionLabel.topAnchor.constraint(equalTo: categoryContent.bottomAnchor, constant: 16),
            conditionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            conditionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            conditionContent.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 16),
            conditionContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            conditionContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: conditionContent.bottomAnchor, constant: 16),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            locationContent.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 16),
            locationContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            locationContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            contactLabel.topAnchor.constraint(equalTo: locationContent.bottomAnchor, constant: 16),
            contactLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contactLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            contactContent.topAnchor.constraint(equalTo: contactLabel.bottomAnchor, constant: 16),
            contactContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contactContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
