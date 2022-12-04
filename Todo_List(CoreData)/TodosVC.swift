//
//  ViewController.swift
//  Todo_List(CoreData)
//
//  Created by Zaghloul on 24/11/2022.
//

import UIKit
import CoreData

class TodosVC: UIViewController {

    @IBOutlet weak var todoTableView: UITableView!

    var todoArrary: [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.todoArrary = getTodo()
        // Add Todo
        NotificationCenter.default.addObserver(self, selector: #selector(newTodoAdded), name: NSNotification.Name(rawValue: "NewTodoAdded"), object: nil)
        // Edit Todo
        NotificationCenter.default.addObserver(self, selector: #selector(CurrentEditTodo), name: NSNotification.Name(rawValue: "CurrentEditTodo"), object: nil)
        // Delete Todo
        NotificationCenter.default.addObserver(self, selector: #selector(deleteTodo), name: NSNotification.Name(rawValue: "todoDeleteIndex"), object: nil)
        
        todoTableView.delegate = self
        todoTableView.dataSource = self
    }
    
    @objc func newTodoAdded(notification: Notification){
        
        if let mytodo = notification.userInfo?["addNewTodo"] as? Todo {
            todoArrary.append(mytodo)
            todoTableView.reloadData()
            storeTodo(todo: mytodo)
        }
    }
    
    @objc func CurrentEditTodo(notification: Notification){
        if let todo = notification.userInfo?["todoEdit"] as? Todo {
            if let index = notification.userInfo?["indexEditTodo"] as? Int {
                todoArrary[index] = todo
                todoTableView.reloadData()
                updataTodos(todo: todo, index: index)
            }
        }
    }
    @objc func deleteTodo(notification: Notification){
        if let index = notification.userInfo?["todoDelete"] as? Int {
            todoArrary.remove(at: index)
            todoTableView.reloadData()
            deleteTodos(index: index)
        }
    }
}

extension TodosVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArrary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") as! TodoCell
        cell.titelLabel.text = todoArrary[indexPath.row].titel
        
        if todoArrary[indexPath.row].image != nil {
            cell.todoImageView.image = todoArrary[indexPath.row].image
        }else {
            cell.todoImageView.image = UIImage(named: "nyoo")
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selected = todoArrary[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC
        vc?.todo = selected
        vc?.index = indexPath.row
        if let viewsController = vc {
            self.navigationController?.pushViewController(viewsController, animated: true)
        }
    }
    
}
extension TodosVC {
    
    func storeTodo(todo: Todo){

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let manageContext = appDelegate.persistentContainer.viewContext
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "Todos", in: manageContext) else { return  }
        let todoObject = NSManagedObject(entity: todoEntity, insertInto: manageContext)
        todoObject.setValue(todo.titel, forKey: "title")
        todoObject.setValue(todo.details, forKey: "details")
        if let image = todo.image {
            let imageContext = image.jpegData(compressionQuality: 0.7)
            todoObject.setValue(imageContext, forKey: "image")
        }
        do {
            try manageContext.save()
            print("=====Succes===")
        }catch {
            print("=====Error====")
        }
        
    }
    
    func getTodo() -> [Todo] {
        var todos: [Todo] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return [] }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
        
        do {
            let reuslt = try context.fetch(fetchRequest) as! [NSManagedObject]
            for manageTodo in reuslt {
                let title = manageTodo.value(forKey: "title") as? String
                let details = manageTodo.value(forKey: "details") as? String
                
                var todoImage: UIImage? = nil
                if let imageFromContext = manageTodo.value(forKey: "image") as? Data {
                    todoImage = UIImage(data: imageFromContext)
                }
                let todo = Todo(titel: title ?? "", image: todoImage, details: details ?? "")
                todos.append(todo)
            }
        }catch {
            print("====Error====")
        }
        return todos
    }
    
    func updataTodos(todo: Todo, index: Int){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
        
        do {
            let reuslt = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            reuslt[index].setValue(todo.titel, forKey: "title")
            reuslt[index].setValue(todo.details, forKey: "details")
            if let image = todo.image {
                let imageData = image.jpegData(compressionQuality: 0.7)
                reuslt[index].setValue(imageData, forKey: "image")
            }
            try context.save()
        }catch {
            print("====Error====")
        }
    }
    
    func deleteTodos(index: Int){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
        
        do {
            let reuslt = try context.fetch(fetchRequest) as! [NSManagedObject]
            let todoDelete = reuslt[index]
            context.delete(todoDelete)
            try context.save()
        }catch {
            print("====Error====")
        }
    }
}
