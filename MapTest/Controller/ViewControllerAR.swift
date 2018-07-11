//
//  ViewController.swift
//  Real Dicee
//
//  Created by Angela Yu on 12/07/2017.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewControllerAR: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.lockOrientation(.landscape)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

        sceneView.autoenablesDefaultLighting = true

        let screenSize = UIScreen.main.bounds
        let buttonAR = UIButton(frame: CGRect(x: screenSize.height - screenSize.height/5, y: screenSize.width - screenSize.height/5, width: screenSize.height/7, height: screenSize.height/7))
        buttonAR.backgroundColor = .blue
        buttonAR.setTitle("Return to map", for: .normal)
        buttonAR.layer.cornerRadius = screenSize.height/14
        buttonAR.clipsToBounds = true
        buttonAR.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        
        view.addSubview(buttonAR)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first {

                // Create a new scene
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!

                if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {

                    diceNode.position = SCNVector3(
                        x: hitResult.worldTransform.columns.3.x,
                        y: hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                        z: hitResult.worldTransform.columns.3.z
                    )

                    sceneView.scene.rootNode.addChildNode(diceNode)
                    
                    let randomX = Float((arc4random_uniform(4) + 1)) * (Float.pi/2)
                    //        let randomY = Double((arc4random_uniform(10) + 11)) * (Double.pi/2)
                    let randomZ = Float((arc4random_uniform(4) + 1)) * (Float.pi/2)
                    
                    diceNode.runAction(SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomZ * 5), duration: 0.5))

                }
                
            }
            
        }
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor {
            
            print("plane detected")
            
            let planeAnchor = anchor as! ARPlaneAnchor

            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [gridMaterial]
            
            let planeNode = SCNNode()

            planeNode.geometry = plane
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            node.addChildNode(planeNode)
            
        } else {
            return
        }

    }

    
    @objc func dismissAction(sender: UIButton!) {
        AppUtility.lockOrientation(.portrait)
        self.dismiss(animated: true, completion: nil)
    }
    

}
