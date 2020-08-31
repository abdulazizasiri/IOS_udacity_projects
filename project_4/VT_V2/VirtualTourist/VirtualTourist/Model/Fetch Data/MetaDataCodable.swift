
import Foundation

struct MainKeys: Codable {
    var photos: Metadata
    var stat: String
}

struct Metadata : Codable{
    var page : Int
    var pages: Int
    var perpage:  Int
    var total : String
    var photo: [ActualImages]
}

struct ActualImages: Codable {
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
    var ispublic: Int
    var isfriend: Int
    var isfamily: Int
}



