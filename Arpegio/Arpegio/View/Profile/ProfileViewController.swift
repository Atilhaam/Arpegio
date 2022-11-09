//
//  ProfileViewController.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 19/10/22.
//

import UIKit
import AsyncDisplayKit
import FirebaseAuth

class ProfileViewController: ASDKViewController<ASScrollNode> {
    
    private let rootNode: ASScrollNode = {
        let rootNode = ASScrollNode()
        rootNode.automaticallyManagesSubnodes = true
        rootNode.automaticallyManagesContentSize = true
        rootNode.scrollableDirections = [.up, .down]
        rootNode.backgroundColor = .white
       return rootNode
    }()
    
    private let logoutButtonNode: ASButtonNode = {
        let buttonNode = ASButtonNode()
        buttonNode.setImage(UIImage(named: "buttonLogOut"), for: .normal)
        buttonNode.style.width = .init(unit: .fraction, value: 1)
        buttonNode.style.height = .init(unit: .points, value: 200)
        return buttonNode
    }()
    
    
    
    public override init() {
        super.init(node: rootNode)
        logoutButtonNode.addTarget(self, action: #selector(logoutButtonTapped), forControlEvents: .touchUpInside)
        rootNode.layoutSpecBlock = { [weak self] _, _ -> ASLayoutSpec in
            guard let self = self else { return .init() }
            let insetedHeaderNode = ASInsetLayoutSpec(insets: .init(top: 150, left: 16, bottom: 8, right: 16), child: self.logoutButtonNode)
            return ASStackLayoutSpec(direction: .vertical, spacing: 8, justifyContent: .start, alignItems: .stretch, children: [
                insetedHeaderNode
            ])

            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let email = Auth.auth().currentUser?.email {
            print(email)
        } else {
            print("kosong")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func logoutButtonTapped() {
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            do {
                try FirebaseAuth.Auth.auth().signOut()
                let vc = WelcomeViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav, animated: true)
            }
            catch {
                print("Failed to log out")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
}
