//
//  GoalsTableViewController.swift
//  Protivity
//
//  Created by jack sanderson on 14/02/2019.
//  Copyright © 2019 jack sanderson. All rights reserved.
//

import UIKit

class GoalsTableViewController: UITableViewController {
    
    var goals = [Goal]()
    var dataController: DataController!
    
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = editButtonItem
        super.viewDidLoad()
        if let savedGoals = Goal.loadGoals(){
            goals = savedGoals
        }else{
            goals = Goal.loadSampleGoals()
        }
    }
    
    @IBAction func unwindToGoalsList(segue: UIStoryboardSegue){
        
    }
    
    func loadQuote(){
        let QuoteClient = QuotClient.currentSession()
        QuoteClient.getRandomQuote() { success, quote, error in
            if success == false {
                QuoteClient.displayError(error!, self)
            }
            
            print(quote)
            //TODO: Print  a random quote to the dispaly 
        }
        
    }
}

extension GoalsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCellIdentifier", for: indexPath)
        let todo = goals[indexPath.row]
        cell.textLabel?.text = todo.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt
        indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit
        editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:
        IndexPath) {
        if editingStyle == .delete {
            goals.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
