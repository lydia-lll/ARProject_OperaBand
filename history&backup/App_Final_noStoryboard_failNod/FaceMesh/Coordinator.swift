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
import SwiftUI


class Coordinator: NSObject, ARSessionDelegate, ARSCNViewDelegate {

    var sceneView: ARSCNView
    var headUp = false
    var headDown = false
    var analysis = ""
    var nowPlaying = ["DL":false, "XL":false, "NB":false, "Ban":false,"Gu":false]
    var faceOrientation = ""
    var reportChange: (() -> Void)!
    var maskNum = 0
    
    var audioModel = AudioModel()
    var DLAudioPlayer: AudioPlayerModel?
    var BanAudioPlayer: AudioPlayerModel?
    var GuAudioPlayer: AudioPlayerModel?
    var XLAudioPlayer: AudioPlayerModel?
    var NBAudioPlayer: AudioPlayerModel?
    
    var eyeDown = false
    var eyeUp = false
    var browDown = false
    var browUp = false
    var smile = false
    var cheekPuff = false
    
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
        // Run the view's session
//        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
        sceneView.session.delegate = self
        self.sceneView.session.run(configuration)
        // initialize audio players
        NBAudioPlayer = AudioPlayerModel(soundAssets: audioModel.BLbundleAudio, pitch: 0, volume: 0, speed: 0)
        XLAudioPlayer = AudioPlayerModel(soundAssets: audioModel.BLbundleAudio, pitch: 0, volume: 0, speed: 0)
        DLAudioPlayer = AudioPlayerModel(soundAssets: audioModel.DLbundleAudio, pitch: 0, volume: 0, speed: 0)
        BanAudioPlayer = AudioPlayerModel(soundAssets: audioModel.BGbundleAudio, pitch: 0, volume: 1, speed: 0)
        GuAudioPlayer = AudioPlayerModel(soundAssets: audioModel.BGbundleAudio, pitch: 0, volume: 1, speed: 0)
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
            
            // Call updateMaterial(for:) whenever the face nodding threshold is met
                    let nodThreshold: Float = 0.8
                    let nodAngle = faceAnchor.transform.columns.0.x

                    if nodAngle > nodThreshold || nodAngle < -nodThreshold {
                        updateMaterial(for: faceAnchor)
                    }


            //detect facial expressions
            DispatchQueue.main.async {
                self.expression(anchor: faceAnchor)
            }
            //map expressions to sounds
            DispatchQueue.main.async {
                self.audioPlay()
                self.updateIcon()
            }


            DispatchQueue.main.async {
                // Report changes to SwiftUI code
                self.reportChange()
            }
        }
        
    }
//    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
//            if let faceAnchor = session.currentFrame?.anchors.first as? ARFaceAnchor {
//                // check if the face anchor is valid
//                if faceAnchor.isTracked {
//                    // face is still in the camera frame
//                    faceDetected = true
//                    print("face")
//                } else {
//                    // face is not in the camera frame
//                    faceDetected = false
//                    print("no face..")
//                }
//            }
//        }
    
//    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
//        guard anchor is ARFaceAnchor else { return }
//        print("no face detected?")
//    }
//    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        guard let faceAnchor = self.sceneView.session.currentFrame?.anchors.first(where: { $0 is ARFaceAnchor }) as? ARFaceAnchor else {
//            // No face detected
//            self.faceDetected = false
//            print("no face!!")
//            return
//        }
//        // Face detected
////        self.faceDetected = true
//    }
    
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
        if browInnerUp?.decimalValue ?? 0.0 > 0.08{
            if browInnerUp?.decimalValue ?? 0.0 > 0.2{
                self.analysis += "your brow is really high"
                self.DLAudioPlayer?.soundIndex = 1
                self.DLAudioPlayer?.volume = (browInnerUp?.floatValue ?? 0.0) - 0.17
                self.browUp = true;
            }else{
                self.analysis += "browInnerUp"
                self.DLAudioPlayer?.soundIndex = 0
                self.DLAudioPlayer?.volume = (browInnerUp?.floatValue ?? 0.0) - 0.08
                self.browUp = true;
            }
        }
        
        if ((smileLeft?.decimalValue ?? 0.0) + (smileRight?.decimalValue ?? 0.0)) > 0.9 {
            self.analysis += "You are smiling. "
            self.BanAudioPlayer?.soundIndex = 0
            self.smile = true
        }
        
        if cheekPuff?.decimalValue ?? 0.0 > 0.1 {
            self.analysis += "Your cheeks are puffed. "
            self.GuAudioPlayer?.soundIndex = 1
            self.cheekPuff = true
        }
        
        
        if jawOpen?.decimalValue ?? 0.0 > 0.1{
            self.analysis += "jawOpen"
        }
        
    }
    
    func updateIcon(){
        if(DLAudioPlayer!.isPlaying){
            self.nowPlaying["DL"] = true
        }else{
            self.nowPlaying["DL"] = false
        }
        
        if(NBAudioPlayer!.isPlaying){
            self.nowPlaying["NB"] = true
        }else{
            self.nowPlaying["NB"] = false
        }
        if(BanAudioPlayer!.isPlaying){
            self.nowPlaying["Ban"] = true
        }else{
            self.nowPlaying["Ban"] = false
        }
        if(GuAudioPlayer!.isPlaying){
            self.nowPlaying["Gu"] = true
        }else{
            self.nowPlaying["Gu"] = false
        }
        
        if(XLAudioPlayer!.isPlaying){
            self.nowPlaying["XL"] = true
        }else{
            self.nowPlaying["XL"] = false
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
            BanAudioPlayer?.playAudioWDelay()
            smile = false
        }
        if(cheekPuff){
            GuAudioPlayer?.playAudioWDelay()
            cheekPuff = false
        }
    }
    
    func facePos(){
        while self.headDown{
            if self.headUp{
                self.maskNum = (self.maskNum+1)%4
                self.headUp = false
                self.headDown = false
                self.faceOrientation = ""
            }
        }
    }
    
    func chooseMask() -> String{
        self.maskNum = (self.maskNum+1)%4
        let faceMask = ["faceMask0","wireframeTexture","faceMask0","wireframeTexture"]
        return faceMask[self.maskNum]
    }
    func updateMaterial(for faceAnchor: ARFaceAnchor) {
        let nodThreshold: Float = 0.8
        let nodAngle = faceAnchor.transform.columns.0.x

        if nodAngle > nodThreshold {
            // Nodding up
            maskNum = (maskNum + 1) % 2
        } else if nodAngle < -nodThreshold {
            // Nodding down
            maskNum = (maskNum + 2) % 2
        }

        let material = sceneView.node(for: faceAnchor)?.geometry?.firstMaterial

        switch maskNum {
        case 0:
            material?.diffuse.contents = UIImage(named: "faceMask0")
        case 1:
            material?.diffuse.contents = UIImage(named: "wireframeTexture")
        default:
            break
        }
    }
    
}

