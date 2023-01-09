//
//  FavoriteViewController.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 02/01/23.
//

import UIKit
import RxSwift
import SDWebImage

class FavoriteViewController: UIViewController {
    var favProducts: [ItemProductModel] = []
    private let disposeBag = DisposeBag()
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationItem.title = "Favorite"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        LocaleDataSource.shared.getConvertedFavoriteProducts()
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.favProducts = result
            } onError: { error in
                print(error.localizedDescription)
            } onCompleted: {
                self.tableView.reloadData()
            }.disposed(by: disposeBag)
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.rowHeight = 150
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as? FavoriteTableViewCell {
            let product = self.favProducts[indexPath.row]
            cell.productName.text = product.name
            cell.imagePoster.sd_setImage(with: URL(string: product.pictureUrl))
            cell.imagePoster.sd_imageIndicator = SDWebImageActivityIndicator.white
            cell.location.text = product.location
            cell.productPrice.text = product.price.currencyInputFormatting()
            return cell
        } else {
            print("Data Empty")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.favProducts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("something")
        let productModel = self.favProducts[indexPath.row]
        let detailvc = DetailProductViewController()
        detailvc.product = productModel
        navigationController?.pushViewController(detailvc, animated: true)
    }
}
