//
//  Ramp.swift
//  ARKit_iOS
//
//  Created by Sohel Dhengre on 10/04/18.
//  Copyright © 2018 Sohel Dengre. All rights reserved.
//

import Foundation
import ARKit

class Ramp {
    
    class func getPyramid() -> SCNNode {
        let obj = SCNScene(named: "art.scnassets/pipe.scn")
        let node  = obj?.rootNode.childNode(withName: "pipe", recursively: true)!
        node?.scale = SCNVector3Make(0.0022, 0.0022, 0.0022)
        node?.position = SCNVector3Make(-1, 0.8, -1)
        return node!
    }
    
    class func getPipe() -> SCNNode{
        let obj = SCNScene(named: "art.scnassets/pyramid.scn")
        let node = obj?.rootNode.childNode(withName: "pyramid", recursively: true)!
        node?.scale = SCNVector3Make(0.0058, 0.0058, 0.0058)
        node?.position = SCNVector3Make(-1, -0.48, -1)
        return node!
    }
    
    class func getQuater() -> SCNNode{
        let obj = SCNScene(named: "art.scnassets/quarter.scn")
        let node  = obj?.rootNode.childNode(withName: "quarter", recursively: true)!
        node?.scale = SCNVector3Make(0.0058, 0.0058, 0.0058)
        node?.position = SCNVector3Make(-1, -2, -1)
        return node!
    }
    
    class func startRotating(node: SCNNode) {
        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.01*Double.pi), z: 0, duration: 0.1))
        node.runAction(rotate)
    }
}
