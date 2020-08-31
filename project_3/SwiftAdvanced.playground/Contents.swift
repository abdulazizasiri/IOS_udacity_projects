import UIKit

var str = "Hello, playground"



// Closures

let f = {(num: Int, num2:Int) -> Int in return num + num2} // One form of a closures.

// Closure syntax that takes one param

let printleg = {print("dfdfd")}

let mult = { x in return x * 100} // only one param

let mult2 = {(x:Int,y:Int) in return x * y} // no return

let mult3 = {$0 * 100}


// The standard look is:

// { (PARAMS) -> RETURN TYPE IN }

//print(f(10, 20)) // Do i

var cosure = [f,mult2]

//printleg()


// NOTE: functions and closures are exactly the same thing , but they have dufferent syntax.

// Variable Captiure in closures



// LEsson 2: URLs


let urlString = "https://itunes.apple.com/us/app/udacity/id819700933?mt-8"

let url = URL(string: urlString)

print(url)

//print("scheme: \(url?.scheme)")
//print(url?.host)
//print(url?.user)
//print(url?.password)
//print(url?.port)
//print(url?.query)
//print(url?.path)
//print(url?.fragment)


// Constructing a URL.

let itunesBaase = "https://itunes.apple.co"

var simpleUrl = URL(string: itunesBaase)

simpleUrl?.appendPathComponent("us")
simpleUrl?.appendPathComponent("udacity")
simpleUrl?.appendPathComponent("?mt=8")

print(simpleUrl)


// Making a url using a urlcomponent

var urlComp = URLComponents()

urlComp.scheme = "https"
urlComp.host = "itunes.apple.com"
urlComp.path = "/us/app/udacity/id819700933"

urlComp.queryItems = [URLQueryItem(name: "mt", value: "8"), URLQueryItem(name: "class", value: "nandios")]  

print(urlComp)
