//
//  ViewController.swift
//  ToDoList
//
//  Created by Игорь Сысоев on 14.10.2021.
//

import UIKit

class ToDoListController : UITableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
    }
    
    
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarApperance = UINavigationBarAppearance()
        navBarApperance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255)
        
        navBarApperance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarApperance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarApperance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarApperance
        
        
    }


}

