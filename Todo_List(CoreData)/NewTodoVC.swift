//
//  NewTodoVC.swift
//  Todo_List(CoreData)
//
//  Created by Zaghloul on 24/11/2022.
//

import UIKit

class NewTodoVC: UIViewController {

    
    @IBOutlet weak var titelTF: UITextField!
    @IBOutlet weak var detailsTV: UITextView!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var todoImageView: UIImageView!
    
    var isCreation = true
    var editTodo: Todo?
    var editeTodoIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !isCreation {
            mainButton.setTitle("Edit", for: .normal)
            navigationItem.title = "Edit Todo"
            if let editTodo = editTodo {
                titelTF.text = editTodo.titel
                detailsTV.text = editTodo.details
                todoImageView.image = editTodo.image
            }
        }
    }
    
    @IBAction func changeImageButtonClicked(_ sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func addButtonClicked(_ sender: UIButton) {
        if isCreation {
            let newTodo = Todo(titel: titelTF.text!, image: todoImageView.image, details: detailsTV.text)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewTodoAdded"), object: nil, userInfo: ["addNewTodo": newTodo])
        }else {
            
            let todo = Todo(titel: titelTF.text!, image: todoImageView.image, details: detailsTV.text)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentEditTodo"), object: nil, userInfo: ["todoEdit": todo, "indexEditTodo": editeTodoIndex!])
        }
       
    }
    
}
extension NewTodoVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imagepicker = info[.editedImage] as? UIImage else {return}
        
        dismiss(animated: true, completion: nil)
        todoImageView.image = imagepicker
    }
}
