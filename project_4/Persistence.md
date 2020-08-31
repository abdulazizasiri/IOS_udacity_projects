## Persistence Data

- What are persistence in IOS?

persistence is saving data to a place where it can be re-accessed and retrieved upon restart the device or an app.



There are many types of persistence


1- Simple Persistence NSUSerDefaults

2- IOS File systems and Sandboxing

3-  Core Data



### NSUSerDefaults


The simplest form of persistence. It stores  bits of data in a key-value pair.


Steps:


1-  Create a var defaults equals to <code> UserDefaults.standard </code>

2- adding values to the userDefaults: defaults.set(PIMITIVES, forKey:"")

3- Retrieving: in the onViewDidLoad ,    

<code>
  if let items = defaults.array(forKey: "listItems") as? [String] {
            array = items
        }  </code>



Note, that userDefaults have types of all the primitives in Swift.


UserDefaults use plist to store data which is a key-value file type.



### File System

Every app lives in its own sandbox. The sandbox is divided into multiple containers .


1- Bundle container which stores the app itself.  MyApp.app such as the executable files

2- Data container stores all the user and app data. This container has three folders

- Temp

- Library. has all

- Document where our user defaults lives.

3- iCloud Container

#### Codable : Later

### Core data
