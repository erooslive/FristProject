//
//  ViewController.swift
//  FilesFirebase
//
//  Created by Fernanda Hernandez on 16/03/21.
//

import UIKit
import Firebase
import CoreServices
import FirebaseUI

class ViewController: UIViewController{
    
    @IBOutlet var coleccion: UICollectionView!
    
    var images: [StorageReference] = []
    var nombreUrl:[String] = []

    let placeholderImage = UIImage(named:"placeholder")
    let storage = Storage.storage()
    let refreshControl = UIRefreshControl()
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)

        let nib = UINib.init(nibName: "ImageCollectionViewCell", bundle: nil)
        coleccion.register(nib, forCellWithReuseIdentifier: "imageCellXIB")
        
        let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        
        if #available(iOS 10.0, *) {
            coleccion.refreshControl = refreshControl
        } else {
            coleccion.addSubview(refreshControl)
        }
        download()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue"{
            let destinationView = segue.destination as! DetailViewController
            
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        coleccion.reloadData()
        refreshControl.endRefreshing()
        download()
    }
    
    @IBAction func newUpload(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let detailViewController = (mainStoryBoard.instantiateViewController(withIdentifier: "DownloadViewController")as? DownloadViewController)!
    }
    
    func download(){
        let imagesRef = storage.reference().child("images/profile")
        imagesRef.listAll{ (result, error) -> Void in
            if (self.images.count == 0){
                for image in result.items{
                    self.images.append(image)
                    self.nombreUrl.append(image.fullPath)
                }
                self.coleccion.reloadData()
                self.refreshControl.endRefreshing()
            }
            else{
                self.images.removeAll()
                self.nombreUrl.removeAll()
                for image in result.items{
                    self.images.append(image)
                    self.nombreUrl.append(image.fullPath)
                }
                self.coleccion.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
}


extension ViewController: UINavigationControllerDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let detailViewController = (mainStoryBoard.instantiateViewController(withIdentifier: "DetailViewController")as? DetailViewController)!
            detailViewController.myString = nombreUrl[indexPath.row]
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}


extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCellXIB", for: indexPath) as! ImageCollectionViewCell
        let ref = images[indexPath.item]
        cell.imageViewCell.sd_setImage(with: ref, placeholderImage: placeholderImage)
    
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberForItemPerRow: CGFloat = 3
        let lineSpacing: CGFloat = 5
        let interlineSpacing: CGFloat = 5
        
        let width = (coleccion.frame.width - numberForItemPerRow * interlineSpacing) / numberForItemPerRow
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let lineSpacing: CGFloat = 5
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let interlineSpacing: CGFloat = 5
        
        return interlineSpacing
    }
}

