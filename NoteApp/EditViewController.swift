//
//  EditViewController.swift
//  NoteApp
//
//  Created by Chhaileng Peng on 12/20/17.
//  Copyright © 2017 Chhaileng Peng. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITextViewDelegate {
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var notes:[Note]?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    var noteTitle: String?
    var noteBody: String?
    var isUpdate: Bool = false
    var noteIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.delegate = self
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.572, green: 0.572, blue: 0.572, alpha: 1.0)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backItem?.title = ""
        
        if isUpdate {
            titleTextField.text = noteTitle
            noteTextView.text = noteBody
        }
        
        if noteTextView.text != "Note" {
            noteTextView.textColor = UIColor.black
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isUpdate {
            notes = try? context.fetch(Note.fetchRequest())
            notes![noteIndex!].title = titleTextField.text
            notes![noteIndex!].note = noteTextView.text
            appDelegate.saveContext()
        } else {
            let note = Note(context: context)
            note.title = self.titleTextField.text
            note.note = self.noteTextView.text
            appDelegate.saveContext()
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "Note" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        return true
    }

    @IBAction func plusButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take photo", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Choose image", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Drawing", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Recording", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Checkboxs", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @IBAction func moreButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Make a copy", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Collabrators", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Labels", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
