//
//  DetailsViewController.swift
//  Shopping List
//
//  Created by Berkay Kargılı on 26.02.2023.
//

import UIKit
import CoreData


class DetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    
    var selectedProductName = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedProductName != "" {
            // core data show selected product information
            
        
        } else {
            nameTextField.text = ""
            priceTextField.text = ""
            sizeTextField.text = ""
        }
        
        let gestureRecognizer = UIGestureRecognizer(target: self, action: #selector(keyboardClose))
        view.addGestureRecognizer(gestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        
        imageView.addGestureRecognizer(imageGestureRecognizer)
        
                                                            
    }

    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    
    @objc func keyboardClose() {
        view.endEditing(true)
    }
    
    @IBAction func selectSaveTapped(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let alisveris = NSEntityDescription.insertNewObject(forEntityName: "Shopping", into: context)
        
        alisveris.setValue(nameTextField.text!, forKey: "name")
        alisveris.setValue(sizeTextField.text!, forKey: "size")
        
        if let price = Int(priceTextField.text!) {
            alisveris.setValue(price, forKey: "price")
        }
        
        alisveris.setValue(UUID(), forKey: "id")
        
        let data = imageView.image?.jpegData(compressionQuality: 0.5)
        
        alisveris.setValue(data, forKey: "image")
        
        do {
            try context.save()
            print("KAYIT EDİLDİ")
        } catch {
            print("HATA")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataEntered"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    

}
