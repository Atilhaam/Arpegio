//
//  HomeViewController.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 19/10/22.
//

import Foundation
import UIKit
import FirebaseAuth
import AsyncDisplayKit
import RxSwift
import SDWebImage

class HomeViewController: ASDKViewController<ASScrollNode> {
    
    private let rootNode: ASScrollNode = {
        let rootNode = ASScrollNode()
        rootNode.automaticallyManagesSubnodes = true
        rootNode.automaticallyManagesContentSize = true
        rootNode.scrollableDirections = [.up, .down]
        rootNode.backgroundColor = .white
       return rootNode
    }()
    
    private let rootNode2: ASDisplayNode = {
        let rootNode = ASDisplayNode()
        rootNode.automaticallyManagesSubnodes = true
        return rootNode
    }()
    
    private let searchBar: ASEditableTextNode = {
        let searchBar = ASEditableTextNode()
        searchBar.attributedPlaceholderText = NSAttributedString(string: "Search for something here...")
        searchBar.layer.cornerRadius = 12
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.lightGray.cgColor
        searchBar.style.width = .init(unit: .fraction, value: 1)
        searchBar.style.height = .init(unit: .points, value: 52)
        return searchBar
    }()
    
    private let productLocationField: UITextField = {
        let nameField = UITextField()
        nameField.autocapitalizationType = .none
        nameField.autocorrectionType = .no
        nameField.returnKeyType = .continue
        nameField.layer.cornerRadius = 12
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = UIColor.lightGray.cgColor
        nameField.placeholder = "Masukan Lokasi"
        nameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        nameField.leftViewMode = .always
        nameField.backgroundColor = .white
        return nameField
    }()
    
    private let searchNode = SearchNode(height: 50)
    private let searchController = UISearchController(searchResultsController: ResultViewController())

    
    
//    private let itemCollectionNode: ItemCardCollectionNode
    private let categoryCollectionNode: CategoryCollectionNode
//    private let itemTableNode: ItemCardTableNode
    
    private let postTableNode: PostTableNode
    
    private var itemsProduct = [ItemProductModel]()
    private var filteredItems = [ItemProductModel]()
    
    private let disposeBag = DisposeBag()
    
    public override init() {
//        self.itemCollectionNode = ItemCardCollectionNode(items: DataGenerator.generateDummyItemProduct())
//        self.itemTableNode = ItemCardTableNode(items: DataGenerator.generateDummyItemProduct())
        self.categoryCollectionNode = CategoryCollectionNode()
        self.postTableNode = PostTableNode(posts: DataGenerator.generateDummyPost())
        self.searchNode.style.width = .init(unit: .fraction, value: 1)
        super.init(node: rootNode)
        rootNode.layoutSpecBlock = { [weak self] _, _ -> ASLayoutSpec in
            guard let self = self else { return .init() }
            return ASStackLayoutSpec(direction: .vertical, spacing: 8, justifyContent: .start, alignItems: .stretch, children: [
                self.categoryCollectionNode,
            ])
            
        }
        print("\(self.view.height) ini height")
    }
    
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
        let desiredOffset = CGPoint(x: 0, y: self.view.top)
        self.rootNode.view.setContentOffset(desiredOffset, animated: true)
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
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//        ])
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: view.left,
                                      y: categoryCollectionNode.frame.size.height + categoryCollectionNode.frame.origin.y + 20,
                                      width: view.frame.width,
                                      height: view.frame.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
//        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Cari Produk sekarang"
        searchController.searchBar.delegate = self
//        searchController.searchBar.rx.text
//            .orEmpty
//            .debounce(RxTimeInterval.milliseconds(1000), scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
//            .filter { !$0.isEmpty }
//            .subscribe(onNext: { query in
//                print(query)
//                ResultViewController().filteredItems = self.itemsProduct
//            }).disposed(by: disposeBag)
////            .subscribe({ onNext: query in
////                print(query)
////                self.searchController.view.backgroundColor = .red
//////                self.navigationController?.pushViewController(ResultViewController(), animated: true)
////            }.disposed(by: disposeBag)
        
        
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
