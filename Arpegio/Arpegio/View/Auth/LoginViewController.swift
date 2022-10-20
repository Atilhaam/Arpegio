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

class LoginViewController: UIViewController {
    private let spinner = JGProgressHUD(style: .dark)

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Masuk dengan Email")
        imageView.contentMode = .left
        return imageView
    }()
    
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
        button.setImage(UIImage(named: "buttonMasuk"), for: .normal)
        return button
    }()
    
    private let forgotButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "buttonForgot"), for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        // Do any additional setup after loading the view.
    }
    
    
    
    private func setupView() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        forgotButton.addTarget(self, action: #selector(forgotButtonTapped), for: .touchUpInside)
        view.addSubview(imageView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(forgotButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: view.left + 20,
                                 y: view.height / 10,
                                 width: view.frame.width - 120,
                                 height: 52)
        emailField.frame = CGRect(x: view.left + 20,
                                  y: imageView.bottom + 20,
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

    func alertLoginUserError() {
        let alert = UIAlertController(title: "Oops",
                                      message: "Please enter all Information Correctly",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: false)
    }

}
