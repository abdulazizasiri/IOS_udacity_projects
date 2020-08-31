### Pre


- Enum


- guard :  guard should be used to check for preconditions and early exit

if should be used to change execution path based on some condition(s)


- ُError: try? , try? vs try and as, as? and as!


- Generic


- Closures


- ARC


- GCD


- Opaque types


- Inits and deinit


### Networking in IOS. Important course.


The theory behind HTTP Networking.

When dealing with HTTP Networking, there are two computers need to communicate with each other..



1- Client: Sends requests


2- Server: serves requests


Client  -------------> Server


### Anatomy of URL

<code> http://classroom.udacity.com/nanodegrees/nd003 </codE>



1- http:// ----> This is the scheme


2- classroom.udacity.com : ----> This is a host.

Note: there is a numerical address for every computer which is called the IP address.


3- /nanodegrees/nd003: -----> this is the path.  




### Status Code

Example of some of the some status codes that might happen.


Status Code	Short Description	Category

100	  Continue	Information
200	  OK	Success
301	  Moved Permanently	Redirection
403	  Forbidden	Client Error
404 	Not Found	Client Error
418	  I'm a teapot	Client Error
500	  Internal Server Error	Server Error


### HTTP Verbs


1- GET -----> used to fetch data


2- POST --------> used to create a new element


3- DELETE ------> deletes an existed data


4- UPDATE -------> used to update an existed data.




#### Components of HTTP requests and responses.


- Requests contain

1- HTTP method

2- Endpoint: everything that comes after the host name.

3- HTTP Version

4- Headers: This is an extra info for the sent request

5- Blank Line

6- Body


- Response contain

1- HTTP Version

2- Status Code  

3- Status text: this is a description for status code.

4- Header: which contain additional meta data about the response  

5- Blank

6- Body



- Note:


When you see the padlock icon, it means that the client and server have set up an encrypted connection. This protects against anyone else reading and/or altering the content while it's en route.

In other words, it means that the site is using HTTPs, a secure extension of HTTP.

Some websites and web services use HTTP, and some use HTTPs. Let's look at what that means for us as mobile developers.


#### HTTPS on iOS

In a mobile app, it isn't so clear whether an app is using a secure connection to get its data. There's no app equivalent to the padlock icon that you see in web browsers.

Naturally, Apple would like to be able to give users the peace of mind that all connections are secure. In 2016, Apple announced that it would require HTTPS connections for all apps by the end of that year. This was hard news for developers, who do not necessarily have control over server settings.

However, at the time of this writing in 2018, Apple has still not completely disabled insecure connections. We'll see soon how to set our app's transport security settings to load both HTTP and HTTPs content.

Still, keep in mind that Apple likely will eventually disable insecure connections, and future-proof your apps accordingly. Use HTTPS wherever possible.

https://techcrunch.com/2016/06/14/apple-will-require-https-connections-for-ios-apps-by-the-end-of-2016/



#### URL


This is an important type in Swift.


This is one of the ways to construct a uel in swift. The code.

```swift


let urlString = "https://itunes.apple.com/us/app/udacity/id819700933?mt-8"

let url = URL(string: urlString)

print(url)

print("scheme: \(url?.scheme)")
print(url?.host)
print(url?.user)
print(url?.password)
print(url?.port)
print(url?.query)
print(url?.path)
print(url?.fragment)

```

We might encounter many problems when using the basic URL.


```swift


let itunesBaase = "https://itunes.apple.co"

var simpleUrl = URL(string: itunesBaase)

simpleUrl?.appendPathComponent("us")
simpleUrl?.appendPathComponent("udacity")
simpleUrl?.appendPathComponent("?mt=8") // T

print(simpleUrl)


```

The above code has an error. The last line has a string with a <code> ? </code>. This will be converted to %3. In order to solve this we need to use
UrlComponent


- UrlComponents. this is similar to URL, but with more flexibility to construct a url.

Example:

```swift

var urlComp = URLComponents()

urlComp.scheme = "https"
urlComp.host = "itunes.apple.com"
urlComp.path = "/us/app/udacity/id819700933"

urlComp.queryItems = [URLQueryItem(name: "mt", value: "8"), URLQueryItem(name: "class", value: "nandios")]  

print(urlComp)

```


