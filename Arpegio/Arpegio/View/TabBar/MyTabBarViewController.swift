//
//  MyTabBarViewController.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 19/10/22.
//

import UIKit

class MyTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let firstViewController = UINavigationController(rootViewController: HomeViewController())
        let secondViewController = UINavigationController(rootViewController: ProfileViewController())
        firstViewController.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "house"), tag: 0)
        secondViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 1)
        
        viewControllers = [firstViewController,secondViewController]
    }


}
