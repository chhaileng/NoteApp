//
//  ViewController.swift
//  NoteApp
//
//  Created by Chhaileng Peng on 12/18/17.
//  Copyright © 2017 Chhaileng Peng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var microphoneButton: UIBarButtonItem!
    @IBOutlet weak var penButton: UIBarButtonItem!
    @IBOutlet weak var listButton: UIBarButtonItem!
    @IBOutlet weak var takeNoteButton: UIBarButtonItem!
    
    @IBOutlet weak var noteCollectionView: UICollectionView!

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var notes:[Note]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customCellStyle()
        newNoteButton()
        
        self.noteCollectionView.delegate = self
        self.noteCollectionView.dataSource = self
        
        let holdToDelete : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        holdToDelete.minimumPressDuration = 0.5
        holdToDelete.delegate = self
        holdToDelete.delaysTouchesBegan = true
        self.noteCollectionView?.addGestureRecognizer(holdToDelete)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        self.noteCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteCell", for: indexPath) as! NoteCell
        
        cell.titleLabel.text = notes?[indexPath.row].title
        cell.noteLabel.text = notes?[indexPath.row].note
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let edit = self.storyboard?.instantiateViewController(withIdentifier: "editStoryboard") as! EditViewController
        edit.noteTitle = notes?[indexPath.row].title
        edit.noteBody = notes?[indexPath.row].note
        edit.noteIndex = indexPath.row
        edit.isUpdate = true
        
        self.navigationController?.pushViewController(edit, animated: true)
    }
    
    func newNoteButton() {
        cameraButton.action = #selector(addNewNote)
        microphoneButton.action = #selector(addNewNote)
        penButton.action = #selector(addNewNote)
        listButton.action = #selector(addNewNote)
        takeNoteButton.action = #selector(addNewNote)
    }
    
    @objc func addNewNote() {
        performSegue(withIdentifier: "showEdit", sender: nil)
    }
    
    func customCellStyle() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        let layout = self.noteCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: (self.view.frame.size.width - 26)/2, height: (self.view.frame.size.height/5))
    }
    
    func getData() {
        self.notes = try? context.fetch(Note.fetchRequest())
    }
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }
        
        let p = gesture.location(in: self.noteCollectionView)
        
        if let indexPath = self.noteCollectionView.indexPathForItem(at: p) {
//            let cell = self.noteCollectionView.cellForItem(at: indexPath) as! NoteCell
            let alert = UIAlertController(title: "Are you sure to delete this note?", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {action in
                let note = self.notes?[indexPath.row]
                self.context.delete(note!)
                self.appDelegate.saveContext()
                self.getData()
                self.noteCollectionView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true)
        } else {
            print("couldn't find index path")
        }
    }

}

