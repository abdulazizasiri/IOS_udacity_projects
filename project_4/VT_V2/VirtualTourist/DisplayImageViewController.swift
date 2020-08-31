//
//  DisplayImageViewController.swift
//  VirtualTourist
//
//  Created by Abdulaziz Asiri on 6/11/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import UIKit

class DisplayImageViewController: UIViewController {
    @IBOutlet weak var clickedImage: UIImageView!
    

    var imageData: Data?

    override func viewDidLoad() {
        super.viewDidLoad()


        clickedImage.image = UIImage(data: imageData!)
        
        // Do any additional setup after loading the view.
    }
    



}
