//
//  MyTabBarViewController.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 19/10/22.
//

import UIKit

class MyTabBarViewController: UITabBarController {
    
    public lazy var middleButton: UIButton! = {
        let middleButton = UIButton()
        
        middleButton.frame.size = CGSize(width: 60, height: 60)
        
        let image = UIImage(systemName: "plus")
        middleButton.setImage(image, for: .normal)
//        middleButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        middleButton.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.4117647059, blue: 0.3803921569, alpha: 1)
        middleButton.tintColor = .white
        middleButton.layer.cornerRadius = 50
        middleButton.addTarget(self, action: #selector(self.middleButtonAction), for: .touchUpInside)
        return middleButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        
        let profileViewController = UINavigationController(rootViewController: ProfileViewController())
        
        let myProductViewController = UINavigationController(rootViewController: MyProductViewController())
        
        let favoriteProduct = UINavigationController(rootViewController: FavoriteViewController())
        
        let addProductViewController = UINavigationController(rootViewController: AddProductViewController())
        
        
        homeViewController.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "house"), tag: 0)
        favoriteProduct.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "bookmark"), tag: 1)
        myProductViewController.tabBarItem = UITabBarItem(title: "My Product", image: UIImage(systemName: "bag.fill"), tag: 3)
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 4)
        addProductViewController.tabBarItem = UITabBarItem(title: nil, image: nil, selectedImage: nil)

        
        viewControllers = [homeViewController,favoriteProduct,addProductViewController,myProductViewController, profileViewController]
        
    
        for i in 0 ..< viewControllers!.count {
            if i == 2 {
                viewControllers![i].tabBarController?.tabBar.addSubview(middleButton)
                middleButton.center = CGPoint(x: self.view.frame.width / 2, y: 25)
                middleButton.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
                middleButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                middleButton.layer.shadowRadius = 4.0
                middleButton.layer.shadowOpacity = 0.4
                middleButton.layer.masksToBounds = false
            }
        }
        
    }
    

 
    // MARK: - Actions
    @objc func middleButtonAction(sender: UIButton) {
       self.routeToCreateNewAd()
    }
    
    func routeToCreateNewAd() {
        let createAdNavController = UINavigationController(rootViewController: AddCategoryProductViewController())
        createAdNavController.modalPresentationCapturesStatusBarAppearance = true
        createAdNavController.modalPresentationStyle = .fullScreen
        self.present(createAdNavController, animated: true, completion: nil)
    }

}