Another way to avoid mistakes.


```swift

// move the hardcoded values into the GoogleSearch struct

struct GoogleSearch {
    static let scheme = "https"
    static let host = "google.com"
    static let path = "/search"
    static let queryName = "query"
    static let udacitySearchTerm = "udacity"
}

var components = URLComponents()

// then modify the code to use the constants in the GoogleSearch struct

components.scheme = GoogleSearch.scheme
components.host = GoogleSearch.host
components.path = GoogleSearch.path
components.queryItems = [URLQueryItem(name: GoogleSearch.queryName, value: GoogleSearch.udacitySearchTerm)]

print(components.url!)



```


###  URL Session and  Data Task .

So far, we have built urls and constructing them from scratch but why?

The reasons for making urls is to request them.


URLSession: An object that coordinates a group of related network data transfer tasks. Which is basically an object that make a network requests.

- When we make a network request, URLSession calls them TASKS or URLSessionTask. There are several types of tasks.

"Tasks" are what URLSession calls network requests.

1- URLSessionDataTask: Used for perfuming an HTTP request (GET, POST, etc.).

2- URLSessionDownloadTask: Downloading a file from a server.

3- URLSessionUploadTask: Uploading a file to a server

4- URLSessionStreamTask: Getting a continuous stream of data from a server.


Note: You cannot create create URLSessionDataTask unless you associate it with a url.session.


- MultiThreading. In IOS and android, there is this concept of the Main Thread.

Which runs things related to anything that renders views/UIViews



- How to make a network connections


1-  First I made an enum with the ur;.


```Swift

enum KittenImageLocation: String {
    case http = "http://www.kittenswhiskers.com/wp-content/uploads/sites/23/2014/02/Kitten-playing-with-yarn.jpg"
    case https = "https://upload.wikimedia.org/wikipedia/commons/thumb/0/06/Kitten_in_Rizal_Park%2C_Manila.jpg/460px-Kitten_in_Rizal_Park%2C_Manila.jpg"
    case error = "not a url"
}

```


2- create a url from the enum raw data.

```swift

var urlImage = KittenImageLocation.https.rawValue

      guard let  url = URL(string: urlImage) else {
          print("Image notfound")
          return
      }

```

3- Create URLSessionDataTask on top of the share instance.


```swift

let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
           // Did we get data back. Let us guard
           guard let Newdata = data else {
               print("Data not found")
               return
           }


    ```


Note: You have to guard it in order to exist early in case a url did not open.


4- Since we want to change the UI, we need to use a background thread to change the UI.


```swift

DispatchQueue.main.async {
                // Update the ui here
                    let uiImage = UIImage(data: Newdata)
                        self.imageCat.image = uiImage
            }

```



5- Don't forget to resume the task.

task.resume()


The whole code for the example triggered by a buttton click


```swift

@IBAction func loadImage(_ sender: UIButton) {
    var urlImage = KittenImageLocation.https.rawValue

    guard let  url = URL(string: urlImage) else {
        print("Image notfound")
        return
    }

    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        // Did we get data back. Let us guard
        guard let Newdata = data else {
            print("Data not found")
            return
        }
        // We got data
        DispatchQueue.main.async {
            // Update the ui here
                let uiImage = UIImage(data: Newdata)
                    self.imageCat.image = uiImage
        }


    }

    task.resume()

    // We can use the downloadTask
}


```



- Properties in Swift

Properties associate values with a particular class, structure, or enumeration. Stored properties store constant and variable values as part of an instance, whereas computed properties calculate (rather than store) a value. Computed properties are provided by classes, structures, and enumerations. Stored properties are provided only by classes and structures



Property observers.


