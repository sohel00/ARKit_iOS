//
//  ViewController.swift
//  ARKit_iOS
//
//  Created by Sohel Dhengre on 15/02/18.
//  Copyright © 2018 Sohel Dhengre. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class RampPlacerVC: UIViewController, ARSCNViewDelegate,UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var controlsStack: UIStackView!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var rotateBtn: UIButton!
    @IBOutlet weak var upBtn: UIButton!
    @IBOutlet weak var downBtn: UIButton!
    
    var selectedRampName:String?
    var selectedRamp: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/Main.scn")!
        sceneView.automaticallyUpdatesLighting = true
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let gesture1 = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGesture(_:)))
        let gesture2 = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGesture(_:)))
        let gesture3 = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGesture(_:)))
        gesture1.minimumPressDuration = 0.1
        gesture2.minimumPressDuration = 0.1
        gesture3.minimumPressDuration = 0.1
        rotateBtn.addGestureRecognizer(gesture1)
        upBtn.addGestureRecognizer(gesture2)
        downBtn.addGestureRecognizer(gesture3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let results = sceneView.hitTest(touch.location(in: sceneView), types: .featurePoint)
        guard let hitFeature = results.last else {return}
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        placeRamp(position: hitPosition)
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    @IBAction func rampBtnpressed(_ sender: UIButton) {
        let rampPickerVC = RampPickerVC(size: CGSize(width: 250, height: 500))
        rampPickerVC.modalPresentationStyle = .popover
        rampPickerVC.rampPlacerVC = self
        rampPickerVC.popoverPresentationController?.delegate = self
        present(rampPickerVC, animated: true, completion: nil)
        rampPickerVC.popoverPresentationController?.sourceView = sender
        rampPickerVC.popoverPresentationController?.sourceRect = sender.bounds
    }
    
    func onRampSelected(_ rampName:String){
        selectedRampName = rampName
    }
    
    func placeRamp(position:SCNVector3){
        
        if let rampName = selectedRampName {
            controlsStack.isHidden = false
            let ramp = Ramp.getRampByName(rampName: rampName)
            selectedRamp = ramp
            ramp.scale = SCNVector3Make(0.01, 0.01, 0.01)
            sceneView.scene.rootNode.addChildNode(ramp)
        }
    }
    
    @objc func longPressGesture(_ sender:UILongPressGestureRecognizer){
        
        if let ramp = selectedRamp{
            if sender.state == .ended {
                ramp.removeAllActions()
            } else if sender.state == .began {
                if sender.view === rotateBtn {
                    let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.08*Double.pi), z: 0, duration: 0.1))
                    ramp.runAction(rotate)
                } else if sender.view === upBtn {
                    let up = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 0.08, z: 0, duration: 0.1))
                    ramp.runAction(up)
                } else if sender.view === downBtn {
                    let down = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: -0.08, z: 0, duration: 0.1))
                    ramp.runAction(down)
                }
            }
        }
    }
    
    @IBAction func closePressed(_ sender: Any) {
        
        if let ramp = selectedRamp {
            ramp.removeFromParentNode()
            selectedRamp = nil
        }
    }
    
}
