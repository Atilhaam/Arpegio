//
//  WelcomeViewController.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 19/10/22.
//

import UIKit
import Foundation
import GoogleSignIn
import FirebaseAuth
import FirebaseCore
import AuthenticationServices


class WelcomeViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logoSementara")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let loginWithEmailButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(named: "primaryColor")
        button.setImage(UIImage(systemName: "envelope.fill"), for: .normal)
        button.imageEdgeInsets.right = 10
        button.setTitle("Masuk dengan Email", for: .normal)
        button.setTitleColor(UIColor(named: "primaryColor"), for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(named: "primaryColor")?.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 21)
        return button
    }()
    
    private let loginWithGoogleButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(named: "primaryColor")
        button.setImage(UIImage(named: "google"), for: .normal)
        button.imageEdgeInsets.right = 10
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle("Masuk dengan Google", for: .normal)
        button.setTitleColor(UIColor(named: "primaryColor"), for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(named: "primaryColor")?.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 21)
        return button
    }()
    
    
    private let registerText: UILabel = {
        let label = UILabel()
        let string = NSMutableAttributedString(string: "Belum punya akun? Daftar sekarang")
        string.setColorForText("Daftar sekarang", with: .blue)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.attributedText = string
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }
    
    private func setupView() {
        loginWithEmailButton.addTarget(self, action: #selector(loginWithEmailButtonTapped), for: .touchUpInside)
        loginWithGoogleButton.addTarget(self, action: #selector(googleSignInTapped), for: .touchUpInside)
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(loginWithEmailButton)
        scrollView.addSubview(loginWithGoogleButton)
        scrollView.addSubview(registerText)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.registerButtonTapped))
        registerText.isUserInteractionEnabled = true
        registerText.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 1.5
        imageView.frame = CGRect(x: (scrollView.width - size)/2,
                                 y: view.height / 50,
                                 width: scrollView.width / 1.5,
                                 height: scrollView.width / 1.5)
        loginWithEmailButton.frame = CGRect(x: 30,
                                            y: imageView.bottom + 50,
                                            width: scrollView.width - 60,
                                            height: 52)
        loginWithGoogleButton.frame = CGRect(x: 30,
                                             y: loginWithEmailButton.bottom + 10,
                                             width: scrollView.width - 60,
                                             height: 52)
        registerText.frame = CGRect(x: 30,
                                    y: loginWithGoogleButton.bottom + 10,
                                    width: scrollView.width - 60,
                                    height: 52)
    }
    
    @objc private func googleSignInTapped() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [weak self] user, error in
            guard let authentication = user?.authentication, let idToken = authentication.idToken, error == nil else {
                print("Missing auth object")
                return
            }
            guard let email = user?.profile?.email, let firstName = user?.profile?.givenName, let lastName = user?.profile?.familyName else {
                print("missing info")
                return
            }
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
            
            DatabaseManager.shared.userExist(with: email, completion: { exist in
                if !exist {
                    let chatUser = ArpegioAppUser(firstName: firstName,
                                               lastName: lastName,
                                               emailAddress: email)
                    DatabaseManager.shared.insertUser(with: chatUser, completion: { sucess in
                        if sucess {
                            guard let userHasProfileImage = user?.profile?.hasImage else {
                                return
                            }
                            if userHasProfileImage {
                                guard let url = user?.profile?.imageURL(withDimension: 200) else {
                                    return
                                }
                                
                                URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                                    guard let data = data else {
                                        return
                                    }
                                    let fileName = chatUser.profilePictureUrl
                                    StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: { result in
                                        switch result {
                                        case .success(let downloadUrl):
                                            UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                            print(downloadUrl)
                                        case .failure(let error):
                                            print("Storage manage error: \(error)")
                                        }
                                    })
                                    
                                }).resume()
                            }
                        }
                    })
                }
            })

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            FirebaseAuth.Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                guard authResult != nil, error == nil else {
                    print("failed to log in with google credential")
                    return
                }
                guard let strongSelf = self else {
                    return
                }
                
                print("Succesfully logged in user")
                strongSelf.navigationController?.dismiss(animated: true)
            }
        }
    }

    
    @objc private func loginWithEmailButtonTapped() {
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func registerButtonTapped() {
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
