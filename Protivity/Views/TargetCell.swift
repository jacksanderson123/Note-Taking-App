//
//  TargetCell.swift
//  Protivity
//
//  Created by jack sanderson on 03/03/2019.
//  Copyright © 2019 jack sanderson. All rights reserved.
//

import UIKit

internal final class TargetCell: UITableViewCell, Cell {

    @IBOutlet weak var targetName: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        targetName.text = nil
    }
}
