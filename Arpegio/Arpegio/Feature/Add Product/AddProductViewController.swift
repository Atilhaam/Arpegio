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
import Photos
import PhotosUI

class AddProductViewController: UIViewController {
    private let disposebag = DisposeBag()
    
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
    
    private let contactTextfield: UITextField = {
        let nameField = UITextField()
        nameField.autocapitalizationType = .none
        nameField.autocorrectionType = .no
        nameField.returnKeyType = .continue
        nameField.layer.cornerRadius = 12
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = UIColor.lightGray.cgColor
        nameField.placeholder = "Masukan No Whatsapp"
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
        setupRx()
        print(category)
        let productId = UUID().uuidString
        print(productId)

        scrollView.frame = view.bounds
        let frameScroll = CGSize(width: self.view.frame.width, height: self.view.frame.height + 150)
        scrollView.contentSize = frameScroll
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapAdd))
        gesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(gesture)
    }
    
    private func setupView() {
        self.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.tambahButton.addTarget(self, action: #selector(didtapTambah), for: .touchUpInside)
        self.productPriceField.keyboardType = .numberPad
        self.contactTextfield.keyboardType = .numberPad
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(productNameField)
        scrollView.addSubview(productPriceField)
        scrollView.addSubview(productConditionField)
        scrollView.addSubview(productDescriptionField)
        scrollView.addSubview(productLocationField)
        scrollView.addSubview(contactTextfield)
        scrollView.addSubview(tambahButton)
        tambahButton.imageView?.image = UIImage(named: "buttonTambahFail")
        tambahButton.isEnabled = false
        
        let textfields: [UITextField] = [productNameField,productPriceField,productConditionField,productConditionField,productDescriptionField,productLocationField,contactTextfield]
        for textfield in textfields {
            setupTextFields(for: textfield)
        }
    }
    
    func setupRx() {
        let nameStream = productNameField.rx.text
            .orEmpty
            .skip(1)
            .map { !$0.isEmpty }
        nameStream.subscribe(onNext: { value in
            self.productNameField.rightViewMode = value ? .never : .always
        }).disposed(by: disposebag)
        
        let priceStream = productPriceField.rx.text
            .orEmpty
            .skip(1)
            .map { !$0.isEmpty }
        priceStream.subscribe(onNext: { value in
            if let price = self.productPriceField.text?.currencyInputFormatting() {
                self.productPriceField.text = price
            }
        }).disposed(by: disposebag)
        
        let conditionStream = productConditionField.rx.text
            .orEmpty
            .skip(1)
            .map { !$0.isEmpty }
        conditionStream.subscribe(onNext: { value in
            self.productConditionField.rightViewMode = value ? .never : .always
        }).disposed(by: disposebag)
        
        let descStream = productConditionField.rx.text
            .orEmpty
            .skip(1)
            .map { !$0.isEmpty }
        conditionStream.subscribe(onNext: { value in
            self.productConditionField.rightViewMode = value ? .never : .always
        }).disposed(by: disposebag)
        
        let locationStream = productLocationField.rx.text
            .orEmpty
            .skip(1)
            .map { !$0.isEmpty }
        locationStream.subscribe(onNext: { value in
            self.productLocationField.rightViewMode = value ? .never : .always
        }).disposed(by: disposebag)
        
        let contactStream = contactTextfield.rx.text
            .orEmpty
            .skip(1)
            .map { !$0.isEmpty }
        contactStream.subscribe(onNext: { value in
            self.contactTextfield.rightViewMode = value ? .never : .always
        }).disposed(by: disposebag)
        
        let invalidStreams = Observable.combineLatest(nameStream,priceStream,conditionStream,descStream,locationStream,contactStream) { name,price,condition,desc,contact,location in
            name && price && condition && desc && contact && location
        }
        
        invalidStreams.subscribe { isValid in
            if isValid && self.imageView.image != UIImage(systemName: "photo.fill") {
                self.tambahButton.isEnabled = true
                self.tambahButton.setImage(UIImage(named: "buttonTambahSuccess"), for: .normal)
            } else {
                self.tambahButton.isEnabled = false
                self.tambahButton.setImage(UIImage(named: "buttonTambahFail"), for: .normal)
            }
        }.disposed(by: disposebag)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        let size = scrollView.width/3
        imageView.frame = CGRect(
//                                 x: (scrollView.width-size) / 2,
                                 x: view.left + 20,
                                 y: 20,
                                 width: view.frame.width - 40,
                                 height: view.frame.height/3)
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
        productDescriptionField.frame = CGRect(x: view.left + 20,
                                        y: productConditionField.bottom + 20,
                                        width: view.frame.width - 40,
                                        height: 52)
        productLocationField.frame = CGRect(x: view.left + 20,
                                        y: productDescriptionField.bottom + 20,
                                        width: view.frame.width - 40,
                                        height: 52)
        contactTextfield.frame = CGRect(x: view.left + 20,
                                        y: productLocationField.bottom + 20,
                                        width: view.frame.width - 40,
                                        height: 52)
        tambahButton.frame = CGRect(x: view.left + 20,
                                        y: contactTextfield.bottom + 20,
                                        width: view.frame.width - 40,
                                        height: 52)
    }
    
    private func setupTextFields(for textField: UITextField) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "exclamationmark.circle"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(
            x: CGFloat(productNameField.frame.size.width - 25),
            y: CGFloat(5),
            width: CGFloat(25),
            height: CGFloat(25)
        )
        
        switch textField {
        case productNameField:
            button.addTarget(self, action: #selector(self.showNameExistAlert(_:)), for: .touchUpInside)
        case productPriceField:
            button.addTarget(self, action: #selector(self.showPriceExistAlert(_:)), for: .touchUpInside)
        case productConditionField:
            button.addTarget(self, action: #selector(self.showConditionExistAlert(_:)), for: .touchUpInside)
        case productDescriptionField:
            button.addTarget(self, action: #selector(self.showDesctiptionExistAlert(_:)), for: .touchUpInside)
        case productLocationField:
            button.addTarget(self, action: #selector(self.showProductLocationExistAlert(_:)), for: .touchUpInside)
        case contactTextfield:
            button.addTarget(self, action: #selector(self.showContactExistAlert(_:)), for: .touchUpInside)
        default:
            print("TextField not found")
        }
        textField.rightView = button
    }
    
    @objc private func didTapAdd() {
        print("klik")
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc private func didtapTambah() {
        guard let email = Auth.auth().currentUser?.email,
              let name = productNameField.text,
              let price = productPriceField.text,
              let condition = productConditionField.text,
              let description = productDescriptionField.text,
              let location = productLocationField.text,
              let contact = contactTextfield.text,
              imageView.image != UIImage(systemName: "photo.fill") else {
            alertLoginUserError()
            return
        }
        spinner.show(in: view)
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let id = UUID().uuidString
        var priceToInt = price.replacingOccurrences(of: "Rp", with: "")
        priceToInt = priceToInt.replacingOccurrences(of: ".", with: "")
        let pictureFileName = "\(id)_product_picture.png"
        guard let image = self.imageView.image,
              let data = image.pngData() else {
            print("image is nil")
            return
        }
        StorageManager.shared.uploadProductPicture(with: data, fileName: pictureFileName) { result in
            switch result {
            case .success(let pictureUrl):
                print(pictureUrl)
                let product = ProductDetail(id: id, category: self.category, name: name, price: priceToInt, condition: condition, desc: description, location: location, pictureUrl: pictureUrl, contactNumber: contact)
                DatabaseManager.shared.insertProduct(with: safeEmail, product: product) { [weak self] success in
                    guard let strongSelf = self else {
                        return
                    }
                    if success {
                        DispatchQueue.main.async {
                            strongSelf.spinner.dismiss()
                        }
                    } else {
                        print("gagal di insert product")
                        strongSelf.alertError()
                    }
                    strongSelf.navigationController?.dismiss(animated: true)
                }
            case .failure(let error):
                print("Storage manager error: \(error)")
                self.alertError()
                DispatchQueue.main.async {
                    self.spinner.dismiss()
                }
            }
        }
        
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func alertError(message: String = "Tambah produk gagal") {
        let alert = UIAlertController(title: "Oops",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    private func alertLoginUserError(message: String = "Please enter all Information Correctly") {
        let alert = UIAlertController(title: "Oops",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @IBAction func showNameExistAlert(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Product name is invalid.",
            message: "Please double check your name, for example Fender Stratocaster",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func showPriceExistAlert(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Please input correct price",
            message: "Please double check your price",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func showConditionExistAlert(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Please input correct condition",
            message: "Please double check your condition",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func showDesctiptionExistAlert(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Please input correct description",
            message: "Please double check your description",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func showProductLocationExistAlert(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Please input correct Location",
            message: "Please double check your Location",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func showContactExistAlert(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Please input correct contact",
            message: "Please double check your contact information",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }

}

extension AddProductViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true,completion: nil)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                guard let image = reading as? UIImage, error == nil else {
                    print("image picker error")
                    return
                }
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }
    }
}
