//
//  MeMeDetailsViewController.swift
//  MemeMeV2
//
//  Created by Abdulaziz Asiri on 5/2/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import UIKit

class MeMeDetailsViewController: UIViewController {


    @IBOutlet weak var imageDetail: UIImageView!
    

    var sentImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

       
        // Do any additional setup after loading the view.
      
        
            imageDetail.image = sentImage
        
        
    }
    



}
