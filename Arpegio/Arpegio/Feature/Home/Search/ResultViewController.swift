//
//  ResultViewController.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 21/11/22.
//

import UIKit
import JGProgressHUD
import RxSwift
import SDWebImage

class ResultViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var hasFetched = false
    
    var itemsProduct = [ItemProductModel]()
    var filteredItems = [ItemProductModel]()
    
    private let disposeBag = DisposeBag()

    
    var productName = ""

    let collectionView: UICollectionView = {
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
    
    private let noResultLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .green
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    func search(name: String) {
        self.productName = name
        DatabaseManager.shared.getAllProducts()
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.itemsProduct = result
                self.filteredItems = self.itemsProduct.filter {
                    $0.name.contains(name)
                }
                self.collectionView.reloadData()
                print(self.filteredItems.count)
            } onError: { error in
                print(error.localizedDescription)
            } onCompleted: {
                print("")
                self.itemsProduct.removeAll()
                self.filteredItems.removeAll()
            }.disposed(by: disposeBag)
        
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
    
}
extension ResultViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("something")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell {
            let product = self.filteredItems[indexPath.row]
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
