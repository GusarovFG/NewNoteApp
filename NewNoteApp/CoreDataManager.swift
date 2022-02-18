//
//  CoreDataManager.swift
//  NewNoteApp
//
//  Created by Фаддей Гусаров on 17.02.2022.
//

import CoreData
import Foundation
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init(){}
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "NewNoteApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchNote() -> [Note] {
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        
        let notes = (try? self.persistentContainer.viewContext.fetch(fetchRequest)) ?? []
        
        return notes
    }

    func saveNote(text: String, photo: UIImage) {
        
        let note = Note(context: self.persistentContainer.viewContext)
        
        let imageData = UIImage.pngData(photo)
        
        note.text = text
        note.image = imageData()
        
        saveContext()
    }
    
    func deleteNote(index: Int) {
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        
        let notes = (try? self.persistentContainer.viewContext.fetch(fetchRequest)) ?? []
        
        self.persistentContainer.viewContext.delete(notes[index])
        saveContext()
    }
    
    func editNote(index: Int, note: Note) {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        
        var notes = (try? self.persistentContainer.viewContext.fetch(fetchRequest)) ?? []
        notes[index] = note
        saveContext()
        
    }
}
