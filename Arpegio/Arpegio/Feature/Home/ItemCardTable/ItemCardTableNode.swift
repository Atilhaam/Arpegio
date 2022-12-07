//
//  ItemCardTableNode.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 14/11/22.
//

import Foundation
import AsyncDisplayKit

public final class ItemCardTableNode: ASTableNode {
    private let items: [ItemProductModel]
    
    init(items: [ItemProductModel]) {
        self.items = items
        super.init(style: .plain)
        self.delegate = self
        self.dataSource = self
        self.style.width = .init(unit: .fraction, value: 1)
        self.style.height = .init(unit: .points, value: 5000)
    }
    
    public override func didLoad() {
        super.didLoad()
//        self.view.sep
    }
    
}

extension ItemCardTableNode: ASTableDelegate, ASTableDataSource {
    public func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    public func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let itemData = items[indexPath.row]
        return {
            ItemCardNode(item: itemData)
        }
    }
}
