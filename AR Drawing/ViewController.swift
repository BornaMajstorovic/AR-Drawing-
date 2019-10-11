//
//  ViewController.swift
//  AR Drawing
//
//  Created by Borna on 06/10/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate{

    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var draw: UIButton!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        self.sceneView.showsStatistics = true
        self.sceneView.session.run(configuration)
        
        self.sceneView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41,transform.m42, transform.m43)
        
        let currentPositionOfCamera = orientation + location
        
        DispatchQueue.main.async {
            if self.draw.isHighlighted {
                        let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                        sphereNode.position = currentPositionOfCamera
                        sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                        self.sceneView.scene.rootNode.addChildNode(sphereNode)
                    } else {
                        let pointer = SCNNode(geometry: SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0.01/2))
                        pointer.position = currentPositionOfCamera
                            
                        
                        self.sceneView.scene.rootNode.enumerateChildNodes({(node, _) in
                            if node.geometry is SCNBox {
                                node.removeFromParentNode()
                            } 
                        })
                
                        self.sceneView.scene.rootNode.addChildNode(pointer)
                        pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                    }
        }
        
       
       
    }
    
}

func +(left : SCNVector3, right : SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y , left.z + right.z)
}
