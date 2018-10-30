//
//  Ligand3DViewController.swift
//  Swifty_Proteins
//
//  Created by Goodwill TSHEKELA on 2018/10/19.
//  Copyright © 2018 WTC_. All rights reserved.
//

import UIKit
import SceneKit

class Ligand3DViewController: UIViewController
{
    var ligandToDraw: LigandModel!
    var ligandView: SCNView!
    var ligandScene: SCNScene!
    var ligandCamera: SCNNode!
    var ballStickList:[SCNNode] = []
    var spaceAtomList:[SCNNode] = []
    var shareButton:UIBarButtonItem!
    
    @IBAction func modelSelection(_ sender: UISegmentedControl)
    {
        if (sender.selectedSegmentIndex == 0)
        {
            ligandScene.rootNode.enumerateChildNodes
            {
                (node, _) in
                node.removeFromParentNode()
            }
            for node in ballStickList
            {
                ligandScene.rootNode.addChildNode(node)
            }
            self.drawInitialConnections()
        }
        else
        {
            ligandScene.rootNode.enumerateChildNodes
            {
                (node, _) in
                node.removeFromParentNode()
            }
            //self.drawInitialConnections()
            self.drawSpaceFillingNodes()
           
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Ligand " + ligandToDraw.name
        shareButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(self.shareAction))
        self.navigationItem.rightBarButtonItem = shareButton
        initLigandView()
        initLigandScene()
        initLigandCamera()
       
        drawInitialLigandNodes()
        drawInitialConnections()
    }
    
    func initLigandView()
    {
        ligandView = self.view as! SCNView
        ligandView.allowsCameraControl = true

    }
 
    func initLigandScene()
    {
        ligandScene = SCNScene()
        ligandView.scene = ligandScene
        ligandView.isPlaying = true
        ligandScene.background.contents = UIImage(named: "background")//UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
    }

    func initLigandCamera()
    {
        ligandCamera = SCNNode()
        ligandCamera.camera = SCNCamera()
        ligandCamera.position = SCNVector3(x: 0, y: 0, z: -500)
    }
    
    func drawInitialLigandNodes()
    {
        for node in ligandToDraw.nodes!
        {
            let nodeItem:SCNGeometry = SCNSphere(radius: 0.5)
            nodeItem.materials.first?.diffuse.contents = node.node_color
            let nodeSphere = SCNNode(geometry: nodeItem)
            nodeSphere.position = SCNVector3(x: node.x_pos!, y: node.y_pos!, z: node.z_pos!)
            ligandScene.rootNode.addChildNode(nodeSphere)
            ballStickList.append(nodeSphere)
        }
    }
    
    func drawInitialConnections()
    {
        for link in ligandToDraw.connections!
        {
            let node = ConnectionNode(node1: link.node1, node2: link.node2)
            ligandScene.rootNode.addChildNode(node)
        }
    }
    
    func drawSpaceFillingNodes()
    {
        let hybrid = SCNNode()
        hybrid.position = SCNVector3(x: 0, y: 0, z: 0)
        for node in ballStickList
        {
            hybrid.addChildNode(node)
            let dist = self.distance(hybrid.position, node.position)
            let factor = dist / 0.25
            let new_x2 = (factor * hybrid.position.x) + node.position.x
            let new_y2 = (factor * hybrid.position.y) + node.position.y
            let new_z2 = (factor * hybrid.position.z) + node.position.z
            
            //let nodeItem2:SCNGeometry = SCNSphere(radius: 0.5)
            //nodeItem2.materials.first?.diffuse.contents = link.node2.node_color
            //let nodeSphere2 = SCNNode(geometry: nodeItem2)
            node.position = SCNVector3(x: new_x2, y: new_y2, z: new_z2)
            hybrid.addChildNode(node)
            
            //ligandScene.rootNode.addChildNode(node)
        }
    
        
        ligandScene.rootNode.addChildNode(hybrid)
      
    }
    
    @objc func shareAction()
    {
        print("ggjkb")
        
        let image = ligandView.snapshot()
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        if let popoverPresentationController = activityController.popoverPresentationController
        {
            popoverPresentationController.sourceView = self.ligandView
        }
        print("done")
    }
    
    func distance (_ v1: SCNVector3, _ v2: SCNVector3) -> Float
    {
        var dist = abs(v1.x - v2.x) * abs(v1.x - v2.x)
        dist += abs(v1.y - v2.y) * abs(v1.y - v2.y)
        dist += abs(v1.z - v2.z) * abs(v1.z - v2.z)
        dist = Float(sqrt(dist))
        return (dist)
    }
    
    override var shouldAutorotate: Bool
    {
        return (true)
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return (true)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            return (.allButUpsideDown)
        }
        else
        {
            return (.all)
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
      
    }
    
}
