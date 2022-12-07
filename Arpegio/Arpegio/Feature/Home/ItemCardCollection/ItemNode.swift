//
//  ItemNode.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 25/10/22.
//

import Foundation
import AsyncDisplayKit

public final class ItemNode: ASCellNode {
    private let item: ItemProductModel
    
    private let postImageNode: ASImageNode = {
        let postImageNode = ASImageNode()
//        postImageNode.style.preferredSize = .init(width: 170, height: 150)
        postImageNode.style.width = .init(unit: .fraction, value: 1)
        postImageNode.style.height = .init(unit: .points, value: 260)
        postImageNode.contentMode = .scaleAspectFill
        return postImageNode
    }()
    
    private let priceNode: ASTextNode2 = {
        let priceNode = ASTextNode2()
        priceNode.maximumNumberOfLines = 0
        priceNode.truncationMode = .byWordWrapping
//        priceNode.style.maxWidth = ASDimensionMake(50)
//        priceNode.style.width =
        return priceNode
    }()
    
    private let itemNameNode: ASTextNode2 = {
        let itemNameNode = ASTextNode2()
        itemNameNode.maximumNumberOfLines = 0
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.white]
        itemNameNode.truncationMode = .byWordWrapping
//        itemNameNode.style.maxWidth = ASDimensionMake(50)
        return itemNameNode
    }()
    
    private let itemLocationNode: ASTextNode2 = {
        let itemLocationNode = ASTextNode2()
        itemLocationNode.maximumNumberOfLines = 0
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.white]
        itemLocationNode.truncationMode = .byWordWrapping
//        itemNameNode.style.maxWidth = ASDimensionMake(50)
        return itemLocationNode
    }()
    
    public init(item: ItemProductModel) {
        self.item = item
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        self.postImageNode.image = UIImage(named: item.pictureUrl)
        self.priceNode.attributedText = NSAttributedString(string: item.price, attributes: attrs)
        self.itemNameNode.attributedText = NSAttributedString(string: item.name, attributes: attrs)
        self.itemLocationNode.attributedText = NSAttributedString(string: item.location, attributes: attrs)
        super.init()
        self.style.height = .init(unit: .points, value: 400)
        self.style.width = .init(unit: .fraction, value: 1)
        DispatchQueue.main.async {
            self.layer.cornerRadius = 5
        }
        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .black
    }
    
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let insetedImageNode = ASInsetLayoutSpec(insets: .init(top: 8, left: 8, bottom: 8, right: 8), child: postImageNode)
        let finalStack = ASStackLayoutSpec(direction: .vertical, spacing: 8, justifyContent: .start, alignItems: .stretch, children: [
            insetedImageNode,
            priceNode,
            itemNameNode,
            itemLocationNode
        ])
        return ASInsetLayoutSpec(insets: .init(top: 8, left: 8, bottom: 0, right: 8), child: finalStack)
    }
}
