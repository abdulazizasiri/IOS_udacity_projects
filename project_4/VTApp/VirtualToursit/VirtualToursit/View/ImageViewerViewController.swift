//
//  ImageViewerViewController.swift
//  VirtualToursit
//
//  Created by Abdulaziz Asiri on 5/24/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import UIKit

class ImageViewerViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var imageTitle: UILabel!
    

    
    var textTitle: String?
    var imageData: Data?
    
 
    
    func configure(label: UILabel) {
      
        label.attributedText = NSAttributedString(
        string: label.text!,
        attributes: [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeWidth: -3.0,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!
        ]
        )
         
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageTitle.text = "Title:  \(textTitle!)"
        self.image.image = UIImage(data: imageData!)

        configure(label: imageTitle!)
        
        
    }
    

 

}
