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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Ligand " + ligandToDraw.name
        initLigandView()
        initLigandScene()
        initLigandCamera()
        drawLigandNodes()
        drawConnections()
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
        ligandScene.background.contents = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
    }

    func initLigandCamera()
    {
        ligandCamera = SCNNode()
        ligandCamera.camera = SCNCamera()
        ligandCamera.position = SCNVector3(x: 0, y: 0, z: 5)
    }
    
    func drawLigandNodes()
    {
        for node in ligandToDraw.nodes!
        {
            let nodeItem:SCNGeometry = SCNSphere(radius: 0.5)
            nodeItem.materials.first?.diffuse.contents = node.node_color
            let nodeSphere = SCNNode(geometry: nodeItem)
            nodeSphere.position = SCNVector3(x: node.x_pos!, y: node.y_pos!, z: node.z_pos!)
            ligandScene.rootNode.addChildNode(nodeSphere)
        }
    }
    
    func drawConnections()
    {
        for link in ligandToDraw.connections!
        {
            let node = ConnectionNode(node1: link.node1, node2: link.node2)
            ligandScene.rootNode.addChildNode(node)
        }
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
