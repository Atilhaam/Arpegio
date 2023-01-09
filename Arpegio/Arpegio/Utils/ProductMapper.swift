//
//  ProductMapper.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 02/01/23.
//

import Foundation

final class ProductMapper {
    static func mapProductFavoriteEntitiesToDomains(input productFavoriteEntities: [ProductFavoriteEntity]) -> [ItemProductModel] {
        return productFavoriteEntities.map { result in
            return ItemProductModel(
                id: result.id,
                category: result.category,
                name: result.name,
                price: result.price,
                condition: result.conditon,
                desc: result.desc,
                location: result.location,
                pictureUrl: result.pictureUrl,
                contactNumber: result.contactNumber)
        }
    }
}
