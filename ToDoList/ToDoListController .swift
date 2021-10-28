//
//  ViewController.swift
//  ToDoList
//
//  Created by Игорь Сысоев on 14.10.2021.
//

import UIKit
import CoreData

protocol ToDoListControllerDelegate {
    func reloadDate()
}

class ToDoListController : UITableViewController{
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let cellID = "task"
    private var taskList: [Task] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        fetchData()
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTask))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        navigationController?.navigationBar.standardAppearance = navBarApperance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarApperance
        
        
        
    }
    
    @objc private func addTask() {
        let addTaskVC = AddTaskViewController()
        addTaskVC.delegate = self
        present(addTaskVC, animated: true)
    }

    private func fetchData() {
        let fetchReqest = Task.fetchRequest()
        
        do {
            taskList = try context.fetch(fetchReqest)
        } catch let error {
            print("Faild to fetch data", error)
        }
    }
}

//MARK: - UITabelViewDataSource
extension ToDoListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.titel
        cell.contentConfiguration = content
        return cell
    }
}


//MARK: - ToDoListControllerDelegate
extension ToDoListController: ToDoListControllerDelegate {
    func reloadDate() {
        fetchData()
        tableView.reloadData()
        
    }
}
