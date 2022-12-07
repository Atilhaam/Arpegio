//
//  WelcomeViewController.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 19/10/22.
//

import UIKit
import AsyncDisplayKit
import GoogleSignIn
import FirebaseAuth
import FirebaseCore


public final class WelcomeViewController: ASDKViewController<ASDisplayNode> {
    
    private let rootNode: ASScrollNode = {
        let rootNode = ASScrollNode()
        rootNode.automaticallyManagesSubnodes = true
        rootNode.automaticallyManagesContentSize = true
        rootNode.scrollableDirections = [.up, .down]
        rootNode.backgroundColor = .white
       return rootNode
    }()
    
    private let rootNode2 : ASDisplayNode = {
        let rootNode = ASDisplayNode()
        rootNode.automaticallyManagesSubnodes = true
        rootNode.backgroundColor = .white
        return rootNode
    }()
    
    private let logoImageNode: ASImageNode = {
        let imageNode = ASImageNode()
        imageNode.image = UIImage(named: "logoSementara")
        imageNode.style.width = .init(unit: .points, value: 300)
        imageNode.style.height = .init(unit: .points, value: 300)
        return imageNode
    }()
    
    private let signInWithEmailButtonNode: ASButtonNode = {
       let button = ASButtonNode()
        button.setImage(UIImage(named: "buttonLoginEmail"), for: .normal)
        button.style.width = .init(unit: .fraction, value: 1)
        button.style.height = .init(unit: .points, value: 56)
        return button
    }()
    
    private let signInWithGoogleButtonNode: ASButtonNode = {
       let button = ASButtonNode()
        button.setImage(UIImage(named: "buttonLoginGoogle"), for: .normal)
        button.style.width = .init(unit: .fraction, value: 1)
        button.style.height = .init(unit: .points, value: 56)
        return button
    }()
    
    private let signInWithAppleButtonNode: ASButtonNode = {
       let button = ASButtonNode()
        button.imageNode.image = UIImage(named: "buttonLoginEmail")
        button.style.width = .init(unit: .fraction, value: 1)
        button.style.height = .init(unit: .points, value: 56)
        return button
    }()
    
    private let signUpButton: ASButtonNode = {
       let button = ASButtonNode()
        button.style.width = .init(unit: .fraction, value: 1)
        button.setImage(UIImage(named: "buttonSignUp"), for: .normal)
        button.style.height = .init(unit: .points, value: 56)
        return button
    }()
    
    public override init() {
        super.init(node: rootNode2)
        signInWithEmailButtonNode.addTarget(self, action: #selector(loginWithEmailButtonTapped), forControlEvents: .touchUpInside)
        signInWithGoogleButtonNode.addTarget(self, action: #selector(googleSignInTapped), forControlEvents: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(registerButtonTapped), forControlEvents: .touchUpInside)
        rootNode2.layoutSpecBlock = { [weak self] _, _ -> ASLayoutSpec in
            guard let self = self else {
                return .init()
            }
            let insetedImageNode = ASInsetLayoutSpec(insets: .init(top: self.view.height / 20, left: 16, bottom: 0, right: 16), child: self.logoImageNode)
            let buttonStack = ASStackLayoutSpec(direction: .vertical, spacing: 16, justifyContent: .start, alignItems: .center, children: [
                self.signInWithEmailButtonNode,
                self.signInWithGoogleButtonNode,
                self.signInWithAppleButtonNode,
                self.signUpButton
            ])
            let insetedButtonStack = ASInsetLayoutSpec(insets: .init(top: 0, left: 16, bottom: 0, right: 16), child: buttonStack)
            
            return ASStackLayoutSpec(direction: .vertical, spacing: self.view.height / 20, justifyContent: .start, alignItems: .center, children: [
                insetedImageNode,
                insetedButtonStack
            ])
            
        }
        print(self.view.height / 20)

        
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
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
