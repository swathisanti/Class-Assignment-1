//
//  ViewController.swift
//  ToDO App
//
//  Created by MacStudent on 2017-07-11.
//  Copyright © 2017 BobtheDeveloper. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

  var tasks: [Task] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    getData()
    tableView.reloadData()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tasks.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    
    let task = tasks[indexPath.row]
    
    if let myName = task.name
    {
      cell.textLabel?.text = myName
    }
    
    return cell
   }

  func getData() {
    do {
      tasks = try context.fetch(Task.fetchRequest())
    }
    catch {
      print("Fetching Failed")
    }
  }
   var valueToPass:String!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        valueToPass = currentCell.textLabel?.text
        performSegue(withIdentifier: "myFirstSegue", sender:valueToPass)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "myFirstSegue" ,
            
            let nextScene = segue.destination as? AnotherViewController ,
            
            let _ = self.tableView.indexPathForSelectedRow
        {
            
            let selectedVehicle = valueToPass
            
            nextScene.passedValue = selectedVehicle
            
        }
        
    }
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
      let task = tasks[indexPath.row]
      context.delete(task)
      (UIApplication.shared.delegate as! AppDelegate).saveContext()
      
      do {
        tasks = try context.fetch(Task.fetchRequest())
      }
      catch {
        print("Fetching Failed")
      }
    }
    tableView.reloadData()
  }
}

