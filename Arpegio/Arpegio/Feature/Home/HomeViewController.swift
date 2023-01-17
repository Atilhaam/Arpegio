//
//  HomeViewController.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 19/10/22.
//

import Foundation
import UIKit
import FirebaseAuth
import RxSwift
import SDWebImage

class HomeViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: ResultViewController())
    
    private var itemsProduct = [ItemProductModel]()
    private var filteredItems = [ItemProductModel]()
    
    private let disposeBag = DisposeBag()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 4
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationController()
        validateAuth()
        DatabaseManager.shared.getAllProducts()
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                DispatchQueue.main.async {
                    self.itemsProduct = result
                    self.collectionView.reloadData()
                }
            } onError: { error in
                print(error.localizedDescription)
            } onCompleted: {
                DispatchQueue.main.async {
                    print("dari oncompleted")
                }
            }.disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = WelcomeViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
    
    private func setupNavigationController() {
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Cari Produk sekarang"
        searchController.searchBar.delegate = self
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemsProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("something")
        let productModel = self.itemsProduct[indexPath.row]
        let detailvc = DetailProductViewController()
        detailvc.product = productModel
        navigationController?.pushViewController(detailvc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell {
            let product = self.itemsProduct[indexPath.row]
            cell.productName.text = product.name
            cell.location.text = product.location
            cell.productPrice.text = product.price.currencyInputFormatting()
            cell.coverImage.sd_imageIndicator = SDWebImageActivityIndicator.white
            cell.coverImage.sd_setImage(with: URL(string: product.pictureUrl))
            return cell
        } else {
            print("kosong")
            return UICollectionViewCell()
        }
    }
     
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 8.0, bottom: 1.0, right: 8.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - layout.minimumInteritemSpacing
        return CGSize(width: widthPerItem - 8, height: 250)
    }
}
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchController.searchBar.text {
            let resultVC = searchController.searchResultsController as? ResultViewController
            resultVC?.productName = text
            resultVC?.filteredItems.removeAll()
            resultVC?.itemsProduct.removeAll()
            resultVC?.search(name: text)
        } else {
            print("kosong")
            let resultVC = searchController.searchResultsController as? ResultViewController
            resultVC?.filteredItems.removeAll()
            resultVC?.itemsProduct.removeAll()
            resultVC?.collectionView.reloadData()
        }
    }
}
