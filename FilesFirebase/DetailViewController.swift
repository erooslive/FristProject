//
//  DetailViewController.swift
//  FilesFirebase
//
//  Created by Fernanda Hernandez on 01/04/21.
//
import UIKit
import Firebase
import CoreServices
import FirebaseUI

class DetailViewController: UIViewController {

    var myString: String?
    @IBOutlet weak var destino: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageDetail: UIImageView!
    
    let placeholderImage = UIImage(named:"placeholder")
    let storage = Storage.storage()
    let navigation = UINavigationController()
    
    var fecha: String = "none"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let string = myString{
            destino.text = string
        }
        let imagesRef = storage.reference().child(destino.text!)
        imageDetail.sd_setImage(with: imagesRef, placeholderImage: placeholderImage)
        
        name.text = imagesRef.name
    }
    
    
    @IBAction func deleteImage(_ sender: Any) {

        showAlert(imagen: destino.text!)
        
    }
    func showAlert(imagen: String){
        let alert = UIAlertController(title: "Eliminar imagen", message: "¿Realmente deseas eliminar imagen?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: {_ in
            print("puchurraste cancelar")
        }))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive, handler: {_ in
            print("puchurraste Eliminar")
            let imagesDelete = self.storage.reference().child(imagen)
            imagesDelete.delete { error in
                if let error = error {
                  print("hubo un error")
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
              }
        }))
        
        present(alert, animated: true)
    }
    
}
