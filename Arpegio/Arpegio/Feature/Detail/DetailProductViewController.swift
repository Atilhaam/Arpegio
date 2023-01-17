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
    
    private let disposeBag = DisposeBag()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkFavorite()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Detail"
        favoriteButton.addTarget(self, action: #selector(addFavorite), for: .touchUpInside)
        setupTableView()
    }
    
    func checkFavorite() {
        guard let product = product, let email = UserDefaults.standard.value(forKey: "email") as? String else {
            print("product kosong")
            return
        }
        let safeEmail = RemoteFavoriteDataSource.safeEmail(emailAddress: email)
        RemoteFavoriteDataSource.shared.checkFavoriteById(with: safeEmail, product: product)
            .observe(on: MainScheduler.instance)
            .subscribe { favorite in
                if favorite {
                    DispatchQueue.main.async {
                        self.favoriteButton.backgroundColor = .red
                    }
                } else {
                    DispatchQueue.main.async {
                        self.favoriteButton.backgroundColor = .white
                    }
                }
            } onError: { error in
                print(error.localizedDescription)
            } onCompleted: {
                print("tidak ada error")
            }.disposed(by: disposeBag)
        
//        LocaleDataSource.shared.checkFavorite(id: product.id)
//            .observe(on: MainScheduler.instance)
//            .subscribe { favorite in
//                if favorite {
//                    DispatchQueue.main.async {
//                        self.favoriteButton.backgroundColor = .red
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        self.favoriteButton.backgroundColor = .white
//                    }
//                }
//            } onError: { error in
//                print(error.localizedDescription)
//            } onCompleted: {
//                print("tidak ada error")
//            }.disposed(by: disposeBag)
    }
    
    @objc func addFavorite() {
        guard let product = self.product, let email = UserDefaults.standard.value(forKey: "email") as? String else {
            print("product kosong")
            return
        }
        let safeEmail = RemoteFavoriteDataSource.safeEmail(emailAddress: email)
        if self.favoriteButton.backgroundColor == .white {
            RemoteFavoriteDataSource.shared.addProductToFavorite(with: safeEmail, product: product)
                .observe(on: MainScheduler.instance)
                .subscribe { success in
                    if success {
                        DispatchQueue.main.async {
                            self.favoriteButton.backgroundColor = .red
                        }
                    } else {
                        print("gagal")
                    }
                } onError: { error in
                    print(error.localizedDescription)
                } onCompleted: {
                    print("Berhasil")
                }.disposed(by: disposeBag)
//            LocaleDataSource.shared.addConvertedProductToFavorite(product: product)
//                .observe(on: MainScheduler.instance)
//                .subscribe { success in
//                    if success {
//                        DispatchQueue.main.async {
//                            self.favoriteButton.backgroundColor = .red
//                        }
//                    } else {
//                        print("gagal")
//                    }
//                } onError: { error in
//                    print(error.localizedDescription)
//                } onCompleted: {
//                    print("Berhasil")
//                }.disposed(by: disposeBag)
        } else {
            RemoteFavoriteDataSource.shared.removeProductFromFavorite(with: safeEmail, product: product)
                .observe(on: MainScheduler.instance)
                .subscribe { success in
                    if success {
                        DispatchQueue.main.async {
                            self.favoriteButton.backgroundColor = .white
                        }
                    } else {
                        print("gagal")
                    }
                } onError: { error in
                    print(error.localizedDescription)
                } onCompleted: {
                    print("Berhasil")
                }.disposed(by: disposeBag)
//            LocaleDataSource.shared.removeProductFromFavorite(id: product.id)
//                .observe(on: MainScheduler.instance)
//                .subscribe { success in
//                    if success {
//                        DispatchQueue.main.async {
//                            self.favoriteButton.backgroundColor = .white
//                        }
//                    } else {
//                        print("gagal")
//                    }
//                } onError: { error in
//                    print(error.localizedDescription)
//                } onCompleted: {
//                    print("Berhasil")
//                }.disposed(by: disposeBag)
        }
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        view.addSubview(favoriteButton)
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
