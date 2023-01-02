//
//  ProductFavoriteEntity.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 13/12/22.
//

import Foundation
import RealmSwift

class ProductFavoriteEntity: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var category: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var price: String = ""
    @objc dynamic var conditon: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var location: String = ""
    @objc dynamic var pictureUrl: String = ""
    @objc dynamic var contactNumber: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
