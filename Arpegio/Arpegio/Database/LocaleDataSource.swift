//
//  LocaleDataSource.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 13/12/22.
//

import Foundation
import RealmSwift
import RxSwift

protocol LocaleDataSourceProtocl: class {
    
}

final class LocaleDataSource: NSObject {
    
    private let realm: Realm? = try? Realm()
//    private init(realm: Realm?) {
//        self.realm = realm
//    }
//
//    static let sharedInstance: (Realm?) -> LocaleDataSource = { realmDatabase in
//        return LocaleDataSource(realm: realmDatabase)
//    }
    
}
extension LocaleDataSource: LocaleDataSourceProtocl {
    func getFavoriteProducts() -> Observable<[ProductFavoriteEntity]> {
        return Observable<[ProductFavoriteEntity]>.create { observer in
            if let realm = self.realm {
                let products: Results<ProductFavoriteEntity> = {
                    realm.objects(ProductFavoriteEntity.self)
                        .sorted(byKeyPath: "name", ascending: true)
                }()
                observer.onNext(products.toArray(ofType: ProductFavoriteEntity.self))
                observer.onCompleted()
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            return Disposables.create()
        }
    }
    
    func addProductToFavorite(from product: ProductFavoriteEntity) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            if let realm = self.realm {
                do {
                    try realm.write {
                        realm.add(product, update: .all)
                        observer.onNext(true)
                        observer.onCompleted()
                    }
                } catch {
                    observer.onError(DatabaseError.requestFailed)
                }
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            return Disposables.create()
        }
    }
    
    func removeProductFromFavorite(id: String) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            if let realm = self.realm {
                if let product = realm.object(ofType: ProductFavoriteEntity.self, forPrimaryKey: id) {
                    do {
                        try realm.write {
                            realm.delete(product)
                            observer.onNext(true)
                            observer.onCompleted()
                        }
                    } catch {
                        observer.onError(DatabaseError.requestFailed)
                    }
                } else {
                    observer.onError(DatabaseError.requestFailed)
                }
            } else {
                observer.onError(DatabaseError.requestFailed)
            }
            return Disposables.create()
        }
    }
    
    func getProductFavoriteInfo(from product: ItemProductModel) -> Observable<ProductFavoriteEntity> {
        return Observable<ProductFavoriteEntity>.create { observer in
            let newFavProduct = ProductFavoriteEntity()
            newFavProduct.id = product.id
            newFavProduct.category = product.category
            newFavProduct.name = product.name
            newFavProduct.price = product.price
            newFavProduct.conditon = product.condition
            newFavProduct.desc = product.desc
            newFavProduct.location = product.location
            newFavProduct.pictureUrl = product.pictureUrl
            newFavProduct.contactNumber = product.contactNumber
            observer.onNext(newFavProduct)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func checkFavorite(id: String) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            if let realm = self.realm {
                let object = realm.object(ofType: ProductFavoriteEntity.self, forPrimaryKey: id)
                if object != nil {
                    observer.onNext(true)
                    observer.onCompleted()
                } else {
                    observer.onNext(false)
                    observer.onCompleted()
                }
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            return Disposables.create()
        }
    }
}

extension Results {
    
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for index in 0..<count {
            if let result = self[index] as? T {
                array.append(result)
            }
        }
        return array
    }
}
