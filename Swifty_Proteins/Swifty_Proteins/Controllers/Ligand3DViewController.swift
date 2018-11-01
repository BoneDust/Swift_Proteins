//
//  Ligand3DViewController.swift
//  Swifty_Proteins
//
//  Created by Goodwill TSHEKELA on 2018/10/19.
//  Copyright © 2018 WTC_. All rights reserved.
//

import UIKit
import SceneKit
import PCLBlurEffectAlert
import Pulsator

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
            for node in ligandScene.rootNode.childNodes
            {
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
        ligandScene.background.contents = UIImage(named: "background")
    }

    func initLigandCamera()
    {
        ligandCamera = SCNNode()
        ligandCamera.camera = SCNCamera()
        ligandCamera.position = SCNVector3(x: 0, y: 0, z: 100)
    }
    
    func drawInitialLigandNodes()
    {
        for node in ligandToDraw.nodes!
        {
            let nodeItem:SCNGeometry = SCNSphere(radius: 0.5)
            nodeItem.materials.first?.diffuse.contents = node.node_color
            let nodeSphere = SCNNode(geometry: nodeItem)
            nodeSphere.position = SCNVector3(x: node.x_pos!, y: node.y_pos!, z: node.z_pos!)
            nodeSphere.name = node.atom.name + "\n" + node.atom.summary
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
       
      //the other modelling
    }
    
    func createNodeInfoPopup(_ title: String, _ message: String, _ pulsator: Pulsator)
    {
        
        let popup = PCLBlurEffectAlertController(title: title, message: message, effect: UIBlurEffect(style: .extraLight), style: .actionSheet)
        let popupAction = PCLBlurEffectAlertAction(title: "Dismiss", style: .cancel)
        {
            _  in
            pulsator.stop()
        }//, handler: #selector(self.shareAction))
        popup.addAction(popupAction)
        popup.configure(cornerRadius: 10)
        //still need some configuring
        popup.show()
    }
    
    @objc func shareAction()
    {
        let image = ligandView.snapshot()
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let tapped = touches.first!
        
        let position = tapped.location(in: ligandView)
        let tappedItems = ligandView.hitTest(position, options: nil)
        if let  tappedItem = tappedItems.first
        {
            let tappedNode = tappedItem.node
            
            //adding blinkung pulse
            let pulsator = Pulsator()
            pulsator.numPulse = 3
            pulsator.radius = 100.0
            pulsator.backgroundColor = UIColor(red: 0/255, green: 200/255, blue: 0/255, alpha: 1).cgColor
            let pos = ligandView.projectPoint(tappedNode.position)
            pulsator.position = CGPoint(x: CGFloat(pos.x), y: CGFloat(pos.y))
            ligandView.layer.addSublayer(pulsator)
            pulsator.start()
            
            //create and show the popup
            let nodeDetails = tappedNode.name!.split(separator: "\n")
            createNodeInfoPopup(String(nodeDetails[0]), String(nodeDetails[1]), pulsator)
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
