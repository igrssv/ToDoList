//
//  ViewController.swift
//  ToDoList
//
//  Created by Игорь Сысоев on 14.10.2021.
//

import UIKit
import CoreData

class ToDoListController : UITableViewController{
    private let cellID = "task"
    private var taskList: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        fetchData()
    }
    
//MARK: - Navigation
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

//MARK: - Add Tasks
    @objc private func addTask() {
        showAlert()
    }
    
    
//MARK: - Working with StorageManager
    
    private func fetchData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let tasks):
                self.taskList = tasks
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func save(_ taskName: String) {
        StorageManager.shared.save(taskName) { task in
            self.taskList.append(task)
            let cellIndex = IndexPath(row: self.taskList.count - 1, section: 0)
            tableView.insertRows(at: [cellIndex], with: .automatic)
        }
    }

}

//MARK: - UITabelView
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
    
    // Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        
        if editingStyle == .delete {
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.shared.delete(task)
        }
    }
    
    // Edit
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        showAlert(task: task) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
}


//MARK: - AlertController
extension ToDoListController {
    private func showAlert(task: Task? = nil, complection: (() -> Void)? = nil ) {
        let title = task != nil ? "Edit task" : "Add task"
        let alert = UIAlertController.saveActionCreate(title: title)
        
        alert.action(task: task) { taskName in
            if let task = task, let complection = complection {
                StorageManager.shared.edit(task, newName: taskName)
                complection()
            } else {
                self.save(taskName)
            }
        }
        present(alert, animated: true)
    }
}
