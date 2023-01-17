//
//  ProfileViewController.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 19/10/22.
//

import UIKit
import Foundation
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
    
    public let table = ASTableNode()
    private var insetedHeaderNode = ASInsetLayoutSpec()
    
    public override init() {
        super.init(node: rootNode)
        let topInset: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIApplication.shared.statusBarFrame.size.height
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor(named: "primaryBackgroundColor")
        table.view.separatorStyle = .none
        rootNode.layoutSpecBlock = { [weak self] _, _ -> ASLayoutSpec in
            guard let self = self else { return .init() }
            self.insetedHeaderNode = ASInsetLayoutSpec(insets: .init(top: topInset, left: 0, bottom: 0, right: 0), child: self.table)
            return self.insetedHeaderNode

            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.reloadData()
        setupNavigationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.table.reloadData()
        if let name = UserDefaults.standard.value(forKey: "name") as? String {
            print(name)
        } else {
            print("nama kosong")
        }
        if let email = UserDefaults.standard.value(forKey: "email") as? String {
            print(email)
            print("email user defaults ada")
        } else {
            print("email kosong")
        }
//        if let email = Auth.auth().currentUser?.email {
//            print(email)
//        } else {
//            print("kosong")
//        }
    }
    
    private func setupNavigationController() {
        navigationItem.title = "Profil"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func logoutButtonTapped() {
        let actionSheet = UIAlertController(title: "Keluar Akun", message: "Apakah anda yakin ingin keluar akun?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            do {
                try FirebaseAuth.Auth.auth().signOut()
                UserDefaults.standard.removeObject(forKey: "email")
                UserDefaults.standard.removeObject(forKey: "first_name")
                UserDefaults.standard.removeObject(forKey: "last_name")
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

extension ProfileViewController: ASTableDelegate, ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        let width = UIScreen.main.bounds.width
        return ASSizeRangeMake(CGSize(width: width, height: 0), CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
    }
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0)
        {
            return 0
        }
        else {
            return 1

        }
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        if(indexPath.section == 0) {
            let cell = ProfileHeaderCell()
            cell.backgroundColor = .white
            return cell
        } else if indexPath.section == 1 {
            let cell = SettingListCell(text: "Logout Akun", iconName: "rectangle.portrait.and.arrow.right")
            cell.backgroundColor = .white
            return cell
        } else {
            return ASCellNode()
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            logoutButtonTapped()
        }
    }
}

class ProfileHeaderCell: ASCellNode {
    private var emailTextNode: ASTextNode2 = {
        let name = ASTextNode2()
        name.maximumNumberOfLines = 1
        name.truncationMode = .byTruncatingTail
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        if let email = UserDefaults.standard.value(forKey: "email") as? String {
            name.attributedText = NSAttributedString(string: "\(email)", attributes: attributes)
        }
        return name
    }()
    
    private var nameTextNode: ASTextNode2 = {
        let name = ASTextNode2()
        name.maximumNumberOfLines = 1
        name.truncationMode = .byTruncatingTail
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        if let firstName = UserDefaults.standard.value(forKey: "first_name") as? String, let lastName = UserDefaults.standard.value(forKey: "last_name") as? String {
            name.attributedText = NSAttributedString(string: "\(firstName) \(lastName)", attributes: attributes)
        }
        return name
    }()
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        if let email = UserDefaults.standard.value(forKey: "email") as? String, let name = UserDefaults.standard.value(forKey: "name") as? String {
            let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
            self.emailTextNode.attributedText = NSAttributedString(string: email, attributes: attributes)
            self.nameTextNode.attributedText = NSAttributedString(string: name, attributes: attributes)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let textStack = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: [
            self.nameTextNode,
            self.emailTextNode
        ])
        return ASInsetLayoutSpec(insets: .init(top: 0, left: 16, bottom: 16, right: 16), child: textStack)
    }
}

class SettingListCell: ASCellNode {
    private let text: ASTextNode2 = {
        let textNode = ASTextNode2()
        textNode.truncationMode = .byTruncatingTail
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        textNode.attributedText = NSAttributedString(string: "Atur Profil", attributes: attributes)
        return textNode
    }()
    
    private lazy var icon: ASImageNode = {
        let imageNode = ASImageNode()
        imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor(named: "primaryColor")!)
        imageNode.image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
        imageNode.style.preferredSize = .init(width: 24, height: 24)
        return imageNode
    }()
    
    private lazy var nextIcon: ASImageNode = {
        let imageNode = ASImageNode()
        imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor(named: "primaryColor")!)
        imageNode.image = UIImage(systemName: "chevron.right")
        imageNode.style.preferredSize = .init(width: 12, height: 19)
        return imageNode
    }()
    
    init(text: String, iconName: String) {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .white
        populate(text: text, iconName: iconName)
    }
    
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let firstStack = ASStackLayoutSpec(direction: .horizontal, spacing: 16, justifyContent: .start, alignItems: .center, children: [
            self.icon,
            self.text
        ])
        
        let belowStack = ASStackLayoutSpec(direction: .horizontal, spacing: 8, justifyContent: .spaceBetween, alignItems: .center, children: [
            firstStack,
            self.nextIcon
        ])
        
        let insetedFinalStack = ASInsetLayoutSpec(insets: .init(top: 16, left: 16, bottom: 16, right: 16), child: belowStack)
        return insetedFinalStack
    }
    
    func populate(text: String, iconName: String) {
        self.text.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        self.icon.image = UIImage(systemName: iconName)
    }
}

