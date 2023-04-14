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

    var sceneView = ARSCNView()
    var analysis = ""
    var reportChange: (() -> Void)!
    
    var audioModel = AudioModel()
    var DLAudioPlayer: AudioPlayerModel?
    var BGAudioPlayer: AudioPlayerModel?
    var XLAudioPlayer: AudioPlayerModel?
    var NBAudioPlayer: AudioPlayerModel?
    
    var eyeDown = false
    var eyeUp = false
    var browDown = false
    var browUp = false
    var smile = false
    var cheekPuff = false
    
    override func viewDidLoad() {
        print("ViewController viewDidLoad")
        super.viewDidLoad()
        
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        guard ARFaceTrackingConfiguration.isSupported else {
            print("Face tracking is not supported on this device")
            return
        }
        
        // initialize audio players
        NBAudioPlayer = AudioPlayerModel(soundAssets: audioModel.BLbundleAudio, pitch: 0, volume: 0, speed: 0)
        XLAudioPlayer = AudioPlayerModel(soundAssets: audioModel.BLbundleAudio, pitch: 0, volume: 0, speed: 0)
        DLAudioPlayer = AudioPlayerModel(soundAssets: audioModel.DLbundleAudio, pitch: 0, volume: 0, speed: 0)
        BGAudioPlayer = AudioPlayerModel(soundAssets: audioModel.BGbundleAudio, pitch: 0, volume: 1, speed: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewController viewWillAppear")

        super.viewWillAppear(animated)
        self.view = sceneView
        
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
            
            //detect facial expressions
            expression(anchor: faceAnchor)
            //map expressions to sounds
            audioPlay()
            
            
            DispatchQueue.main.async {
                // Disable UIKit label in Main.storyboard
                // self.faceLabel.text = self.analysis
                // Report changes to SwiftUI code
                self.reportChange()
            }
            
        }
    }
    
    func expression(anchor: ARFaceAnchor) {
        let leftEyeDown = anchor.blendShapes[.eyeLookDownLeft]
        let rightEyeDown = anchor.blendShapes[.eyeLookDownRight]
        let leftEyeUp = anchor.blendShapes[.eyeLookUpLeft]
        let rightEyeUp = anchor.blendShapes[.eyeLookUpRight]
        
        let smileLeft = anchor.blendShapes[.mouthSmileLeft]
        let smileRight = anchor.blendShapes[.mouthSmileRight]
        let cheekPuff = anchor.blendShapes[.cheekPuff]
        
        let jawOpen = anchor.blendShapes[.jawOpen]
        
        let browDownLeft = anchor.blendShapes[.browDownLeft]
        let browDownRight = anchor.blendShapes[.browDownRight]
        let browInnerUp = anchor.blendShapes[.browInnerUp]
        
        self.analysis = ""
        
        if ((leftEyeDown?.decimalValue ?? 0.0) + (rightEyeDown?.decimalValue ?? 0.0)) > 0.82 {
            self.analysis += "Eye Down"
            self.XLAudioPlayer?.volume = (leftEyeDown?.floatValue ?? 0.0) + (rightEyeDown?.floatValue ?? 0.0) - 0.82
            self.XLAudioPlayer?.soundIndex = 0
            self.eyeDown = true
        }
        if ((leftEyeUp?.decimalValue ?? 0.0) + (rightEyeUp?.decimalValue ?? 0.0)) > 0.82 {
            self.analysis += "Eye Up"
            self.NBAudioPlayer?.volume = (leftEyeUp?.floatValue ?? 0.0) + (rightEyeUp?.floatValue ?? 0.0) - 0.82
            self.NBAudioPlayer?.soundIndex = 1
            self.eyeUp = true
        }
        
        if ((browDownLeft?.decimalValue ?? 0.0) + (browDownRight?.decimalValue ?? 0.0)) > 0.82 {
            self.analysis += "Your borws are down. "
            self.DLAudioPlayer?.soundIndex = 2
            self.DLAudioPlayer?.volume = (browDownLeft?.floatValue ?? 0.0) + (browDownRight?.floatValue ?? 0.0) - 0.82
            self.browDown = true;
            
        }
        if browInnerUp?.decimalValue ?? 0.0 > 0.06{
            if browInnerUp?.decimalValue ?? 0.0 > 0.2{
                self.analysis += "your brow is really high"
                self.DLAudioPlayer?.soundIndex = 1
                self.DLAudioPlayer?.volume = (browInnerUp?.floatValue ?? 0.0) - 0.17
                self.browUp = true;
            }else{
                self.analysis += "browInnerUp"
                self.DLAudioPlayer?.soundIndex = 0
                self.DLAudioPlayer?.volume = (browInnerUp?.floatValue ?? 0.0) - 0.06
                self.browUp = true;
            }
        }
        
        if ((smileLeft?.decimalValue ?? 0.0) + (smileRight?.decimalValue ?? 0.0)) > 0.9 {
            self.analysis += "You are smiling. "
            self.BGAudioPlayer?.soundIndex = 0
            self.smile = true
        }
        
        if cheekPuff?.decimalValue ?? 0.0 > 0.1 {
            self.analysis += "Your cheeks are puffed. "
            self.BGAudioPlayer?.soundIndex = 1
            self.cheekPuff = true
        }
        
        
        if jawOpen?.decimalValue ?? 0.0 > 0.1{
            self.analysis += "jawOpen"
        }
        
    }
    
    func audioPlay(){
        if(eyeDown){
            XLAudioPlayer?.playAudioWDelay()
            eyeDown = false
        }
        if(eyeUp){
            NBAudioPlayer?.playAudioWDelay()
            eyeUp = false
        }
        if(browDown){
            DLAudioPlayer?.playAudioWDelay()
            browDown = false
        }
        if(browUp){
            DLAudioPlayer?.playAudioWDelay()
            browUp = false
        }
        if(smile){
            BGAudioPlayer?.playAudioWDelay()
            smile = false
        }
        if(cheekPuff){
            BGAudioPlayer?.playAudioWDelay()
            cheekPuff = false
        }
    }
    
    
}

