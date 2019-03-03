//
//  GoalsTableViewController.swift
//  Protivity
//
//  Created by jack sanderson on 14/02/2019.
//  Copyright © 2019 jack sanderson. All rights reserved.
//

import UIKit
import CoreData

class GoalsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var inspirationalQuote: UILabel!
    
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Goal>!
    
    var quouteLoaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        setupFetchedResultsController()
        loadQuote()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
        self.tableView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
        
    fileprivate func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        let sortDescription = NSSortDescriptor(key: "deadline", ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
  
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed")
        }
        fetchedResultsController.delegate = self
    }
    
    func loadQuote(){
        inspirationalQuote.isHidden = true
        activityIndicator.startAnimating()
        
        let QuoteClient = QuotClient.currentSession()
        QuoteClient.getRandomQuote() { success, quote, error in
        
            if !success{
               // self.inspirationalQuote.text = "It does not matter how slowly you go as long as you do not stop. – Confucius"
                QuoteClient.displayError(error!, self)
            }
    
            DispatchQueue.main.async {
                self.inspirationalQuote.text = quote
                self.activityIndicator.isHidden = true
                self.inspirationalQuote.isHidden = false
                self.quouteLoaded = true

            }
            
        }
        
    }
    
    func deleteGoal(at indexPath: IndexPath) {
        let goalToDelete = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(goalToDelete)
        try? dataController.viewContext.save()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navVC = segue.destination as? UINavigationController else{
            return
        }
        
        if let vc = navVC.viewControllers.first as? GoalDetailsTableViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.goal = fetchedResultsController.object(at: indexPath)
            }
        }else{
            print("wrong seuge")
        }
    }
    
}

extension GoalsTableViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentGoal = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCellIdentifier", for: indexPath) as! GoalCell
        cell.nameLabel.text = currentGoal.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteGoal(at: indexPath)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [indexPath!], with: .fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        default:
            break
        }
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
