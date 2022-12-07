//
//  CategoryNode.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 31/10/22.
//

import Foundation
import AsyncDisplayKit

public final class CategoryNode: ASCellNode {
    
    private let category: CategoryIconModel
    
    private let categoryImageIconNode: ASImageNode = {
        let categoryImageIconNode = ASImageNode()
        categoryImageIconNode.style.preferredSize = .init(width: 60, height: 60)
        return categoryImageIconNode
    }()
    
    private let categoryNameNode: ASTextNode2 = {
        let usernameNode = ASTextNode2()
        usernameNode.maximumNumberOfLines = 1
        usernameNode.truncationMode = .byTruncatingTail
        usernameNode.style.maxWidth = ASDimensionMake(50)
        return usernameNode
    }()
    
    
     init(category: CategoryIconModel) {
        self.category = category
        self.categoryNameNode.attributedText = .init(string: category.category)
        self.categoryImageIconNode.image = UIImage(named: category.image)
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let finalStack = ASStackLayoutSpec(direction: .vertical, spacing: 8, justifyContent: .start, alignItems: .center,
                                 children: [
                                    categoryImageIconNode,
                                    categoryNameNode])
        return ASInsetLayoutSpec(insets: .init(top: 0, left: 16, bottom: 0, right: 0), child: finalStack)
    }
}
