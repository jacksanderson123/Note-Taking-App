//
//  GoalsTableViewController.swift
//  Protivity
//
//  Created by jack sanderson on 14/02/2019.
//  Copyright © 2019 jack sanderson. All rights reserved.
//

import UIKit

class GoalsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var inspirationalQuote: UILabel!
    
    var goals = [Goal]()
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadQuote()
        
    }
    
    @IBAction func unwindToGoalsList(segue: UIStoryboardSegue){
        
    }
    
    func loadQuote(){
        let QuoteClient = QuotClient.currentSession()
        QuoteClient.getRandomQuote() { success, quote, error in
            if !success{
                QuoteClient.displayError(error!, self)
            }
            DispatchQueue.main.async {
                self.inspirationalQuote.text = quote!
            }
        }
        
    }
}

extension GoalsTableViewController {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCellIdentifier", for: indexPath)
        let goal = goals[indexPath.row]
        cell.textLabel?.text = goal.title
        return cell
    }
    
     func tableView(_ tableView: UITableView, canEditRowAt
        indexPath: IndexPath) -> Bool {
        return true
    }
    
     func tableView(_ tableView: UITableView, commit
        editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:
        IndexPath) {
        if editingStyle == .delete {
            goals.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
