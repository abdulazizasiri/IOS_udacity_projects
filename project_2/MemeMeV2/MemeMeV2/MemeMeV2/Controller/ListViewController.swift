//
//  ViewController.swift
//  MemeMeV2
//
//  Created by Abdulaziz Asiri on 4/30/20.
//  Copyright © 2020 Abdulaziz Asiri. All rights reserved.
//

import UIKit

class ListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var table: UITableView!
    
    let memeArr = (UIApplication.shared.delegate as! AppDelegate).memeData
    
    var tempImae: UIImage!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (UIApplication.shared.delegate as! AppDelegate).memeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"listTableCell", for: indexPath) as! ListViewCellTableViewCell
        
        cell.label?.text = (UIApplication.shared.delegate as! AppDelegate).memeData[indexPath.row].topComment + " " +
            (UIApplication.shared.delegate as! AppDelegate).memeData[indexPath.row].bottomComment
        cell.memeImage?.image =  (UIApplication.shared.delegate as! AppDelegate).memeData[indexPath.row].editedImage
        return cell
    }
    

    @IBOutlet weak var memTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        
       
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imageDetail = storyboard?.instantiateViewController(withIdentifier: "MeMeDetailsViewController" ) as! MeMeDetailsViewController
    
       tempImae = (UIApplication.shared.delegate as! AppDelegate).memeData[indexPath.row].editedImage

         
        performSegue(withIdentifier: "detailedSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if  segue.identifier == "detailedSegue" {
               let newVC = segue.destination as! MeMeDetailsViewController
               newVC.sentImage = tempImae
           }
       }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
       print("The length is : \(memeArr.count)") // still zero 
        table.reloadData()
    }
    
   
}


