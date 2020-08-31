### Stuff about image picker

- Opening an album and choose an image


```swift

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage

      imageContainer.image = image
      dismiss(animated: true, completion: nil)

  }


  ```



- We need to learn a bit about Notifications. It is crucial.


- Things we need to consider later for the MemeME app,


1- Highlighting a text was not working properly.


2- Clicking the top comment was shifting the entire view above.


3- Learn about Notification  in IOS.


### Learnings found in this project.
