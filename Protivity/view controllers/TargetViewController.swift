//
//  TargetViewController.swift
//  Protivity
//
//  Created by jack sanderson on 27/02/2019.
//  Copyright © 2019 jack sanderson. All rights reserved.
//

import UIKit

class TargetViewController: UITableViewController {

    @IBOutlet weak var isComplete: UISwitch!
    @IBOutlet weak var goalTitle: UITextField!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var goalTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIView()
    }
    
}

extension TargetViewController{
    func setupUIView(){
        setSaveButton()
        saveButton.isEnabled = false
        
    }
 
}

