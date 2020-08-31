//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Abdulaziz Asiri on 6/2/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//


// We have two problems which is we get a portion of the images.
// Pins created in the beginning are not clieked.


import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController, UIPageViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var labelInfo: UILabel!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(" :  \( self.imagesURLs.count)")
        if imagesURLs.count >= 50 {
            manageState(trigger: false)
        }
        return self.imagesURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! CollectionViewCell
        
        if let image = self.imagesURLs[indexPath.row].storedImages  {
            cell.albumImage.image = UIImage(data: image)
        }
        
        
        return cell
        
    }
    
    
    
    
    @IBOutlet weak var imageCollections: UICollectionView!
    
    @IBOutlet weak var newCollectionBtn: UIButton!
    var tempTitle: String?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static var page: Int?
    static var pages: Int?
    
    @IBOutlet weak var tinyMap: MKMapView!
    var clickedImage: Data?
    var images: [ActualImages]?
    var imagesURLs: [Photo] = []
    var test: Bool?
    var stringUrls: [String] = []
    let dispatchGroup = DispatchGroup()
    var receivedPin: Pin? {
        didSet {
            loadData()
        }
    }// This is what me chose
    override func viewDidLoad() {
        super.viewDidLoad()
        manageState(trigger: true)
        
        addPininTinyMap()
        if self.imagesURLs.count == 0 {
            print("This is new")
            makeRequest()
        } else {
            print("This is old")
        }
    }
    
    
    func manageState(trigger: Bool) {
        self.newCollectionBtn.isHidden = trigger
        self.labelInfo.isHidden = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Alert View
        // Delete and show.
        print("Index: \(indexPath.row)")
        alertImage(index: indexPath.row)
        
        
    }
    func addPininTinyMap() {
        var camera = MKMapCamera()
        print("Selected Pin;  \(receivedPin!.latitude) and long  \(receivedPin!.longitude)")
        print("SELECTED Pins")
        camera.centerCoordinate = CLLocationCoordinate2D(latitude: receivedPin!.latitude, longitude: receivedPin!.longitude)
        camera.altitude = 300.0
        camera.pitch = 35.0
        tinyMap.mapType = .standard
        self.tinyMap.camera = camera
        
        var pinnedLocation = PinDataModelAnnoation(coordinate: CLLocationCoordinate2D(latitude: receivedPin!.latitude, longitude: receivedPin!.longitude))
        self.tinyMap.addAnnotation(pinnedLocation)
        
    }
    func makeRequest(page: Int = 1) {
        ImagesMetaData.latitude = String(receivedPin!.latitude)
        ImagesMetaData.longitude = String(receivedPin!.longitude)
        ImagesMetaData.perPage = String(50)

        ImagesMetaData.page = String(page)
  
        ImagesMetaData.requestData { (imagesData, error) in
            // This methods returms
            if error != nil {
                // Print error alerting the user
                DispatchQueue.main.async {
                    print("Error Occured: \(error?.localizedDescription)")
                    self.labelInfo.text = "Bad Url"
                }
                
                return
            }
            self.images = imagesData?.photos.photo // Remember we
            self.assembleUrlsImages()
            
        }
        
    }
    
    func assembleUrlsImages() {
        if self.images?.count == 0 {
            DispatchQueue.main.async {
                self.imageCollections.isHidden = true
                self.labelInfo.isHidden = false
                self.labelInfo.text = "No Images Found"
            }
        }
        for i in self.images! {
            var str = "https://farm\(i.farm).staticflickr.com/\(i.server)/\(i.id)_\(i.secret).jpg"
            self.stringUrls.append(str)
        }
        self.downloadImages()
        
        
    }
    func downloadImages() {
        print("Downloaded images \(self.stringUrls.count)")
        
        for url in  self.stringUrls {
            var photo = Photo(context:context)
            
            ImagesMetaData.downloadPhoto(urls: url) { (imagesData, errors) in
                if errors != nil {
                    print("Sometthing went wrong")
                    return
                }
                photo.storedImages = imagesData
                
                print("Size of Photo:   \(self.imagesURLs.count)")
                
                photo.parentPin = self.receivedPin
                print("Parent Was caught: \(photo.parentPin)")
                print("Self Was caught: \(self.receivedPin)")
                
                self.imagesURLs.append(photo)
                 self.updateUI()
                if url == self.stringUrls[self.stringUrls.count - 1] {
                    print("Save it")
                   
                    self.saveData()

                }
                
            }

        } // End of loop
        
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.imageCollections.delegate = self
            self.imageCollections.dataSource = self
            self.imageCollections.reloadData()
        }
    }
    
    func saveData(){
        do {
            print("Saved First")
            try self.context.save()
        } catch {
            print("Some Errror has Occured:   \(error.localizedDescription)")
        }
    }
    
    
    func loadData(){
        print("Load data was called")
        
        
        let request: NSFetchRequest<Photo> = Photo.fetchRequest()
        guard let pin = self.receivedPin else {
            return
        }
        let firstPredicate = NSPredicate(format: "parentPin == %@", pin)
        
        
        //        print("Predicate: \(receivedPin!.longitude)")
        request.predicate = firstPredicate
        //        request.predicate = seconPredicate
        do {
            self.imagesURLs =  try self.context.fetch(request)
            print("Are they saved:  \(self.imagesURLs.count)")
            
            self.updateUI()
            
        } catch {
            print("Error Occured while loading up the data. \(error.localizedDescription)")
        }
        
    }
    func alertImage(index: Int){
        let alertController = UIAlertController(title: "What do you like to do", message: "", preferredStyle: .alert)
        
        self.clickedImage = self.imagesURLs[index].storedImages
        
        print("Title:  \(tempTitle)")
        let viewAction = UIAlertAction(title: "View Profile", style: .default) { (UIAlertAction) in
            
            self.performSegue(withIdentifier: "viewerSegue", sender: self)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (UIAlertAction) in
            
            
            self.context.delete(self.imagesURLs[index])
            self.imagesURLs.remove(at: index)
            self.saveData()
            self.imageCollections.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (UIAlertAction) in
            // Delete image and request another one
            self.dismiss(animated: true, completion: nil)
        }
        
        
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        alertController.addAction(viewAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let secondVC = segue.destination as! DisplayImageViewController
        
        secondVC.imageData = self.clickedImage
    }
    
    @IBAction func loadAnotherSet(_ sender: Any) {
        print("Photo view Cont Page:  \(PhotoAlbumViewController.page)")
              print("Photo view Cont Pages:  \(PhotoAlbumViewController.pages)")

        print("Size of URLS  \(imagesURLs.count)")
      var temp = self.imagesURLs
        for (n,p) in imagesURLs.enumerated() {
            context.delete(self.imagesURLs[n])
      
//            print("N is: \(n)")
          

           
        }

        self.imagesURLs = []
        saveData()
        PhotoAlbumViewController.page! += 1
        
        makeRequest(page:   PhotoAlbumViewController.page!)
        
        print("Photo view Cont Page:  \(PhotoAlbumViewController.page)")
        print("Photo view Cont Pages:  \(PhotoAlbumViewController.pages)")

    }
}

