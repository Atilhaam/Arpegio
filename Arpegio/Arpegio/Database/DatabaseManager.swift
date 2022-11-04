//
//  DatabaseManager.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 19/10/22.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

extension DatabaseManager {
    
    public func getDataFor(path: String, completion: @escaping (Result<Any, Error>) -> Void) {
        self.database.child("\(path)").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
}

// MARK: - Account management
extension DatabaseManager {
    /*
     ilham-wayne-gmail-com =>
     {
        first_name = "",
        last_name = "",
        products = [
         0: [
               id: "",
               picture: "",
               category: "",
               name: "",
               price: "",
               condition: "",
               desc: "",
               location: ""
               
            ]
        ]
     }
     
     productId => {
         id: "",
         picture: "",
         category: "",
         name: "",
         price: "",
         condition: "",
         desc: "",
         location: ""
     }
     
     ElectricGuitars => {
         0: [
           id: "",
           picture: "",
           category: "",
           name: "",
           price: "",
           location: ""
            ]
     
     }
     
     products => {
      0: [
        id: "",
        picture: "",
        category: "",
        name: "",
        price: "",
        location: ""
         ]
     }
     */
    public func insertProduct(with email: String, product: ProductDetail, completion: @escaping ((Bool) -> Void)) {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)

        let ref = database.child("\(safeEmail)")

        ref.observeSingleEvent(of: .value, with: { [weak self] snapshot in

            guard var userNode = snapshot.value as? [String:Any] else {
                completion(false)
                print("user not found")
                return
            }
            
            let productId = UUID().uuidString
            let productData: [String: Any] = [
                "id": productId,
                "picture": "",
                "category": "",
                "name": "",
                "price": "",
                "condition": "",
                "desc": "",
                "location": ""
            ]
            
            //nambahin ke head products
            self?.database.child("products").observeSingleEvent(of: .value, with: { snapshot in
                if var productCollections = snapshot.value as? [[String: Any]] {
                    productCollections.append(productData)
                    
                    self?.database.child("products").setValue(productCollections, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            print("gagal")
                            return
                        }
                        completion(true)
                    })
                } else {
                    let newCollection: [[String:Any]] = [
                        productData
                    ]
                    self?.database.child("products").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
            
            //nambahin ke head categoryproducts
            self?.database.child(product.category).observeSingleEvent(of: .value, with: { snapshot in
                if var productCollections = snapshot.value as? [[String: Any]] {
                    productCollections.append(productData)
                    
                    self?.database.child(product.category).setValue(productCollections, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            print("gagal")
                            return
                        }
                        completion(true)
                    })
                } else {
                    let newCollection: [[String:Any]] = [
                        productData
                    ]
                    self?.database.child(product.category).setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
            
            //nambahin ke head productid
            self?.database.child("\(productId)").setValue(productData, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            })
            
            //nambahin ke head user
            if var products = userNode["products"] as? [[String:Any]] {
                products.append(productData)
                userNode["products"] = products
                ref.setValue(userNode, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                })
            } else {
                userNode["products"] = [
                    productData
                ]
                
                ref.setValue(userNode, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                })
            }
            
            
        })
    }
    
    public func userExist(with email: String, completion: @escaping ((Bool) -> Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? [String:Any] != nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
   
    /// Insert new user to database
    public func insertUser(with user: ArpegioAppUser, completion: @escaping (Bool)-> Void) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ], withCompletionBlock: { error, _ in
            guard error == nil else {
                print("failed to write database")
                completion(false)
                return
            }
            self.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if var usersCollection = snapshot.value as? [[String: String]] {
                    let newElement = [
                        "name": user.firstName + " " + user.lastName,
                        "email": user.safeEmail
                    ]
                    usersCollection.append(newElement)
                    
                    self.database.child("users").setValue(usersCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                } else {
                    //create that array
                    let newCollection: [[String: String]] = [
                        [
                            "name": user.firstName + " " + user.lastName,
                            "email": user.safeEmail
                        ]
                    ]
                    self.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
        })
    }
    
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
    
    public enum DatabaseError: Error {
        case failedToFetch
    }
    /*
     users => [
        [
            "name":
            "safe_email":
        ],
        [
            "name":
            "safe_mail":
        ]
     ]
     */
}
struct ProductDetail {
    let category: String
    let picture: String
    let name: String
    let price: String
    let condition: String
    let desc: String
    let location: String
}

struct ProductType {
    let id: String
    let electricGuitar: String
    let acousticGuitar: String
    let pedal: String
    let amplifier: String
    let bass: String
    let piano: String
    let synth: String
    let drum: String
}

struct ArpegioAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String  {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    var profilePictureUrl: String {
        return "\(safeEmail)_profile_picture.png"
    }
}
