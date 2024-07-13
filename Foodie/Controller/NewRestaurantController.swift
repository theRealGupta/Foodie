//
//  NewRestaurantController.swift
//  Foodie
//
//  Created by Mahmoud Alaa on 13/07/2024.
//

import UIKit

class NewRestaurantController: UITableViewController {

    @IBOutlet weak var photoImageView: UIImageView!{
        didSet{
            photoImageView.layer.cornerRadius = 10
            photoImageView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var nameTextField: RoundedTextField!{
        didSet{
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
        }
    }
    
    
    
    @IBOutlet weak var typeTextField: RoundedTextField!{
        didSet{
            typeTextField.tag = 2
            typeTextField.delegate = self
        }
    }
   
        
    @IBOutlet weak var addressTextField: RoundedTextField!{
        didSet{
            addressTextField.tag = 3
            addressTextField.delegate = self
        }
    }
    @IBOutlet weak var phoneTextField: RoundedTextField!{
        didSet{
            phoneTextField.tag = 4
            phoneTextField.delegate = self
        }
    }
    
    @IBOutlet weak var desriptionTextField: UITextView! {
        didSet{
            desriptionTextField.tag = 5
            desriptionTextField.layer.cornerRadius = 10
            desriptionTextField.layer.masksToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize navigationController
        if let apperance = navigationController?.navigationBar.standardAppearance{
            if  let customeFont = UIFont(name: "Nunito-Bold", size: 40){
                apperance.titleTextAttributes = [ .foregroundColor: UIColor(named: "NavigationBarTitle")! ]
                apperance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")! , .font: customeFont]
            }
            navigationController?.navigationBar.standardAppearance = apperance
            navigationController?.navigationBar.scrollEdgeAppearance = apperance
            navigationController?.navigationBar.compactAppearance = apperance
        }
      
        // layout
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        let margins = photoImageView.superview!.layoutMarginsGuide
        photoImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        photoImageView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        // Hide Keyboard
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func saveNewRestaurant(_ sender: UIBarButtonItem) {
        checkTextFieldValidate()
    }
    
    func checkTextFieldValidate(){
        if nameTextField.text == "" ||
           typeTextField.text == ""  ||
           addressTextField.text == "" ||
           phoneTextField.text == "" ||
           desriptionTextField.text == "" {
            let alert = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(alertAction)

            present(alert ,animated: true)
        }
    }
 
    //Selected Row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            
            let photoSource = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            
            let photoAction = UIAlertAction(title: "Photo library", style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.delegate = self
                    self.present(imagePicker ,animated: true)
                }
            }
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = .camera
                    imagePicker.allowsEditing = false
                    self.present(imagePicker ,animated: true)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            photoSource.addAction(photoAction)
            photoSource.addAction(cameraAction)
            photoSource.addAction(cancelAction)
           
            //for ipad
            if let popOver = photoSource.popoverPresentationController{
                if let cell = tableView.cellForRow(at: indexPath){
                    popOver.sourceView = cell
                    popOver.sourceRect = cell.bounds
                }
            }
            present(photoSource ,animated: true)
                
        }
    }

}

//MARK: - TextFieldDelegate

extension NewRestaurantController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1){
            nextTextField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        return true
    }
}

//MARK: - imagePackerDelegate

extension NewRestaurantController: UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        dismiss(animated: true)
    }
    
}
