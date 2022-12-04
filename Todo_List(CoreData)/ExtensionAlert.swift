//
//  ExtensionAlert.swift
//  Todo_List(CoreData)
//
//  Created by Zaghloul on 03/12/2022.
//

import UIKit

struct ExtensionAlert {
    
    static func alert(vc: UIViewController ,title: String?, message: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }
}
