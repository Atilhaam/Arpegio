//
//  ItemCardCollectionNode.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 24/10/22.
//

import Foundation
import AsyncDisplayKit

public final class ItemCardCollectionNode: ASCollectionNode {
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumInteritemSpacing = 4
        collectionViewFlowLayout.minimumLineSpacing = 8
        collectionViewFlowLayout.scrollDirection = .vertical
        return collectionViewFlowLayout
    }()
    
    private let items: [ItemModel]
    
    public init(items: [ItemModel]) {
        self.items = items
        super.init(frame: .zero, collectionViewLayout: collectionViewFlowLayout, layoutFacilitator: nil)
        self.automaticallyManagesSubnodes = true
        self.showsVerticalScrollIndicator = false
        self.delegate = self
        self.dataSource = self
        self.style.width = .init(unit: .fraction, value: 1)
        self.style.height = .init(unit: .points, value: 4000)
    }
    
}

extension ItemCardCollectionNode: ASCollectionDelegate, ASCollectionDataSource {
    public func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    public func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let itemData = self.items[indexPath.row]
        return {
            ItemNode(item: itemData)
        }
    }
    
    
}
