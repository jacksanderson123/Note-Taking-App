//
//  GoalDetailsTableViewController.swift
//  Protivity
//
//  Created by jack sanderson on 28/02/2019.
//  Copyright © 2019 jack sanderson. All rights reserved.
//

import UIKit
import CoreData

class GoalDetailsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate{
   
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var goalTitle: UINavigationItem!
    var fetchedResultsController: NSFetchedResultsController<Target>!
    var goal: Goal!
    
    var dataController: DataController!
    //var fetchedResultsController: NSFetchedResultsController<Goal>!
    
    var quouteLoaded: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController
        setupFetchedResultsController()
        goalTitle.title = goal.title
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        goal = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTargetPressed(_ sender: Any) {
        presentAddNewTarget()
    }
    func presentAddNewTarget(){
        let alert = UIAlertController(title: "New Target", message: "Enter a target that will help you achive \(goal.title!)", preferredStyle: .alert)
    
        // Create actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            if let name = alert.textFields?.first?.text{
                self!.saveNewTarget(name: name)
            }
        }
        alert.addTextField { textField in
            textField.placeholder = "Provide target"
        }

        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
    func saveNewTarget(name: String){
        let target = Target(context: dataController.viewContext)
        target.title = name
        target.dateCreated = Date()
        do {
            try dataController.viewContext.save()
        } catch {
            print("Failed saving")
        }
    }
    fileprivate func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Target> = Target.fetchRequest()
      
        fetchRequest.sortDescriptors = []
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed")
        }
        fetchedResultsController.delegate = self
    }
    
    
    func deleteTarget(at indexPath: IndexPath) {
        let targetToDelete = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(targetToDelete)
        try? dataController.viewContext.save()
    }

}

extension GoalDetailsTableViewController {
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentTarget = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "TargetCellId", for: indexPath) as! TargetCell
        cell.targetName.text = currentTarget.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTarget(at: indexPath)
        }
    }

    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
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
