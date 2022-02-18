//
//  MainTableViewController.swift
//  NewNoteApp
//
//  Created by Фаддей Гусаров on 17.02.2022.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var notes: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Notes"
        self.tableView.rowHeight = 60
        self.notes = CoreDataManager.shared.fetchNote()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        let note = self.notes[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = note.text
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DispatchQueue.global(qos: .utility).async {
                CoreDataManager.shared.deleteNote(index: indexPath.row)
                DispatchQueue.main.async {
                    self.notes.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            let editVC = segue.destination as! NewNoteViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            editVC.note = notes[indexPath?.row ?? 0]
        }
    }
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveSegue" else { return }
        let newNoteVC = segue.source as! NewNoteViewController
        
        if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
            newNoteVC.index = selectedIndexPath.row
            newNoteVC.editNote()
            self.tableView.reloadRows(at: [selectedIndexPath], with: .fade)
            
            
        } else {
            newNoteVC.saveNote()
            self.notes = CoreDataManager.shared.fetchNote()
            let indexPath = IndexPath(row: self.notes.count - 1, section: 0)
            self.tableView.insertRows(at: [indexPath] , with: .fade)
            
        }
        
    }
}
