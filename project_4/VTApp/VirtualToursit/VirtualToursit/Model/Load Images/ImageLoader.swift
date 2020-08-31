//
//  ImageLoader.swift
//  VirtualToursit
//
//  Created by Abdulaziz Asiri on 5/23/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import Foundation


class ImageLoader {
    static var imageData:[Data] = []
    
    
    class func loadImages (images: [String], completion: @escaping (Data?,Error? ) -> Void ) {
        for image in images {
            let url = URL(string: image)
                let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                    
                    guard let data = data else {
                       completion(nil, error)
                        return
                    }
                    print("DData:  \(data)")
                    ImageLoader.imageData.append(data)
                
                    completion(data, nil)

                }
            

          
                task.resume()
            }
            

         

        
}
}
