//
//  DownloadViewController.swift
//  FilesFirebase
//
//  Created by Fernanda Hernandez on 12/04/21.
//

import UIKit
import Firebase
import CoreServices
import FirebaseUI

class DownloadViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var subirImagen: UIImageView!
    @IBOutlet weak var imageName: UITextField!
    
    let placeholderImage = UIImage(named:"placeholder")
    let storage = Storage.storage()
    
    var guardar = Data()
    var flag: Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func picker(_ sender: Any) {
        let userImagePicker = UIImagePickerController()
        userImagePicker.delegate = self
        userImagePicker.allowsEditing = true
        userImagePicker.sourceType = .photoLibrary
        userImagePicker.mediaTypes = ["public.image"]
        present(userImagePicker, animated: true, completion: nil)
    }
    
    @IBAction func upload(_ sender: Any) {
        if(flag != 0 && imageName.text != ""){
            uploadImage(imageData: guardar, nombre: imageName.text ?? "unknow")
            
        }
        else{
            showAlert()
            
        }
    }
    func uploadImage(imageData: Data, nombre: String){
        let activityIndicator = UIActivityIndicatorView.init(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
        let storageRef = storage.reference()
        let imageRef = storageRef.child("images").child("profile").child("\(nombre).jpg")
        
        print("pollo \(imageRef)")
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        imageRef.putData(imageData, metadata: uploadMetaData) { (metadata, error) in
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            if let error = error{
                print(error.localizedDescription)
            } else {
                print("Image metadata: \(String(describing: metadata))")
                self.navigationController?.popViewController(animated: true)
                
            }
        }
      
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "", message: "Favor de seleccionar una imagen y establecer nombre de imagen", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: {_ in
            print("puchurraste cancelar")
        }))
        present(alert, animated: true)
    }

}
extension DownloadViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let userImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let optimizedImageData = userImage.jpegData(compressionQuality: 0.6){
            guardar = optimizedImageData
            subirImagen.image = userImage
            flag = 1
        }
        picker.dismiss(animated: true, completion: nil)
        flag = 1
    }
}
