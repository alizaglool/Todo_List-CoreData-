//
//  TodoCellTableViewCell.swift
//  Todo_List(CoreData)
//
//  Created by Zaghloul on 24/11/2022.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var todoImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
