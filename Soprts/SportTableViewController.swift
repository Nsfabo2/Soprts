//
//  SportTableViewController.swift
//  Soprts
//
//  Created by Najla on 16/01/2022.
//

import UIKit

class SportTableViewController: UITableViewController, ImageDelegate {
    
    //attrbuites
    var selectedCell: IndexPath?
    var SportList: [Sport] = []
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func save(){
        do{
            try managedObjectContext.save()
            
        }catch{
            print(error)
        }
        fetchData()
    }
    
    func fetchData(){
        do{
            SportList = try managedObjectContext.fetch(Sport.fetchRequest())
            tableView.reloadData()
        }catch{
            print(error)
        }
    }
    //add
    @IBAction func AddBarButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Sport", message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        let add = UIAlertAction(title: "Add", style: .default){
            _ in
            let sportName = alert.textFields![0]
            if sportName.text != ""{
                let newSport = Sport(context: self.managedObjectContext)
                newSport.name = sportName.text
                self.save()
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(add)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    

    //update
    func updateSportName(indexPath: IndexPath){
        let sport = SportList[indexPath.row]
        let alert = UIAlertController(title: "Edit Sport Name", message: nil, preferredStyle: .alert)
        alert.addTextField(){ (textField : UITextField) -> Void in
            textField.text = sport.name
        }
        
        let save = UIAlertAction(title: "Save", style: .default){
            _ in
            let txt = alert.textFields![0]
            if txt.text != ""{
                sport.name = txt.text
                self.save()
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(save)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //image
    func pickImage(indexPath: IndexPath) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        selectedCell = indexPath
        present(vc, animated: true )
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return SportList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return SportList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToPlayer", sender: SportList[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "SportCell", for: indexPath) as! SportTableViewCell
        
        cell.SportName.text = SportList[indexPath.row].name ?? ""
        if let img = SportList[indexPath.row].image{
            print(";;;;;;")
            cell.AddImage.isHidden = true
            cell.SportImagePicker.isHidden = false
            cell.SportImagePicker.image = UIImage(data: img)
        }
        else{
            cell.SportImagePicker.isHidden = true
        }
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        managedObjectContext.delete(SportList[indexPath.row])
        fetchData()
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        updateSportName(indexPath: indexPath)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PlayerTableViewController
        destination.sport = sender as? Sport
        
    }

}//end calss
extension SportTableViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let cell:SportTableViewCell = tableView.cellForRow(at: IndexPath(row: selectedCell!.row, section: 0)) as! SportTableViewCell
            cell.SportImagePicker.image = image
            cell.AddImage.isHidden = true
            cell.SportImagePicker.isHidden = false
            let sport = self.SportList[selectedCell!.row]
            sport.image = image.pngData()
            self.save()
        }

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
