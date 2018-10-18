//
//  LigandListViewController.swift
//  Swifty_Proteins
//
//  Created by Goodwill TSHEKELA on 2018/10/18.
//  Copyright © 2018 WTC_. All rights reserved.
//

import UIKit

class LigandListViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    var ligandList:[String] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var LigandTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("we have \(ligandList.count) ligands")
        return (ligandList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       // let cell2 = tableView.dequeueReusableCell(withIdentifier: "ligandCell", for: indexPath) as! LigandTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ligandCell", for: indexPath)  as! LigandTableViewCell
    
        cell.ligandName.text = ligandList[indexPath.row]
        cell.backgroundView = UIImageView(image: UIImage(named: "ligand_bg.jpg")!)
        cell.layer.borderColor = UIColor .black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        return cell
    }
    

   
    func retrieveLigands()
    {
        let path = Bundle.main.path(forResource: "ligands", ofType: "txt")
        let fileManager = FileManager.default
        if (fileManager.fileExists(atPath: path!))
        {
            do
            {
                let fileText = try String(contentsOfFile: path!, encoding: .utf8)
                ligandList = fileText.components(separatedBy: "\n")
            }
            catch let error as NSError
            {
                self.createAlert(title: "File Error", message: "Error occured when reading file")
                print("\n\n\n\(error)")
            }
        }
        else
        {
            self.createAlert(title: "Ligands not found", message: "File containing ligands does not exist")
        }
    }
    
    func createAlert(title: String, message: String)
    {
        let alert = UIAlertController(title : title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:
            {
                (action) in
                alert.dismiss(animated: true, completion: nil)
        }
        ))
        present(alert,animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        searchBar.delegate = self
        LigandTable.delegate = self
        retrieveLigands()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
}
