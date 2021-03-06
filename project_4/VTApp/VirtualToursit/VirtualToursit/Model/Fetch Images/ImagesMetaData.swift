//
//  ImagesMetaData.swift
//  VirtualToursit
//
//  Created by Abdulaziz Asiri on 5/23/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import Foundation

import MapKit

enum FlickerApiUrlComponents: String {
    case mainURL = "https://www.flickr.com/services/rest/"
    case method = "flickr.photos.search"
    case apiKey = "bedd3e27e6e5a39e4b95db8d78871c52"
    case accuracy = "3"
    case content_type = "1"
    case media = "photos"
    case format = "json"
}



class ImagesMetaData {
    static var imagesData: MainKeys?

    static var finalURL: URL?
    static var lat: String?
    static var lon: String?
    static var pPagd: String?
    
    static var latitude: String {
        set { lat = newValue}
        get {return lat!}
    }
    
    static var longitude: String {
        set { lon = newValue}
        get {return lon!}
    }
    
    static var perPage: String {
        set { pPagd = newValue}
        get {return pPagd!}
    }
    class func buildURL () {
        
        
        
        
        var url = URLComponents(string: FlickerApiUrlComponents.mainURL.rawValue)
        let queries = [
            URLQueryItem(name: "method", value: FlickerApiUrlComponents.method.rawValue),
            URLQueryItem(name: "api_key", value: FlickerApiUrlComponents.apiKey.rawValue),
            URLQueryItem(name: "accuracy", value: FlickerApiUrlComponents.accuracy.rawValue),
            URLQueryItem(name: "content_type", value: FlickerApiUrlComponents.content_type.rawValue),
            URLQueryItem(name: "media", value: FlickerApiUrlComponents.media.rawValue),
            URLQueryItem(name: "lat", value: lat),
            URLQueryItem(name: "lon", value: lon),
            URLQueryItem(name: "per_page", value: perPage),
            URLQueryItem(name: "format", value: FlickerApiUrlComponents.format.rawValue),
            URLQueryItem(name: "nojsoncallback", value: "1")
            
        ]
        
        
        url?.queryItems = queries
        
        print("URL BECOMES:   \(url!)")
        finalURL = url?.url

        
        
    }
    
    class func requestData (completionHandler: @escaping (MainKeys?, Error?) -> Void) {
        buildURL()
        guard let url = finalURL else {
            return
        }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                
               completionHandler(nil, error)
                return
                
            }
            let decoder = JSONDecoder()
            
            do {
                ImagesMetaData.imagesData = try decoder.decode(MainKeys.self, from: data!)
                
                guard let allImages = ImagesMetaData.imagesData else {
                    return
                }
                completionHandler(allImages, nil)
                print("SIZE WAS FOUND IS    :\(allImages.photos.photo.count)")
                
            } catch {
                
                completionHandler(nil, error)
                
                
            }
            
        }
        task.resume()
        
        
    }
    
    
    
    
    
    
    
}
