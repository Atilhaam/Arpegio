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

class HomeViewController: ASDKViewController<ASScrollNode> {
    
    private let rootNode: ASScrollNode = {
        let rootNode = ASScrollNode()
        rootNode.automaticallyManagesSubnodes = true
        rootNode.automaticallyManagesContentSize = true
        rootNode.scrollableDirections = [.up, .down]
        rootNode.backgroundColor = .white
       return rootNode
    }()
    
    private let searchBar: ASEditableTextNode = {
        let searchBar = ASEditableTextNode()
        searchBar.attributedPlaceholderText = NSAttributedString(string: "Search for something here...")
        searchBar.layer.cornerRadius = 12
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.lightGray.cgColor
        searchBar.style.width = .init(unit: .fraction, value: 1)
        searchBar.style.height = .init(unit: .points, value: 52)
        return searchBar
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
    
    private let searchNode = SearchNode(height: 50)
    
    
    private let itemCollectionNode: ItemCardCollectionNode
    private let storyCollectionNode: StoryCollectionNode
    private let categoryCollectionNode: CategoryCollectionNode

    
    public override init() {
        self.itemCollectionNode = ItemCardCollectionNode(items: DataGenerator.generateDummyItem())
        self.storyCollectionNode = StoryCollectionNode(stories: DataGenerator.generateDummyStories())
        self.categoryCollectionNode = CategoryCollectionNode()
        self.searchNode.style.width = .init(unit: .fraction, value: 1)
        super.init(node: rootNode)
        rootNode.layoutSpecBlock = { [weak self] _, _ -> ASLayoutSpec in
            guard let self = self else { return .init() }
            let insetedCollection = ASInsetLayoutSpec(insets: .init(top: 0, left: 8, bottom: 0, right: 8), child: self.itemCollectionNode)
//            let insetedTextfield = ASInsetLayoutSpec(insets: .init(top: 0, left: 8, bottom: 0, right: 8), child: self.searchBar)
            let insetedSearchBar = ASInsetLayoutSpec(insets: .init(top: 0, left: 8, bottom: 0, right: 8), child: self.searchNode)
            return ASStackLayoutSpec(direction: .vertical, spacing: 8, justifyContent: .start, alignItems: .stretch, children: [
                insetedSearchBar,
                self.categoryCollectionNode,
                insetedCollection
            ])
            
        }
        print("\(self.view.height) ini height")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
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
            present(nav, animated: false)
        }
    }
    
}
