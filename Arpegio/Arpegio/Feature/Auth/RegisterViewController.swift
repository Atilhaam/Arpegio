//
//  RegisterViewController.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 19/10/22.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Daftar dengan Email")
        imageView.contentMode = .left
        return imageView
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private let nameField: UITextField = {
        let nameField = UITextField()
        nameField.autocapitalizationType = .none
        nameField.autocorrectionType = .no
        nameField.returnKeyType = .continue
        nameField.layer.cornerRadius = 12
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = UIColor.lightGray.cgColor
        nameField.placeholder = "Nama"
        nameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        nameField.leftViewMode = .always
        nameField.backgroundColor = .white
        return nameField
    }()
    
    private let lastNameField: UITextField = {
        let nameField = UITextField()
        nameField.autocapitalizationType = .none
        nameField.autocorrectionType = .no
        nameField.returnKeyType = .continue
        nameField.layer.cornerRadius = 12
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = UIColor.lightGray.cgColor
        nameField.placeholder = "Nama belakang"
        nameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        nameField.leftViewMode = .always
        nameField.backgroundColor = .white
        return nameField
    }()
    
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .continue
        emailField.layer.cornerRadius = 12
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        emailField.placeholder = "Email"
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        emailField.leftViewMode = .always
        emailField.backgroundColor = .white
        return emailField
    }()
    
    private let passwordField: UITextField = {
        let passwordField = UITextField()
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.returnKeyType = .done
        passwordField.layer.cornerRadius = 12
        passwordField.layer.borderWidth = 1
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        passwordField.placeholder = "Password (6-8 Karakter)"
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        passwordField.leftViewMode = .always
        passwordField.isSecureTextEntry = true
        return passwordField
    }()
    
    private let confirmationPasswordField: UITextField = {
        let passwordField = UITextField()
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.returnKeyType = .done
        passwordField.layer.cornerRadius = 12
        passwordField.layer.borderWidth = 1
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        passwordField.placeholder = "Ulangi Password"
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        passwordField.leftViewMode = .always
        passwordField.isSecureTextEntry = true
        return passwordField
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "buttonDaftarFail"), for: .normal)
        return button
    }()

    private let disposebag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupView()
        setupRx()
        scrollView.frame = view.bounds
        scrollView.contentSize = self.view.frame.size
    }
    
    private func setupView() {
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(nameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(confirmationPasswordField)
        scrollView.addSubview(registerButton)
        registerButton.isEnabled = false
        registerButton.imageView?.image = UIImage(named: "buttonDaftarFail")
        
        let textfields: [UITextField] = [nameField,lastNameField,emailField,passwordField,confirmationPasswordField]
        
        for textfield in textfields {
            setupTextFields(for: textfield)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: view.left + 20,
                                 y: 20,
                                 width: view.frame.width - 120,
                                 height: 52)
        profileImageView.frame = CGRect(x: (view.frame.width - (view.frame.width/3))/2,
                                        y: imageView.bottom + 20,
                                        width: view.frame.width/3,
                                        height: view.frame.width/3)
        profileImageView.layer.cornerRadius = profileImageView.width / 2.0
        nameField.frame = CGRect(x: view.left + 20,
                                  y: profileImageView.bottom + 20,
                                  width: view.frame.width - 40,
                                  height: 52)
        lastNameField.frame = CGRect(x: view.left + 20,
                                  y: nameField.bottom + 20,
                                  width: view.frame.width - 40,
                                  height: 52)
        
        emailField.frame = CGRect(x: view.left + 20,
                                  y: lastNameField.bottom + 20,
                                  width: view.frame.width - 40,
                                  height: 52)
        passwordField.frame = CGRect(x: view.left + 20,
                                  y: emailField.bottom + 20,
                                  width: view.frame.width - 40,
                                  height: 52)
        confirmationPasswordField.frame = CGRect(x: view.left + 20,
                                  y: passwordField.bottom + 20,
                                  width: view.frame.width - 40,
                                  height: 52)
        registerButton.frame = CGRect(x: view.left + 20,
                                  y: confirmationPasswordField.bottom + 20,
                                  width: view.frame.width - 40,
                                  height: 52)
        
    }
    
    @objc private func registerButtonTapped() {
        guard let email = emailField.text,
              let firstName = nameField.text,
              let lastName = lastNameField.text,
              let password = passwordField.text,
              !email.isEmpty,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !password.isEmpty,
              password.count >= 6  else {
            alertLoginUserError()
            return
        }
        spinner.show(in: view)
        DatabaseManager.shared.userExist(with: email, completion: { [weak self] exist in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            guard !exist else {
                // user already exist
                strongSelf.alertLoginUserError(message: "Email address already exist")
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                guard authResult != nil, error == nil else {
                    return
                }
                let arpegioUser = ArpegioAppUser(
                    firstName: firstName,
                    lastName: lastName,
                    emailAddress: email)
                DatabaseManager.shared.insertUser(with: arpegioUser, completion: { success in
                    if success {
                        print("sucess")
                    } else {
                        print("gagal")
                    }
                })
                strongSelf.navigationController?.dismiss(animated: true)
            }
        })
    }
    
    private func setupRx() {
        let nameStream = nameField.rx.text
            .orEmpty
            .skip(1)
            .map { !$0.isEmpty }
        nameStream.subscribe(onNext: { value in
            self.nameField.rightViewMode = value ? .never : .always
        }).disposed(by: disposebag)
        
        let lastNameStream = lastNameField.rx.text
            .orEmpty
            .skip(1)
            .map{ !$0.isEmpty }
        lastNameStream.subscribe(onNext: { value in
            self.nameField.rightViewMode = value ? .never : .always
        }).disposed(by: disposebag)
        
        let emailStream = emailField.rx.text
            .orEmpty
            .skip(1)
            .map {self.isValidEmail(from: $0)}
        emailStream.subscribe(
            onNext: { value in
                self.emailField.rightViewMode = value ? .never : .always
            }
        ).disposed(by: disposebag)
        
        let passwordStream = passwordField.rx.text
            .orEmpty
            .skip(1)
            .map { $0.count > 5}
        
        passwordStream.subscribe(
            onNext: { value in
                self.passwordField.rightViewMode = value ? .never : .always
            }
        ).disposed(by: disposebag)
        
        let confirmationPasswordStream = Observable.merge(
            confirmationPasswordField.rx.text
                .orEmpty
                .skip(1)
                .map { $0.elementsEqual(self.passwordField.text ?? "")},
            
            passwordField.rx.text
                .orEmpty
                .skip(1)
                .map { $0.elementsEqual(self.confirmationPasswordField.text ?? "")}
        )
        
        confirmationPasswordStream.subscribe(
            onNext: { value in
                self.confirmationPasswordField.rightViewMode = value ? .never : .always
            }
        ).disposed(by: disposebag)
        
        let invalidFieldsStream = Observable.combineLatest(
            nameStream,
            emailStream,
            passwordStream,
            confirmationPasswordStream
        ) { name, email, password, confimationPassword in
            name && email && password && confimationPassword
        }
        
        invalidFieldsStream.subscribe(onNext: { isValid in
            if (isValid) {
                self.registerButton.isEnabled = true
                self.registerButton.imageView?.image = UIImage(named: "buttonDaftarSuccess")
            } else {
                self.registerButton.isEnabled = false
                self.registerButton.imageView?.image = UIImage(named: "buttonDaftarFail")
            }
        }).disposed(by: disposebag)
    }
    
    private func setupTextFields(for textField: UITextField) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "exclamationmark.circle"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(
            x: CGFloat(nameField.frame.size.width - 25),
            y: CGFloat(5),
            width: CGFloat(25),
            height: CGFloat(25)
        )
        
        switch textField {
        case nameField:
            button.addTarget(self, action: #selector(self.showNameExistAlert(_:)), for: .touchUpInside)
        case lastNameField:
            button.addTarget(self, action: #selector(self.showLastNameExistAlert(_:)), for: .touchUpInside)
        case emailField:
            button.addTarget(self, action: #selector(self.showEmailExistAlert(_:)), for: .touchUpInside)
        case passwordField:
            button.addTarget(self, action: #selector(self.showPasswordExistAlert(_:)), for: .touchUpInside)
        case confirmationPasswordField:
            button.addTarget(self, action: #selector(self.showConfirmationPasswordExistAlert(_:)), for: .touchUpInside)
        default:
            print("TextField not found")
        }
        textField.rightView = button
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
            title: "Your name is invalid.",
            message: "Please double check your name, for example Ilham.",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func showLastNameExistAlert(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Your name is invalid.",
            message: "Please double check your name, for example Wibowo",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func showEmailExistAlert(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Your email is invalid.",
            message: "Please double check your email format, for example like gilang@dicoding.com.",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func showPasswordExistAlert(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Your password is invalid.",
            message: "Please double check the character length of your password.",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func showConfirmationPasswordExistAlert(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Confirmation passwords do not match.",
            message: "Please check your password confirmation again.",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func isValidEmail(from email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

}
