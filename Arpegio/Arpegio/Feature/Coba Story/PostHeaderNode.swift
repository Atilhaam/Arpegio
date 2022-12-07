//
//  PostHeaderNode.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 14/11/22.
//

import Foundation
import AsyncDisplayKit

public final class PostHeaderNode: ASDisplayNode {
    
    private let post: PostModel
    
    private lazy var usernameNode: ASTextNode = {
        let userNameNode = ASTextNode()
        userNameNode.attributedText = .init(string: post.userName)
        return userNameNode
    }()
    
    private var locationNode: ASTextNode2?
    
    private lazy var userAvatarNode: ASImageNode = {
        let userAvatarNode = ASImageNode()
        userAvatarNode.image = UIImage(named: post.image)
        userAvatarNode.style.preferredSize = .init(width: 20, height: 20)
        userAvatarNode.onDidLoad {
            $0.layer.cornerRadius = 10
        }
        return userAvatarNode
    }()
    
    private let threedotImageNode: ASImageNode = {
        let threedotImageNode = ASImageNode()
        threedotImageNode.image = UIImage(named: "threedot")
        threedotImageNode.style.preferredSize = .init(width: 20, height: 20)
        return threedotImageNode
    }()
    
    init(post: PostModel) {
        self.post = post
        super.init()
        if let location = post.location {
            locationNode = ASTextNode2()
            locationNode?.attributedText = .init(string: location)
        }
        self.automaticallyManagesSubnodes = true
    }
    
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var userNameLocationStack = ASLayoutSpec()
        if let locationNode = locationNode {
            userNameLocationStack = ASStackLayoutSpec(direction: .vertical, spacing: 8, justifyContent: .start, alignItems: .center, children: [
                usernameNode,
                locationNode
            ])
        } else {
            userNameLocationStack = ASWrapperLayoutSpec(layoutElement: usernameNode)
        }
        
        let leftStack = ASStackLayoutSpec(direction: .horizontal, spacing: 8, justifyContent: .start, alignItems: .center, children: [
            userAvatarNode,
            userNameLocationStack
        ])
        
        return ASStackLayoutSpec(direction: .horizontal, spacing: 2, justifyContent: .spaceBetween, alignItems: .center, children: [
            leftStack,
            threedotImageNode
        ])
    }
}
