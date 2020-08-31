//
//  CollectionViewController.swift
//  MemeMeV2
//
//  Created by Abdulaziz Asiri on 4/30/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
       
    @IBOutlet weak var collection: UICollectionView!
    
    var tempImage: UIImage!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("What is it")
          return (UIApplication.shared.delegate as! AppDelegate).memeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionImageCell

        
        cell.imageCell?.image = (UIApplication.shared.delegate as! AppDelegate).memeData[indexPath.row].editedImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tempImage = (UIApplication.shared.delegate as! AppDelegate).memeData[indexPath.row].editedImage

         
        performSegue(withIdentifier: "detailedSegue", sender: self)
     
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if  segue.identifier == "detailedSegue" {
                    let newVC = segue.destination as! MeMeDetailsViewController
                    newVC.sentImage = tempImage
                }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collection.delegate = self
        collection.dataSource = self
        
        let itemSize = UIScreen.main.bounds.width/3 - 3
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 40,left: 0,bottom: 10,right: 0)
        layout.itemSize  = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        collection.collectionViewLayout = layout
    }
    
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(true)
          
//            collection.reloadData()
      }
    override func viewWillAppear(_ animated: Bool) {
          collection.reloadData()
    }
}
