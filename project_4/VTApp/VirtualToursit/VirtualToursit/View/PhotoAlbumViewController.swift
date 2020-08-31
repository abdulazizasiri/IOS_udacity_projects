//
//  PhotoAlbumViewController.swift
//  VirtualToursit
//
//  Created by Abdulaziz Asiri on 5/23/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var collectionViews: UICollectionView!
    
    @IBOutlet weak var imageLoaderr: UIButton!
    var selectedPin : Pin? {
        
        didSet {
            print("SELECTED PIN WAS SELECED \(selectedPin)")
            loadData()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var actualImages: [ActualImages]?
    
    var stringUrls: [String] = []
    var imagesURLs: [Photo] = [] // This is from the Daa model.
    var images: Photo?
//    var urlData: [Data?] = []
    
    var tempImage: Data?
    var tempTitle: String?
    
    @IBOutlet weak var tinyMap: MKMapView!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("The size of the image urls: \(self.imagesURLs.count)")
        return self.imagesURLs.count // photos count per pin  // self.imagesURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! CollectionViewCell
        
        
        cell.imageCell.image  = UIImage(data: imagesURLs[indexPath.row].images!) // So great
        
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        addPininTinyMap()
        
        
        guard let actualImages = self.actualImages else {
            print("This os not goggna work")
            return
        }
        for i in actualImages {
            var str = "https://farm\(i.farm).staticflickr.com/\(i.server)/\(i.id)_\(i.secret).jpg"
            stringUrls.append(str)
        }
        

        printURL() // this should not be here
        
        
    }
    
    
    func addPininTinyMap() {
        var camera = MKMapCamera()
        print("Selected Pin;  \(selectedPin!.lat) and long  \(selectedPin!.long)")
        print("SELECTED Pins")
        camera.centerCoordinate = CLLocationCoordinate2D(latitude: selectedPin!.lat, longitude: selectedPin!.long)
        camera.altitude = 500.0
        camera.pitch = 35.0
        self.tinyMap.camera = camera
        var pinnedLocation = PinDataModelAnnoation(coordinate: CLLocationCoordinate2D(latitude: selectedPin!.lat, longitude: selectedPin!.long))
        self.tinyMap.addAnnotation(pinnedLocation)
        tinyMap.reloadInputViews()
    }
    
    
    
    
    func triggerCollection() {
        DispatchQueue.main.async {
            self.collectionViews.delegate = self
            self.collectionViews.dataSource = self
            self.collectionViews.reloadData()
          
        }

        print("This is me saving your ass")
         self.savedData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        alertImage(index: indexPath.row)
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondVC = segue.destination as! ImageViewerViewController
        
        
        guard let imageData = self.tempImage else {
            return
        }
        // secondVC.image.image = UIImage(data: self.tempImage!)
        guard let title = self.tempTitle else {
            print("No images found")
            return
        }
        
        secondVC.imageData = imageData
        secondVC.textTitle  = title
    }
    
    func alertImage(index: Int){
        let alertController = UIAlertController(title: "What do you like to do", message: "", preferredStyle: .alert)
        
        self.tempTitle = self.actualImages![index].title
        
        let viewAction = UIAlertAction(title: "View Profile", style: .default) { (UIAlertAction) in
            
            self.performSegue(withIdentifier: "viewerSegue", sender: self)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (UIAlertAction) in
            
            // We probabily need to do more than that.
            
            //            self.urlData.remove(at: index)
            self.collectionViews.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (UIAlertAction) in
            // Delete image and request another one
        }
        
        
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        alertController.addAction(viewAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        
        present(alertController, animated: true, completion: nil)
    }
    func printURL(){
        
        self.images = Photo(context: self.context)

        ImageLoader.loadImages(images: self.stringUrls) { (urls, error) in
            if error != nil {
                print("Error OCcured")
                return
            } else {
                
                self.images!.images = urls
              
                print("Image urls: \(   self.images!.images)")
                self.imagesURLs.append(self.images!)

        

                   
                print("What is that \(urls)")
//                self.urlData = urls
                
//                print("The URL :  \(urls!)")
//                images.images = urls!
//                self.imagesURLs.append(images)
//                 self.triggerCollection()
                
                   self.savedData()
            }
            
            print("I am Not being Called \(self.imagesURLs.count)")
           
         

            print("the size \(self.imagesURLs.count)")
            
            
        }
        
           self.images!.parentCategory = self.selectedPin
//
    }
    
    
    func savedData () {
        
        do {
            print("We saved data")
            
            try self.context.save()
        } catch {
            print("Some Errror has Occured:   \(error.localizedDescription)")
        }
    }
    
    
    
    func loadData(){
        print("Load data was called")
        let request: NSFetchRequest<Photo> = Photo.fetchRequest()
        
    
        
        do {
            imagesURLs =  try self.context.fetch(request)
            print("Are they saved:  \(self.imagesURLs.count)")
        } catch {
            print("Error Occured while loading up the data. \(error.localizedDescription)")
            
        }
        requestImages()
        
        return 
    }
    
    
    func requestImages() {
//        triggerCollection()
        
        DispatchQueue.main.async {
                
                self.collectionViews.delegate = self
                self.collectionViews.dataSource = self
                self.collectionViews.reloadData()

            }
        
        return
    }
    
}
