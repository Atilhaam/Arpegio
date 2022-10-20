//
//  WelcomeViewController.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 19/10/22.
//

import UIKit
import AsyncDisplayKit

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
        button.imageNode.image = UIImage(named: "buttonLoginGoogle")
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
    
    @objc private func loginWithEmailButtonTapped() {
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc private func registerButtonTapped() {
        
//        DispatchQueue.main.async {
            let vc = RegisterViewController()
//            vc.view.backgroundColor = .white
            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
