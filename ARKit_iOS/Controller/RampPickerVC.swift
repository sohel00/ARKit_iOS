//
//  RampPickerVC.swift
//  ARKit_iOS
//
//  Created by Sohel Dhengre on 15/02/18.
//  Copyright © 2018 Sohel Dhengre. All rights reserved.
//

import UIKit
import SceneKit

class RampPickerVC: UIViewController {

    var sceneView:SCNView!
    var size: CGSize!
    weak var rampPlacerVC:RampPlacerVC!
    
    init(size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        view.frame = CGRect(origin: CGPoint.zero, size: size)
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.insertSubview(sceneView, at: 0)
        let scene = SCNScene(named: "art.scnassets/Ramps.scn")!
        sceneView.scene = scene
        preferredContentSize = size
        
        view.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.borderWidth = 3.0
        
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        scene.rootNode.camera = camera
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        sceneView.addGestureRecognizer(tap)
        
        
        let pipe = Ramp.getPipe()
        Ramp.startRotating(node: pipe)
        scene.rootNode.addChildNode(pipe)
        
        let pyramid = Ramp.getPyramid()
        Ramp.startRotating(node: pyramid)
        scene.rootNode.addChildNode(pyramid)
        
        let quarter = Ramp.getQuater()
        Ramp.startRotating(node: quarter)
        scene.rootNode.addChildNode(quarter)
        
        
    }
    
    
    @objc func handleTap(_ gestureRecognizer:UITapGestureRecognizer){
        let p = gestureRecognizer.location(in: sceneView)
        let hitResult = sceneView.hitTest(p, options: [:])
        
        if hitResult.count > 0 {
            let node = hitResult[0].node
            print(node.name!)
            rampPlacerVC.onRampSelected(node.name!)
        }
    }
}
