//
//  DetailsVC.swift
//  Todo_List(CoreData)
//
//  Created by Zaghloul on 24/11/2022.
//

import UIKit

class DetailsVC: UIViewController {

    var todo: Todo?
    var index: Int!
    
    @IBOutlet weak var imageTodoDetails: UIImageView!
    @IBOutlet weak var titelTodoDetails: UILabel!
    @IBOutlet weak var detailsTodo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if todo?.image != nil {
            imageTodoDetails.image = todo?.image
        }else {
            imageTodoDetails.image = UIImage(named: "nyoo")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(CurrentEditTodo), name: NSNotification.Name(rawValue: "CurrentEditTodo"), object: nil)
        setupUI()
    }
    @objc func CurrentEditTodo(notification: Notification){
        if let todo = notification.userInfo?["todoEdit"] as? Todo {
            self.todo = todo
            setupUI()
        }
    }
    func setupUI(){
        titelTodoDetails.text = todo?.titel
        detailsTodo.text = todo?.details
        imageTodoDetails.image = todo?.image
    }
    
    @IBAction func editButtonClicked(_ sender: UIButton) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "NewTodoVC") as? NewTodoVC {
            vc.isCreation = false
            vc.editTodo = todo
            vc.editeTodoIndex = index
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "todoDeleteIndex"), object: nil, userInfo: ["todoDelete": index])
    }
}
