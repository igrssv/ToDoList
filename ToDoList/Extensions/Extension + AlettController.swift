//
//  Extension + AlettController.swift
//  ToDoList
//
//  Created by Игорь Сысоев on 14.11.2021.
//

import Foundation
import UIKit

extension UIAlertController {
    static  func saveActionCreate(title: String) -> UIAlertController {
        UIAlertController(title: title, message: "What do you want to do?", preferredStyle: .alert)
    }
    
    func action(task: Task?, complection: @escaping (String) -> Void) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newWalue = self.textFields?.first?.text else { return }
            guard !newWalue.isEmpty else { return }
            complection(newWalue)
            }
        let cancelActrion = UIAlertAction(title: "Cancel", style: .destructive)
        addAction(saveAction)
        addAction(cancelActrion)
        addTextField { textField in
            textField.placeholder = "Task"
            textField.text = task?.titel
        }
        
    }
    

}
