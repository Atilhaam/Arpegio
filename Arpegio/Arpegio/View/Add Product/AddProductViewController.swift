//
//  AddProductViewController.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 26/10/22.
//

import UIKit
import RxSwift
import RxCocoa
import JGProgressHUD
import FirebaseAuth

class AddProductViewController: UIViewController {
    
    var category: String = ""
    private let spinner = JGProgressHUD(style: .dark)
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    private let backButton: UIButton = {
        let backbutton = UIButton(type: .custom)
        backbutton.setImage(UIImage(named: "backButton"), for: .normal)
        return backbutton
    }()
    
    private var titleView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Masukan Detail Produk")
        imageView.contentMode = .left
        return imageView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo.fill")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private let productNameField: UITextField = {
        let nameField = UITextField()
        nameField.autocapitalizationType = .none
        nameField.autocorrectionType = .no
        nameField.returnKeyType = .continue
        nameField.layer.cornerRadius = 12
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = UIColor.lightGray.cgColor
        nameField.placeholder = "Masukan Nama Produk"
        nameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        nameField.leftViewMode = .always
        nameField.backgroundColor = .white
        return nameField
    }()
    
    private let productConditionField: UITextField = {
        let nameField = UITextField()
        nameField.autocapitalizationType = .none
        nameField.autocorrectionType = .no
        nameField.returnKeyType = .continue
        nameField.layer.cornerRadius = 12
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = UIColor.lightGray.cgColor
        nameField.placeholder = "Masukan Kondisi Produk"
        nameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        nameField.leftViewMode = .always
        nameField.backgroundColor = .white
        return nameField
    }()
    
    private let productPriceField: UITextField = {
        let nameField = UITextField()
        nameField.autocapitalizationType = .none
        nameField.autocorrectionType = .no
        nameField.returnKeyType = .continue
        nameField.layer.cornerRadius = 12
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = UIColor.lightGray.cgColor
        nameField.placeholder = "Masukan Harga Produk"
        nameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        nameField.leftViewMode = .always
        nameField.backgroundColor = .white
        return nameField
    }()
    
    private let productYearField: UITextField = {
        let nameField = UITextField()
        nameField.autocapitalizationType = .none
        nameField.autocorrectionType = .no
        nameField.returnKeyType = .continue
        nameField.layer.cornerRadius = 12
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = UIColor.lightGray.cgColor
        nameField.placeholder = "Masukan Tahun Produk"
        nameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        nameField.leftViewMode = .always
        nameField.backgroundColor = .white
        return nameField
    }()
    
    private let productDescriptionField: UITextField = {
        let nameField = UITextField()
        nameField.autocapitalizationType = .none
        nameField.autocorrectionType = .no
        nameField.returnKeyType = .continue
        nameField.layer.cornerRadius = 12
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = UIColor.lightGray.cgColor
        nameField.placeholder = "Masukan Deskripsi Produk"
        nameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        nameField.leftViewMode = .always
        nameField.backgroundColor = .white
        return nameField
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
    
    private let tambahButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "buttonTambahSuccess"), for: .normal)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        view.backgroundColor = .white
        self.title = "Masukan Detail Produk"
        setupView()
        print(category)
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        self.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
//        view.addSubview(titleView)
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(productNameField)
        scrollView.addSubview(productPriceField)
        scrollView.addSubview(productConditionField)
//        view.addSubview(productYearField)
        scrollView.addSubview(productDescriptionField)
        scrollView.addSubview(productLocationField)
        scrollView.addSubview(tambahButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        titleView.frame = CGRect(x: view.left + 40,
//                                 y: view.height / 40,
//                                 width: view.frame.width - 120,
//                                 height: 52)
        scrollView.frame = view.bounds
        imageView.frame = CGRect(x: (view.frame.size.width - (view.frame.size.width / 3)) / 2,
                                 y: view.height / 10,
                                 width: view.frame.size.width / 3,
                                 height: view.frame.size.width / 3)
        productNameField.frame = CGRect(x: view.left + 20,
                                        y: imageView.bottom + 20,
                                        width: view.frame.width - 40,
                                        height: 52)
        productPriceField.frame = CGRect(x: view.left + 20,
                                         y: productNameField.bottom + 20,
                                         width: view.frame.width - 40,
                                         height: 52)
        productConditionField.frame = CGRect(x: view.left + 20,
                                        y: productPriceField.bottom + 20,
                                        width: view.frame.width - 40,
                                        height: 52)
//        productYearField.frame = CGRect(x: view.left + 20,
//                                        y: productConditionField.bottom + 20,
//                                        width: view.frame.width - 40,
//                                        height: 52)
        productDescriptionField.frame = CGRect(x: view.left + 20,
                                        y: productConditionField.bottom + 20,
                                        width: view.frame.width - 40,
                                        height: 52)
        productLocationField.frame = CGRect(x: view.left + 20,
                                        y: productDescriptionField.bottom + 20,
                                        width: view.frame.width - 40,
                                        height: 52)
        tambahButton.frame = CGRect(x: view.left + 20,
                                        y: productLocationField.bottom + 20,
                                        width: view.frame.width - 40,
                                        height: 52)
    }
    
    
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

}