```swift


//
//  DogApi.swift
//  SimpleNetworkApp
//
//  Created by Abdulaziz Asiri on 5/5/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import Foundation


struct DogApi {
    var x:Int
    var y:Int
    var ss:String
    let xx = AAA()
    var uu = AAA()

    init() {
        xx.yy =  10
        x = 10
        y = 49
        ss = ""

    }


    var a:String {
        get {
          return "Hello"
        }
        set(newStr) {
            a = newStr
        }
    }


}



class AAA {

    var yy: Int = 0
    var ystr: String?
    var  dog = DogApi()
    init() {
    dog.y = 4
        dog.ss = ""

    }

       var a:String {
           get {
             return "Hello"
           }
           set(newStr) {
               ystr = newStr
           }
       }


}
// Stored  props
// Since this is a value type
// If you create  a lett structure, then you cannot change the props insdie that struct unless you make

// the structure a var. Because structure are value type,you cannot change


// You cannot type: LetStructure.Varprops = 10 // Error.

// But in a case of class, this is fine,even if you creaate the instance of a class as let. Examaple

//LetClass.Var = 10 , because we are dealing with reference types.



// Computed Props.


```



###  JSON


How do we make JSON in swift, or convert a json object sent from a web server to swift syntax.

We need to use JSONSerialization.


- JSONSerialization: Converts JSON data to and from Swift dictionaries.


- Second approach is Codable.

Swift 4 introduced the codable protocol to convert data like json to and from Swift types.



1- Parsing JSON with JSONSerialization.

Parsing json using JSONSerialization can be lengthy. Look at the code which parses that following like json.


```json
{
    "message": "https://images.dog.ceo/breeds/ridgeback-rhodesian/n02087394_9126.jpg",
    "status": "success"
}

```


```swift


let dogUrl = DogApi.Endpoint.randomDogImages.url
    let task = URLSession.shared.dataTask(with: dogUrl) { (data, response, error) in
        // Did we get data back. Let us guard
        guard let newData = data else {
            print("Data not found")
            return
        }
//            print("data found : \(type(of:newData))"

        do {
            let json = try JSONSerialization.jsonObject(with: newData, options: []) as! [String: Any]
            let url = json["message"]

            let stringifyUrl = url as! String
            let imageURL2 = URL(string: stringifyUrl)

            let task2 = URLSession.shared.dataTask(with: imageURL2!) { (data, response, error) in

                guard let data = data else {
                    print("Error occurd for data")
                    return
                }


                            DispatchQueue.main.async {
                                // Update the ui here
                                    let uiImage = UIImage(data: data)
                                        self.imageCat.image = uiImage
                            }

            }

            task2.resume()
            // Anothe task



        } catch {
            print(error)
        }



    }

    task.resume()

    // We can use the downloadTask
}



```


### Codable

Codable consists of two protocol


1- Encodable: From Swift to JSON

2- Decodable: From JSOM tp Swift


To use codable protocol, we need first to make a struct that maps the in the json in variables.


Example:

We need to make struct that represents the data of this json.


```json
{
    "message": "https://images.dog.ceo/breeds/ridgeback-rhodesian/n02087394_9126.jpg",
    "status": "success"
}

```

The Struct is:


```swift

// From JSON to Swift
struct DdogImage : Codable{
    // The keys name in the response
    let status: String
    let message: String

}

```

Note: We have to conform to the protocol Codable.


Then in the app where we create the URLSession task, we do the following.

Since we need to convert json to swift we need to use <code> Decodable </code>


```swift
guard let  url = URL(string: urlImage) else {
            print("Image notfound")
            return
        }

        let dogUrl = DogApi.Endpoint.randomDogImages.url
        let task = URLSession.shared.dataTask(with: dogUrl) { (data, response, error) in
            // Did we get data back. Let us guard
            guard let newData = data else {
                print("Data not found")
                return
            }
            let decoder = JSONDecoder()
            let imageData = try! decoder.decode(DdogImage.self, from: newData)


            guard let newUrl = URL(string: imageData.message) else {
                return
            }
            let task2 = URLSession.shared.dataTask(with: newUrl) { (data, response, error) in
                guard let ddata = data else {
                    return
                }

                let image = UIImage(data: ddata)
                DispatchQueue.main.async {
                    self.imageCat.image = image
                }
            }
            task2.resume()
        }

        task.resume()

        // We can use the downloadTask



```
This is a review for the steps in creating a codable.

1- First, we need a JSON.

