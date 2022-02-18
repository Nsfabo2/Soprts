//
//  PlayerTableViewController.swift
//  Soprts
//
//  Created by Najla on 16/01/2022.
//

import UIKit

class PlayerTableViewController: UITableViewController {
    
    var sport: Sport!
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func save(){
        do{
            try self.managedObjectContext.save()
            tableView.reloadData()
        }catch{
            print("Error: \(error)")
        }
    }
    
    @IBAction func AddPlayerButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Player", message: nil, preferredStyle: .alert)
        alert.addTextField(){ (textFielf: UITextField) -> Void in
            textFielf.placeholder = "Enter player name"
        }
        alert.addTextField(){ (textFielf: UITextField) -> Void in
            textFielf.placeholder = "Enter player age"
        }
        alert.addTextField(){ (textFielf: UITextField) -> Void in
            textFielf.placeholder = "Enter player height"
        }
        
        let rowIndex = self.sport.players?.count
        
        let add = UIAlertAction(title: "Add", style: .default){
            _ in
            let playerName = alert.textFields![0]
            let playerAge = alert.textFields![1]
            let playerHeight = alert.textFields![2]
            if let name = playerName.text, let age = playerAge.text , let height = playerHeight.text, name.isEmpty == false, age.isEmpty == false, height.isEmpty == false{
                let newPlayer = Player(context: self.managedObjectContext)
                newPlayer.name = name
                newPlayer.age = Int16(age)!
                newPlayer.height = Double(height)!
                self.sport.addToPlayers(newPlayer)
                self.save()
                let indexPath = IndexPath(row: rowIndex!, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(add)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sport.players?.count ?? 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! PlayerTableViewCell
        
        let player = sport.players![indexPath.row] as! Player
        
        cell.PlayerName.text = player.name
        cell.PlayerAge.text = "\(player.age)"
        cell.PlayerHighet.text = "\(player.height)"
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let player = sport.players![indexPath.row] as! Player
        sport.removeFromPlayers(player)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        save()
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit Player Information", message: nil, preferredStyle: .alert)
        let player = sport.players![indexPath.row] as! Player
        alert.addTextField(){ (textFielf: UITextField) -> Void in
            textFielf.text = player.name
        }
        alert.addTextField(){ (textFielf: UITextField) -> Void in
            textFielf.text = "\(player.age)"
        }
        alert.addTextField(){ (textFielf: UITextField) -> Void in
            textFielf.text = "\(player.height)"
        }
        
        
        let save = UIAlertAction(title: "Save", style: .default){
            _ in
            let playerName = alert.textFields![0]
            let playerAge = alert.textFields![1]
            let playerHeight = alert.textFields![2]
            if let name = playerName.text, let age = playerAge.text , let height = playerHeight.text, name.isEmpty == false, age.isEmpty == false, height.isEmpty == false{
                player.name = name
                player.age = Int16(age)!
                player.height = Double(height)!
                self.save()
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(save)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}
