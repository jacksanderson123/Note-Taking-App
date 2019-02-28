//
//  SaveGoalsViewController.swift
//  Protivity
//
//  Created by jack sanderson on 28/02/2019.
//  Copyright © 2019 jack sanderson. All rights reserved.
//


//
import UIKit

class SaveGoalsViewController: UITableViewController {
    
    @IBOutlet weak var isComplete: UISwitch!
    @IBOutlet weak var goalTitle: UITextField!
    @IBOutlet weak var dateDisplayLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var goalNotes: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNewGoalView()
        // Do any additional setup after loading the view.
    }
//    @IBAction func clickedCancel(_ sender: Any) {
//      dismiss(animated: true, completion: nil)
//    }
    @IBAction func clickedSave(_ sender: Any) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        return
    }
   

}
extension SaveGoalsViewController{
    func setNewGoalView(){
        updateSaveButtonState()
    }
    func updateSaveButtonState() {
        let title = goalTitle.text ?? ""
        saveButton.isEnabled = !title.isEmpty
    }
}
