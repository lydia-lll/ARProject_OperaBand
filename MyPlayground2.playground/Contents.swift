import UIKit
import SceneKit
import ARKit
import AVFoundation
import SwiftUI


class Coordinator: NSObject, ARSessionDelegate, ARSCNViewDelegate {

    var sceneView: ARSCNView
    var faceOrientation = ""
    var reportChange: (() -> Void)!
    var maskNum = 0
    
    var faceDetected = false

    
    init(_ view: ARSCNView){
        self.sceneView = view
        super.init()
        guard ARFaceTrackingConfiguration.isSupported else {
            print("Face tracking is not supported on this device")
            return
            
        }
        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration()
        self.sceneView.delegate = self
        self.sceneView.session.run(configuration)
    }
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let faceMesh = ARSCNFaceGeometry(device: sceneView.device!)!
        let material = faceMesh.firstMaterial!
        
        material.diffuse.contents = UIImage(named: "faceMask0")
        material.lightingModel = .physicallyBased
        
        let node = SCNNode(geometry: faceMesh)
//        node.geometry?.firstMaterial?.fillMode = .lines
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry {
            faceGeometry.update(from: faceAnchor.geometry)

            DispatchQueue.main.async {
                // Report changes to SwiftUI code
                self.reportChange()
            }
        }
        
    }
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
            if let faceAnchor = session.currentFrame?.anchors.first as? ARFaceAnchor {
                // check if the face anchor is valid
                if faceAnchor.isTracked {
                    // face is still in the camera frame
                    faceDetected = true
                    print("face")
                } else {
                    // face is not in the camera frame
                    faceDetected = false
                    print("no face..")
                }
            }
        }
    
    
}


