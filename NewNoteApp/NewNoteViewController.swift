//
//  NewNoteViewController.swift
//  NewNoteApp
//
//  Created by Фаддей Гусаров on 17.02.2022.
//

import UIKit

class NewNoteViewController: UIViewController {
    
    var note: Note?
    var index = 0
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var noteTextField: UITextView!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        self.photoImageView.image = UIImage(data: self.note?.image ?? Data())
        self.noteTextField.text = note?.text ?? ""
        
    }
    
    func saveNote() {
        CoreDataManager.shared.saveNote(text: self.noteTextField.text, photo: self.photoImageView.image ?? UIImage(systemName: "eye")!)
    }
    
    func editNote() {
        self.note?.text = self.noteTextField.text
        self.note?.image = UIImage.pngData(self.photoImageView.image ?? UIImage(systemName: "eye")!)()
        CoreDataManager.shared.editNote(index: self.index, note: self.note!)
    }
    
    private func setupUI(){
        self.shareButton.isEnabled = false
        self.photoImageView.layer.cornerRadius = 15
        self.optionsButton.setImage(UIImage(systemName: "plus.square"), for: .normal)
        self.optionsButton.layer.cornerRadius = self.optionsButton.frame.height/2
        self.optionView.layer.cornerRadius = 10
        self.optionView.alpha = 0
        self.optionView.isHidden = true
        self.optionView.frame.size.width = 20
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        self.noteTextField.inputAccessoryView = doneToolbar
    }
    
    @objc private func doneButtonAction()
    {
        self.noteTextField.resignFirstResponder()
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(sourse: .camera)
        }
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(sourse: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        
        self.shareButton.isEnabled = true
        let activityController = UIActivityViewController.init(activityItems: [self.noteTextField.text ?? "", self.photoImageView.image ?? UIImage()], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    
    @IBAction func optionButtonPressed(_ sender: Any) {
        
        if self.noteTextField.text.isEmpty == false {
            self.shareButton.isEnabled = true
        }
        if self.optionView.alpha == 0 {
            self.optionView.isHidden = false
            UIView.animate(withDuration: 1) {
                self.optionView.alpha = 1
                self.optionsButton.setImage(UIImage(systemName: "clear"), for: .normal)
            }
        } else {
            UIView.animate(withDuration: 1) {
                self.optionView.alpha = 0
                self.optionsButton.setImage(UIImage(systemName: "plus.square"), for: .normal)
            }
            self.optionView.isHidden = true
        }
    }
}

extension NewNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(sourse: UIImagePickerController.SourceType){
        
        if UIImagePickerController.isSourceTypeAvailable(sourse) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourse
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.photoImageView.image = info[.editedImage] as? UIImage
        self.photoImageView.contentMode = .scaleAspectFit
        self.photoImageView.clipsToBounds = true
        dismiss(animated: true, completion: nil)
        
    }
}

