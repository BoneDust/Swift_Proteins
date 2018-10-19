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
    var searchedLigands:[String] = []
    var searchingForLigands = false
    var selectedLigand: LigandModel?
    
    @IBOutlet weak var ligandSearchBar: UISearchBar!
    
    @IBOutlet weak var LigandTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (searchingForLigands)
        {
            return (searchedLigands.count)
        }
        else
        {
            return (ligandList.count)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (searchingForLigands)
        {
            Ligand3DViewController.ligand = searchedLigands[indexPath.row]
            retrieveLigand(searchedLigands[indexPath.row])
            
        }
        else
        {
            Ligand3DViewController.ligand = ligandList[indexPath.row]
            retrieveLigand(ligandList[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ligandCell", for: indexPath)  as! LigandTableViewCell
        if (searchingForLigands)
        {
            cell.ligandName.text = searchedLigands[indexPath.row]
        }
        else
        {
            cell.ligandName.text = ligandList[indexPath.row]
        }
        cell.backgroundView = UIImageView(image: UIImage(named: "ligand_bg.jpg")!)
        cell.layer.borderColor = UIColor .black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        return (cell)
    }
    

    func retrieveLigandsFromFile()
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
            catch // let error as NSError
            {
                self.createAlert(title: "File Error", message: "Error occured when reading file")
            }
        }
        else
        {
            self.createAlert(title: "Ligands not found", message: "File containing ligands does not exist")
        }
    }
    
    func retrieveLigand(_ ligand: String)
    {
        let url1 = "https://files.rcsb.org/ligands/view/"
        let url2 = "_ideal.pdb"

        UIApplication.shared.beginIgnoringInteractionEvents()
        let indicator = UIActivityIndicatorView()
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        self.view.addSubview(indicator)
        
        
        let finalUrl = URL(string: url1 + ligand + url2)
        let task = URLSession.shared.dataTask(with: finalUrl!, completionHandler:
        {
            (data, response, error) in
            
            if (response != nil)
            {
                let response = response as? HTTPURLResponse
                if (response?.statusCode == 200)
                {
                    DispatchQueue.main.async
                    {
                        let responseContent = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.ascii.rawValue)) as String?
                        //what to do
                        var ligandData:[String] = []
                        responseContent?.enumerateLines
                        {
                            (line, _) in
                            ligandData.append(line)
                        }
                        
                        UIApplication.shared.endIgnoringInteractionEvents()
                        indicator.stopAnimating()
                        self.performSegue(withIdentifier: "drawLigand", sender: self)
                    }
                }
                else
                {
                    UIApplication.shared.endIgnoringInteractionEvents()
                    indicator.stopAnimating()
                    self.createAlert(title: "Ligand not retrieved", message: "Ligand \(ligand) was not found.")
                }
            }
            
            else
            {
                UIApplication.shared.endIgnoringInteractionEvents()
                indicator.stopAnimating()
                self.createAlert(title: "Ligand not retrieved", message: "Ligand \(ligand) was not found.")
            }
        })
        task.resume()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        searchingForLigands = true
        searchedLigands = []
        searchedLigands = ligandList.filter({$0.contains((ligandSearchBar.text!.uppercased()))})
        if (searchedLigands.count == 0)
        {
            searchedLigands = ligandList
        }
        DispatchQueue.main.async
        {
            self.LigandTable.reloadData()
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
        ligandSearchBar.delegate = self
        LigandTable.delegate = self
        retrieveLigandsFromFile()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
}
