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

public final class HomeViewController: ASDKViewController<ASScrollNode> {
    
    private let rootNode: ASScrollNode = {
        let rootNode = ASScrollNode()
        rootNode.automaticallyManagesSubnodes = true
        rootNode.automaticallyManagesContentSize = true
        rootNode.scrollableDirections = [.up, .down]
        rootNode.backgroundColor = .white
       return rootNode
    }()
    
    public override init() {
        super.init(node: rootNode)
        rootNode.layoutSpecBlock = { [weak self] _, _ -> ASLayoutSpec in
            guard let self = self else { return .init() }
            return ASStackLayoutSpec(direction: .vertical, spacing: 8, justifyContent: .start, alignItems: .stretch, children: [
               
            ])
            
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        validateAuth()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = WelcomeViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
//            vc.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
    
}
