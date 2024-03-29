//
//  MealViewController.swift
//  TutorialFoodTracker
//
//  Created by Yang Lu on 2019-06-20.
//  Copyright © 2019 IdiotLeon. All rights reserved.
//

import os.log
import UIKit

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Mark: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender)`,
     or constructed as part of adding a new meal
     */
    var meal:Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to handle the text field's user input through delegate callbacks
        nameTextField.delegate = self
        
        // to enable the save button only if the text field has a valid meal name
        updateSaveButtonState()
    }
    
    // Mark: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // To hide the keyboard
        nameTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // to disable the save button while editing
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    // Mark: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // to dismiss the picker if the user canceled
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // the info dictionary may contain multiple representations of the image. to use the original
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // to set photoImageView to display the selected image
        photoImageView.image = selectedImage
        
        // to dismiss the picker
        dismiss(animated: true, completion: nil)
    }

    // Mark: Actions
    @IBAction func selectimageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // to hide the keyboard
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        // to allow photos only to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        
        // to make sure ViewController is notified when the user picks up an image
        imagePickerController.delegate = self
        present(imagePickerController, animated:true, completion:nil)
    }
    
    // Mark: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // to configure a view controller before it's presented
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        super.prepare(for: segue, sender: sender)
        
        // to configure the destination view controller only when the save button is pressed
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            os_log("The save button was not pressed, cancelling", log:OSLog.default, type:.debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        // to set the meal to be passed to MealTableViewController after the unwind segue
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    // Mark: Private Methods
    private func updateSaveButtonState(){
        // to disable the save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

