//
//  ViewController.swift
//  True Depth
//
//  Created by Sai Kambampati on 2/23/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var faceLabel: UILabel!
    @IBOutlet weak var labelView: UIView!
    var analysis = ""
    var DLplayer: AVAudioPlayer? = nil
    var reportChange: (() -> Void)!
    var smile = false
    var play = false
    var DLAudioModel: AudioModel = nil
    
    let bundleAudio = [
        "DLlowLong.wav",
        "DLhighLong.wav",
        "DLlowlow.wav"
    ];
    
    func loadBundleAudio(_ fileName:String) -> AVAudioPlayer? {
        let path = Bundle.main.path(forResource: fileName, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            return try AVAudioPlayer(contentsOf: url)
        } catch {
            print("loadBundleAudio error", error)
        }
        return nil
    }
    
    override func viewDidLoad() {
        print("ViewController viewDidLoad")
        super.viewDidLoad()
        
        labelView.layer.cornerRadius = 10
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        guard ARFaceTrackingConfiguration.isSupported else {
            print("Face tracking is not supported on this device")
            return
        }
        
        // Disable UIKit label in Main.storyboard
        labelView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewController viewWillAppear")

        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("ViewController viewWillDisappear")

        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
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
            expression(anchor: faceAnchor)
            playAudio()
            
            DispatchQueue.main.async {
                // Disable UIKit label in Main.storyboard
                // self.faceLabel.text = self.analysis
                // Report changes to SwiftUI code
                self.reportChange()
            }
            
        }
    }
    
    func expression(anchor: ARFaceAnchor) {
        let leftEyeBlink = anchor.blendShapes[.eyeBlinkLeft]
        let rightEyeBlink = anchor.blendShapes[.eyeBlinkRight]
        
        let cheekSquintLeft = anchor.blendShapes[.cheekSquintLeft]
        let cheekSquintRight = anchor.blendShapes[.cheekSquintRight]
        
        let jawOpen = anchor.blendShapes[.jawOpen]
        
        let browDownLeft = anchor.blendShapes[.browDownLeft]
        let browDownRight = anchor.blendShapes[.browDownRight]
        let browInnerUp = anchor.blendShapes[.browInnerUp]
        let browOuterUpLeft = anchor.blendShapes[.browOuterUpLeft]
        let browOuterUpRight = anchor.blendShapes[.browOuterUpRight]
        
        let noseSneerLeft = anchor.blendShapes[.noseSneerLeft]
        let noseSneerRight = anchor.blendShapes[.noseSneerRight]
        
        self.analysis = ""
        
        if ((browDownLeft?.decimalValue ?? 0.0) + (browDownRight?.decimalValue ?? 0.0)) > 0.9 {
            self.analysis += "Your borws are down. "
            self.smile = true;
            let Audio
        }
        
        if cheekPuff?.decimalValue ?? 0.0 > 0.1 {
            self.analysis += "Your cheeks are puffed. "
        }
        
        if tongue?.decimalValue ?? 0.0 > 0.1 {
            self.analysis += "Don't stick your tongue out! "
        }
        
        if leftEyeBlink?.decimalValue ?? 0.0 > 0.1{
            self.analysis += "Left Eye Blink"
        }
        
        if rightEyeBlink?.decimalValue ?? 0.0 > 0.1{
            self.analysis += "Right Eye Blink"
        }
        
        if cheekSquintLeft?.decimalValue ?? 0.0 > 0.1{
            self.analysis += "cheekSquintLeft"
        }
        if cheekSquintRight?.decimalValue ?? 0.0 > 0.1{
            self.analysis += "cheekSquintRight"
        }
        if jawOpen?.decimalValue ?? 0.0 > 0.1{
            self.analysis += "jawOpen"
        }
        if browDownLeft?.decimalValue ?? 0.0 > 0.1{
            self.analysis += "browDownLeft: \(String(describing: browDownLeft?.decimalValue))"
        }
        if browDownRight?.decimalValue ?? 0.0 > 0.1{
            self.analysis += "browDownRight: \(String(describing: browDownRight?.decimalValue))"
        }
        if browInnerUp?.decimalValue ?? 0.0 > 0.1{
            self.analysis += "browInnerUp: \(String(describing: browInnerUp?.decimalValue))"
        }
        if browOuterUpLeft?.decimalValue ?? 0.0 > 0.1{
            self.analysis += "browOuterUpLeft: \(String(describing: browOuterUpLeft?.decimalValue))"
        }
        if browOuterUpRight?.decimalValue ?? 0.0 > 0.1{
            self.analysis += "browOuterUpRight: \(String(describing: browOuterUpRight?.decimalValue))"
        }
        
        if noseSneerLeft?.decimalValue ?? 0.0 > 0.1{
            self.analysis += "noseSneerLeft: \(String(describing: noseSneerLeft?.decimalValue))"
        }
        if noseSneerRight?.decimalValue ?? 0.0 > 0.1{
            self.analysis += "noseSneerRight: \(String(describing: noseSneerRight?.decimalValue))"
        }
    }
    
    func playAudio(){
        if (smile && !play){
            self.DLplayer = loadBundleAudio(bundleAudio[0])
            print("DLplayer", DLplayer as Any)
            // Loop indefinitely
            self.DLplayer?.numberOfLoops = 0
            self.DLplayer?.play()
            self.play = true
            print(DLplayer?.isPlaying)
            print("it should play sth")
        }
        if(DLplayer?.isPlaying == false){
            self.play = false
            self.smile = false
            print("stopped")
        }
    }
    
    
}

