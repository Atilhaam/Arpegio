//
//  LoginViewController.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 19/10/22.
//

import UIKit
import JGProgressHUD
import FirebaseCore
import FirebaseAuth
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    private let spinner = JGProgressHUD(style: .dark)
    
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .continue
        emailField.layer.cornerRadius = 12
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        emailField.placeholder = "Email Address..."
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
        passwordField.placeholder = "Password..."
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        passwordField.leftViewMode = .always
        passwordField.isSecureTextEntry = true
        return passwordField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "buttonMasukFail"), for: .normal)
        return button
    }()
    
    private let forgotButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "buttonForgot"), for: .normal)
        return button
    }()
    
    private let disposebag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        setupRx()
        navigationItem.title = "Masuk Dengan Email"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        // Do any additional setup after loading the view.
    }
    
    
    
    private func setupView() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        forgotButton.addTarget(self, action: #selector(forgotButtonTapped), for: .touchUpInside)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(forgotButton)
        loginButton.isEnabled = false
        loginButton.imageView?.image = UIImage(named: "buttonMasukFail")
        
        let textfields: [UITextField] = [emailField,passwordField]
        
        for textfield in textfields {
            setupTextFields(for: textfield)
        }
    }
    
    private func setupRx() {
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
        
        let invalidStream = Observable.combineLatest(
            emailStream,
            passwordStream
        ) { email, password in
            email && password
        }
        
        invalidStream.subscribe(onNext: { isValid in
            if isValid {
                self.loginButton.isEnabled = true
                self.loginButton.imageView?.image = UIImage(named: "buttonMasukSuccess")
            } else {
                self.loginButton.isEnabled = false
                self.loginButton.imageView?.image = UIImage(named: "buttonMasukFail")
            }
        }).disposed(by: disposebag)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emailField.frame = CGRect(x: view.left + 20,
                                  y:  view.safeAreaInsets.top + 10,
                                  width: view.frame.width - 40,
                                  height: 52)
        passwordField.frame = CGRect(x: view.left + 20,
                                  y: emailField.bottom + 20,
                                  width: view.frame.width - 40,
                                  height: 52)
        loginButton.frame = CGRect(x: view.left + 20,
                                  y: passwordField.bottom + 40,
                                  width: view.frame.width - 40,
                                  height: 52)
        forgotButton.frame = CGRect(x: view.left + 20,
                                  y: loginButton.bottom + 10,
                                  width: view.frame.width - 40,
                                  height: 52)
        
    }
    
    private func setupTextFields(for textField: UITextField) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "exclamationmark.circle"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(
            x: CGFloat(emailField.frame.size.width - 25),
            y: CGFloat(5),
            width: CGFloat(25),
            height: CGFloat(25)
        )
        
        switch textField {
        case emailField:
            button.addTarget(self, action: #selector(self.showEmailExistAlert(_:)), for: .touchUpInside)
        case passwordField:
            button.addTarget(self, action: #selector(self.showPasswordExistAlert(_:)), for: .touchUpInside)
        default:
            print("TextField not found")
        }
        textField.rightView = button
    }
    
    @objc private func loginButtonTapped() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty, password.count >= 6  else {
            alertLoginUserError()
            return
        }
        
        spinner.show(in: view)
        //Firebase Login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password,completion:  { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            guard let result = authResult, error == nil else {
                print("Failed to log in")
                return
            }
            let user = result.user
            
            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
            DatabaseManager.shared.getDataFor(path: safeEmail, completion: { result in
                switch result {
                case .success(let data):
                    guard let userData = data as? [String:Any], let firstName = userData["first_name"] as? String, let lastName = userData["last_name"] as? String else {
                        return
                    }
                    UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
                case .failure(let error):
                    print(error)
                }
            })
            
            UserDefaults.standard.set(email, forKey: "email")
            print("Logged in \(user)")
            strongSelf.navigationController?.dismiss(animated: true)
        })
        
    }
    
    @objc private func forgotButtonTapped() {
        
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
    
    private func isValidEmail(from email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func alertLoginUserError() {
        let alert = UIAlertController(title: "Oops",
                                      message: "Please enter all Information Correctly",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: false)
    }

}
