//
//  AddCategoryProductViewController.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 31/10/22.
//

import UIKit

class AddCategoryProductViewController: UIViewController {
    
    private let backButton: UIButton = {
        let backbutton = UIButton(type: .custom)
        backbutton.setImage(UIImage(named: "backButton"), for: .normal)
        return backbutton
    }()
    
    private let tableView: UITableView = {
        let tableview = UITableView()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableview
    }()
    
    
    
    let categories = ["Electric Guitar","Acoustic Guitar","Pedal","Amplifier","Bass","Piano","Synth","Drum"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        view.addSubview(tableView)
        view.backgroundColor = .white
        self.title = "Categories"
        tableView.delegate = self
        tableView.dataSource = self
        let uid1 = UUID().uuidString
        let uid2 = UUID().uuidString
        print("ini uid1 \(uid1)")
        print("ini uid2 \(uid2)")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    @objc func backAction() {
        self.navigationController?.dismiss(animated: true)
    }

}

extension AddCategoryProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let addProductVc = AddProductViewController()
        addProductVc.category = categories[indexPath.row]
        
        self.navigationController?.pushViewController(addProductVc, animated: true)
    }
}
