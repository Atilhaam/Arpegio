//
//  DetailProductViewController.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 22/11/22.
//

import UIKit
import JGProgressHUD
import SDWebImage
import RxSwift

class DetailProductViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    var product: ItemProductModel? = nil
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DetailProductTableViewCell.self, forCellReuseIdentifier: DetailProductTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.layer.cornerRadius = 30
        let image = UIImage(systemName: "heart",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Detail"
        setupTableView()

    }
    
    func setupTableView() {
        view.addSubview(tableView)
//        view.addSubview(favoriteButton)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 60),
            favoriteButton.heightAnchor.constraint(equalToConstant: 60),
            favoriteButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10),
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
    }


}
extension DetailProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailProductTableViewCell.identifier) as! DetailProductTableViewCell
        guard let product = self.product else {
            return cell
        }
        cell.nameContent.text = product.name
        cell.imagePoster.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imagePoster.sd_setImage(with: URL(string: product.pictureUrl))
        cell.priceContent.text = product.price.currencyInputFormatting()
        cell.descContent.text = product.desc
        cell.categoryContent.text = product.category
        cell.conditionContent.text = product.condition
        cell.locationContent.text = product.location
        cell.contactContent.text = product.contactNumber
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
