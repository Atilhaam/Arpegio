//
//  MyProductViewController.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 04/01/23.
//

import UIKit
import RxSwift
import SDWebImage

class MyProductViewController: UIViewController {
    
    var myProducts: [ItemProductModel] = []
    private let disposeBag = DisposeBag()
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MyProductTableViewCell.self, forCellReuseIdentifier: MyProductTableViewCell.identifier)
        return tableView
    }()
    

    override func viewWillAppear(_ animated: Bool) {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            print("email kosong")
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        DatabaseManager.shared.getMyProducts(for: safeEmail)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                DispatchQueue.main.async {
                    self.myProducts = result
                    self.tableView.reloadData()
                }
            } onError: { error in
                print(error.localizedDescription)
            } onCompleted: {
                print("berhasil")
            }.disposed(by: disposeBag)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupTableView()

        // Do any additional setup after loading the view.
    }
    
    func setupNavigationController() {
        navigationItem.title = "My Products"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
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
extension MyProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MyProductTableViewCell.identifier, for: indexPath) as? MyProductTableViewCell {
            let product = self.myProducts[indexPath.row]
            cell.productName.text = product.name
            cell.imagePoster.sd_setImage(with: URL(string: product.pictureUrl))
            cell.imagePoster.sd_imageIndicator = SDWebImageActivityIndicator.white
            cell.location.text = product.location
            cell.productPrice.text = product.price.currencyInputFormatting()
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myProducts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("something")
        let productModel = self.myProducts[indexPath.row]
        let detailvc = DetailProductViewController()
        detailvc.product = productModel
        navigationController?.pushViewController(detailvc, animated: true)
    }
}
