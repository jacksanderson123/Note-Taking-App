//
//  SaveGoalsViewController.swift
//  Protivity
//
//  Created by jack sanderson on 28/02/2019.
//  Copyright © 2019 jack sanderson. All rights reserved.
//


//
import UIKit
import CoreData

class SaveGoalsViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate{
    
    //Remove this in future
    @IBOutlet weak var isComplete: UISwitch!
    @IBOutlet var goalTitle: UITextField!
    @IBOutlet weak var dateDisplayLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var goalNotes: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController
        setNewGoalView()
    }
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedSave(_ sender: Any) {
        addGoal()
        self.dismiss(animated: true)
    }
    @IBAction func goalTitleEditingChanged(_ sender: Any) {
        updateSaveButton()
    }
    @IBAction func datePickerHasChanged(_ sender: UIDatePicker) {
        setDueDateLabel()
    }
    
    func addGoal() {
        let goal = Goal(context: dataController.viewContext)
        goal.title = goalTitle.text
        goal.dateCreated = Date()
        goal.deadline = datePicker.date
        goal.isComplete = isComplete.isOn ? true : false
        goal.notes = goalNotes.text
        
        do {

            try dataController.viewContext.save()
        } catch {
            print("Failed saving")
        }
        
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        return
    }

}
extension SaveGoalsViewController{
    func setNewGoalView(){
        self.goalTitle.delegate = self
        datePicker.date = Date().addingTimeInterval(7*24*60*60) //1 Weeks Time
        updateSaveButton()
        setDueDateLabel()
    }
    func setDueDateLabel(){
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .short
        dateFormat.timeStyle = .short
        dateDisplayLabel.text = dateFormat.string(from: datePicker.date)
    }
    func updateSaveButton() {
        guard  let text = self.goalTitle.text else { return }
        
        saveButton.isEnabled = !text.isEmpty

 
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
