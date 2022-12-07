//
//  StoryNode.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 25/10/22.
//

import Foundation
import AsyncDisplayKit

public final class StoryNode: ASCellNode {
    
    private let story: StoryModel
    
    private let userAvatarNode: ASImageNode = {
        let userAvatarNode = ASImageNode()
        userAvatarNode.style.preferredSize = .init(width: 60, height: 60)
        userAvatarNode.onDidLoad {
            $0.layer.cornerRadius = 30
        }
        return userAvatarNode
    }()
    
    private let usernameNode: ASTextNode2 = {
        let usernameNode = ASTextNode2()
        usernameNode.maximumNumberOfLines = 1
        usernameNode.truncationMode = .byTruncatingTail
        usernameNode.style.maxWidth = ASDimensionMake(50)
        return usernameNode
    }()
    
    
    public init(story: StoryModel) {
        self.story = story
        self.usernameNode.attributedText = .init(string: story.userName)
        self.userAvatarNode.image = UIImage(named: story.userAvatar)
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let finalStack = ASStackLayoutSpec(direction: .vertical, spacing: 8, justifyContent: .start, alignItems: .center,
                                 children: [
                                    userAvatarNode,
                                    usernameNode])
        return ASInsetLayoutSpec(insets: .init(top: 0, left: 16, bottom: 0, right: 0), child: finalStack)
    }
}
