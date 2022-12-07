//
//  CategoryCollectionNode.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 31/10/22.
//

import Foundation
import AsyncDisplayKit

public final class CategoryCollectionNode: ASCollectionNode {
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumInteritemSpacing = 8
        collectionViewFlowLayout.scrollDirection = .horizontal
        return collectionViewFlowLayout
    }()
    
    private let categories: [CategoryIconModel] = [
        CategoryIconModel(category: "Electric Guitar", image: "ElectricGuitar"),
        CategoryIconModel(category: "Acoustic Guitar", image: "AcousticGuitar"),
        CategoryIconModel(category: "Pedal", image: "Pedal"),
        CategoryIconModel(category: "Amplifier", image: "Amplifier"),
        CategoryIconModel(category: "Bass", image: "Bass"),
        CategoryIconModel(category: "Piano", image: "Piano"),
        CategoryIconModel(category: "Synth", image: "Synth"),
        CategoryIconModel(category: "Drum", image: "Drum")
    ]
    
    public init() {
        super.init(frame: .zero, collectionViewLayout: collectionViewFlowLayout, layoutFacilitator: nil)
        self.automaticallyManagesSubnodes = true
        self.showsHorizontalScrollIndicator = false
        self.delegate = self
        self.dataSource = self
        self.style.width = .init(unit: .fraction, value: 1)
        self.style.height = .init(unit: .points, value: 100)
    }
}

extension CategoryCollectionNode: ASCollectionDelegate, ASCollectionDataSource {
    public func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    public func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let categoryData = self.categories[indexPath.row]
        return {
            CategoryNode(category: categoryData)
        }
    }
    
}

struct CategoryIconModel {
    let category: String
    let image: String
}
