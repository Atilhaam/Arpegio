//
//  PostNode.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 14/11/22.
//

import Foundation
import AsyncDisplayKit

public final class PostNode: ASCellNode {
    private let post: PostModel
    
    private let postHeaderNode: PostHeaderNode
    private let postImageNode: ASImageNode = {
        let postImageNode = ASImageNode()
        postImageNode.style.width = .init(unit: .fraction, value: 1)
        postImageNode.style.height = .init(unit: .points, value: 260)
        postImageNode.contentMode = .scaleAspectFill
        return postImageNode
    }()
    private let postInteractionNode: PostInteractionNode
    private let postInformationNode: PostInformationNode
    
    init(post: PostModel) {
        self.post = post
        self.postHeaderNode = PostHeaderNode(post: post)
        self.postImageNode.image = UIImage(named: post.image)
        self.postInteractionNode = PostInteractionNode()
        self.postInformationNode = PostInformationNode(postModel: post)
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let finalStack = ASStackLayoutSpec(direction: .vertical, spacing: 2, justifyContent: .start, alignItems: .stretch, children: [
            postHeaderNode,
            postImageNode,
            postInteractionNode,
            postInformationNode
        ])
        return ASInsetLayoutSpec(insets: .init(top: 16, left: 8, bottom: 8, right: 8), child: finalStack)
    }
}
