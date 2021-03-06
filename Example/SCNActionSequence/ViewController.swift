//
//  SCNActionSequence
//
//  Created by Michael-Vorontsov on 11/18/2017.
//  Copyright (c) 2017 Michael-Vorontsov. All rights reserved.
//

import SceneKit
import SCNActionSequence

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            let capsule = (scnView.scene?.rootNode.childNode(withName: "capsule", recursively: true))!
            
            result.node
                .begin(action: SCNAction.moveBy(x: 5.0, y: 5.0, z: 0.0, duration: 2.0) )
                .then(wait: 2.0)
                .then(transactionDuration: 5.0) {
                    result.node.position = SCNVector3Zero
                    capsule.position = SCNVector3Zero
                }
                .runSimultaneouslyWith()
                .then(action: SCNAction.rotate(by: CGFloat.pi / 2.0, around: SCNVector3(x: 0, y: 0, z: 1), duration: 5.0))
                .then(action: SCNAction.moveBy(x: 5.0, y: 5.0, z: 0.0, duration: 2.0))
                .then(action: SCNAction.moveBy(x: -5.0, y: -2.0, z: 0.0, duration: 2.0))
                .then{ _ in print(" Handler 1") }
                .then(target: capsule, action: SCNAction.moveBy(x: -5.0, y: -2.0, z: 0.0, duration: 5.0))
                .then{ _ in print(" Handler 2")}
                .then(target: nil, action: SCNAction.moveBy(x: -5.0, y: -2.0, z: 0.0, duration: 5.0))
                .run{ print(" Comleted")}
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
