//
//  PostInterationNode.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 14/11/22.
//

import Foundation
import AsyncDisplayKit

public final class PostInteractionNode: ASDisplayNode {
    
    private lazy var heartImageNode: ASImageNode = {
        let heartImageNode = ASImageNode()
        heartImageNode.image = UIImage(named: "heart")
        heartImageNode.style.preferredSize = .init(width: 20, height: 20)
        return heartImageNode
    }()
    
    private lazy var messangerImageNode: ASImageNode = {
        let messangerImageNode = ASImageNode()
        messangerImageNode.image = UIImage(named: "messenger")
        messangerImageNode.style.preferredSize = .init(width: 20, height: 20)
        return messangerImageNode
    }()
    
    private lazy var dmImageNode: ASImageNode = {
        let dmImageNode = ASImageNode()
        dmImageNode.image = UIImage(named: "dm")
        dmImageNode.style.preferredSize = .init(width: 20, height: 20)
        return dmImageNode
    }()
    
    private lazy var saveImageNode: ASImageNode = {
        let heartImageNode = ASImageNode()
        heartImageNode.image = UIImage(named: "saved")
        heartImageNode.style.preferredSize = .init(width: 20, height: 20)
        return heartImageNode
    }()
    
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let leftStack = ASStackLayoutSpec(direction: .horizontal, spacing: 8, justifyContent: .start, alignItems: .center, children: [
            heartImageNode,
            messangerImageNode,
            dmImageNode
        ])
        
        let finalStack = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .spaceBetween, alignItems: .center, children: [
            leftStack,
            saveImageNode
        ])
        
        return ASInsetLayoutSpec(insets: .init(top: 2, left: 8, bottom: 4, right: 8), child: finalStack)
    }
}

