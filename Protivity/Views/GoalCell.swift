//
//  GoalCell.swift
//  Protivity
//
//  Created by jack sanderson on 02/03/2019.
//  Copyright © 2019 jack sanderson. All rights reserved.
//

import UIKit

internal final class GoalCell: UITableViewCell, Cell {
    
   // @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cellDetail: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        cellDetail.text = nil
    }
}