```swift
import Foundation

 d

// create a struct called "Planet" that conforms to Codable
// the struct should have properties with matching names and data types to the JSON
struct Planet: Codable {
    let name: String
    let type: String
    let standardGravity: Double
    let hoursInDay: Int
}

// create a JSON decoder
let decoder = JSONDecoder()

// decode the JSON into your model object and print the result
do {
    let earth = try decoder.decode(Planet.self, from: json)
    print(earth)
} catch {
    print(error)
}
```

### CodingKeys.

Coding keys is a way to give alias naming to JSON keys. in order to customize the names of the keys.


Example :


```swift

var json = """
{
    "food_name": "Lemon",
    "taste": "sour",
    "number of calories": 17
}
""".data(using: .utf8)!

struct Food: Codable {
    let name: String
    let taste: String
    let calories: Int
    enum CodingKeys: String, CodingKey {
        case name = "food_name"
        case taste = "taste"
        case calories = "number of calories"
    // add CodingKeys enum here
}
}

let decoder = JSONDecoder()
let food: Food

do {

    food = try decoder.decode(Food.self, from: json)
    print(food)
} catch {
    print(error)
}


```


### Dealing with JsonArray



```swift

import Foundation

var json = """
[
    {
        "title": "Groundhog Day",
        "released": 1993,
        "starring": ["Bill Murray", "Andie MacDowell", "Chris Elliot"]
    },
    {
        "title": "Home Alone",
        "released": 1990,
        "starring": ["Macaulay Culkin", "Joe Pesci", "Daniel Stern", "John Heard", "Catherine O'Hara"]
    }
]
""".data(using: .utf8)!

struct Movie: Codable {
    let title: String
    let released: Int
    let starring: [String]
}

let decoder = JSONDecoder()
let comedies: [Movie]

do {

    comedies = try decoder.decode([Movie].self, from: json) // we used [Struct]
    print(comedies)
} catch {
    print(error)
}


```


### Nested Object.


Nested json object is nothing but another struct within a struct.


Example:


```swift

import Foundation

var json = """
{
    "name": "Neha",
    "studentId": 326156,
    "academics": {
        "field": "iOS",
        "grade": "A"
    }
}
""".data(using: .utf8)!

// define model objects here

struct Academics: Codable {
let field : String
let grade: String

enum CodingKeys: String, CodingKey {
case field = "field"
case grade = "grade"
}
}
struct Student: Codable {
    let name : String
    let studentId: Int
    let academics: Academics

    enum CodingKeys: String, CodingKey{
    case name = "name"
    case studentId = "studentId"
    case academics = "academics"
    }
}
let decoder = JSONDecoder()
let student: Student

do {
    // decode the JSON into the "student" constant
    student = try decoder.decode(Student.self, from:json)
    print(student)
} catch {
    print(error)
}


```

NOTE: The above code was creating a GET request In order to make a POST request, we need to use UELRequest struct.


- API Session, is a time given to a user using a specific API to use the features of an API. (required an account)



- Question: api token vs api key vs Session vs authentication ? 



Code for the post request,


```swift

import Foundation
import CoreFoundation

// create a Codable struct called "POST" with the correct properties
struct Post: Codable {
    let userId: Int
    let title: String
    let body: String
}

// create an instance of the Post struct with your own values
let post = Post(userId: 1, title: "udacity", body: "udacious")

// create a URLRequest by passing in the URL
var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
// set the HTTP method to POST
request.httpMethod = "POST"
// set the HTTP body to the encoded "Post" struct
request.httpBody = try! JSONEncoder().encode(post)
// set the appropriate HTTP header fields
request.addValue("application/json", forHTTPHeaderField: "Content-Type")
// HACK: this line allows the workspace or an Xcode playground to execute the request, but is not needed in a real app
let runLoop = CFRunLoopGetCurrent()
// task for making the request
let task = URLSession.shared.dataTask(with: request) {data, response, error in
    print(String(data: data!, encoding: .utf8))
    // also not necessary in a real app
    CFRunLoopStop(runLoop)
}
task.resume()
// not necessary
CFRunLoopRun()


```
