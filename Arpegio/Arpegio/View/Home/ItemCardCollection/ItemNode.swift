//
//  ItemNode.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 25/10/22.
//

import Foundation
import AsyncDisplayKit

public final class ItemNode: ASCellNode {
    private let item: ItemModel
    
    private let postImageNode: ASImageNode = {
        let postImageNode = ASImageNode()
        postImageNode.style.preferredSize = .init(width: 170, height: 150)
        postImageNode.contentMode = .scaleAspectFit
        return postImageNode
    }()
    
    private let priceNode: ASTextNode2 = {
        let priceNode = ASTextNode2()
        priceNode.maximumNumberOfLines = 1
        priceNode.truncationMode = .byTruncatingTail
        priceNode.style.maxWidth = ASDimensionMake(50)
//        priceNode.style.width =
        return priceNode
    }()
    
    private let itemNameNode: ASTextNode2 = {
        let itemNameNode = ASTextNode2()
        itemNameNode.maximumNumberOfLines = 1
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.white]
        itemNameNode.truncationMode = .byTruncatingTail
        itemNameNode.style.maxWidth = ASDimensionMake(50)
        return itemNameNode
    }()
    
    public init(item: ItemModel) {
        self.item = item
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.postImageNode.image = UIImage(named: item.image)
        self.priceNode.attributedText = NSAttributedString(string: item.price, attributes: attrs)
        self.itemNameNode.attributedText = NSAttributedString(string: item.name, attributes: attrs)
        super.init()
        self.style.height = .init(unit: .points, value: 250)
        self.style.width = .init(unit: .fraction, value: 0.49)
        DispatchQueue.main.async {
            self.layer.cornerRadius = 5
        }
//        self.style.width = ASDimensionMake(200)
        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .black
    }
    
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let insetedImageNode = ASInsetLayoutSpec(insets: .init(top: 8, left: 8, bottom: 8, right: 8), child: postImageNode)
        let finalStack = ASStackLayoutSpec(direction: .vertical, spacing: 8, justifyContent: .start, alignItems: .stretch, children: [
            insetedImageNode,
            priceNode,
            itemNameNode,
        ])
        return ASInsetLayoutSpec(insets: .init(top: 8, left: 8, bottom: 0, right: 8), child: finalStack)
    }
}
