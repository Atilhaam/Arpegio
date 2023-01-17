//
//  RemoteFavoriteDataSource.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 16/01/23.
//

import Foundation
import FirebaseDatabase
import RxSwift

final class RemoteFavoriteDataSource {
    static let shared = RemoteFavoriteDataSource()
    
    private let database = Database.database().reference()
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

extension RemoteFavoriteDataSource {
    public func getFavoriteProducts(for email: String) -> Observable<[ItemProductModel]> {
        return Observable<[ItemProductModel]>.create { [weak self] observer in
            self?.database.child("\(email)/favorites").observe(.value, with: { snapshot in
                guard let value = snapshot.value as? [[String:Any]] else {
                    print("error di guard pertama")
                    observer.onError(URLError.invalidResponse)
                    return
                }
                let products: [ItemProductModel] = value.compactMap { dictionary in
                    guard let productId = dictionary["id"] as? String,
                          let category = dictionary["category"] as? String,
                          let name = dictionary["name"] as? String,
                          let price = dictionary["price"] as? String,
                          let condition = dictionary["condition"] as? String,
                          let desc = dictionary["desc"] as? String,
                          let location = dictionary["location"] as? String,
                          let pictureUrl = dictionary["pictureUrl"] as? String,
                            let contact = dictionary["contact"] as? String
                    else {
                        observer.onError(URLError.invalidResponse)
                        print("error di guard ke dua")
                        return nil
                    }
                    return ItemProductModel(id: productId, category: category, name: name, price: price, condition: condition, desc: desc, location: location, pictureUrl: pictureUrl, contactNumber: contact)
                }
                observer.onNext(products)
            })
            return Disposables.create()
        }
    }
    
    public func addProductToFavorite(with email: String, product: ItemProductModel) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            let safeEmail = RemoteFavoriteDataSource.safeEmail(emailAddress: email)
            
            let ref = self.database.child("\(safeEmail)")
            
            ref.observeSingleEvent(of: .value, with: { snapshot in
                guard var userNode = snapshot.value as? [String:Any] else {
                    observer.onNext(false)
                    print("user not found")
                    return
                }
                
                let productData: [String: Any] = [
                    "id": product.id,
                    "pictureUrl": product.pictureUrl,
                    "category": product.category,
                    "name": product.name,
                    "price": product.price,
                    "condition": product.condition,
                    "desc": product.desc,
                    "location": product.location,
                    "email": safeEmail,
                    "contact" : product.contactNumber
                ]
                
                if var products = userNode["favorites"] as? [[String:Any]] {
                    products.append(productData)
                    userNode["favorites"] = products
                    ref.setValue(userNode, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            observer.onNext(false)
                            return
                        }
                        observer.onNext(true)
                        observer.onCompleted()
                    })
                } else {
                    userNode["favorites"] = [
                        productData
                    ]
                    ref.setValue(userNode, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            observer.onNext(false)
                            return
                        }
                        
                        observer.onNext(true)
                        observer.onCompleted()
                    })
                }
                
            })
            
            return Disposables.create()
        }
    }
    
    public func removeProductFromFavorite(with email: String, product: ItemProductModel) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            let safeEmail = RemoteFavoriteDataSource.safeEmail(emailAddress: email)
            
            let query: DatabaseQuery = self.database.child("\(safeEmail)/favorites").queryOrdered(byChild: "id").queryEqual(toValue: product.id)
            
            query.observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    let key = (child as AnyObject).key as String
                    self.database.child("\(safeEmail)/favorites").child(key).observeSingleEvent(of: .value, with: { snapshot in
                        guard snapshot.value as? [String:Any] != nil else {
                            observer.onNext(false)
                            print("error kosong")
                            return
                        }
                        snapshot.ref.removeValue()
                        observer.onNext(true)
                        observer.onCompleted()
                    })
                }
            }) { (error) in
                observer.onNext(false)
                print(error.localizedDescription)
            }
            return Disposables.create()
        }
    }
    
    public func checkFavoriteById(with email: String, product: ItemProductModel) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            let safeEmail = RemoteFavoriteDataSource.safeEmail(emailAddress: email)
            
            let query: DatabaseQuery = self.database.child("\(safeEmail)/favorites").queryOrdered(byChild: "id").queryEqual(toValue: product.id)
            
            query.observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    let key = (child as AnyObject).key as String
                    self.database.child("\(safeEmail)/favorites").child(key).observeSingleEvent(of: .value, with: { snapshot in
                        guard snapshot.value as? [String:Any] != nil else {
                            observer.onNext(false)
                            return
                        }
                        observer.onNext(true)
                        observer.onCompleted()
                    })
                }
            }) { (error) in
                observer.onNext(false)
                print(error.localizedDescription)
            }
            return Disposables.create()
        }
    }
}


