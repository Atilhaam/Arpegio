//
//  PostInformationNode.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 14/11/22.
//

import Foundation
import AsyncDisplayKit

public final class PostInformationNode: ASDisplayNode {
    
    
    private let postNameCaptionNode = ASTextNode2()
    private let postLikeCountNode = ASTextNode2()
    
    public init(postModel: PostModel) {
        postNameCaptionNode.attributedText = .init(string: "\(postModel.userName) \(postModel.caption)")
        postNameCaptionNode.maximumNumberOfLines = 0
        postNameCaptionNode.truncationMode = .byWordWrapping
        postLikeCountNode.attributedText = .init(string: "\(postModel.likesCount) likes")
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec(direction: .vertical, spacing: 8, justifyContent: .start, alignItems: .start, children: [
            postLikeCountNode,
            postNameCaptionNode
        ])
    }
}
