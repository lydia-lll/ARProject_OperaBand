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


public class Coordinator: NSObject, ARSessionDelegate, ARSCNViewDelegate {
    
    public var sceneView: ARSCNView
    public var headUp = false
    public var headDown = false
    public var analysis = ""
    public var nowPlaying = ["DL":false, "XL":false, "NB":false, "Ban":false,"Gu":false]
    public var faceOrientation = ""
    public var reportChange: (() -> Void)!
    public var maskNum = 0
    
    public var audioModel = AudioModel()
    public var DLAudioPlayer: AudioPlayerModel?
    public var BanAudioPlayer: AudioPlayerModel?
    public var GuAudioPlayer: AudioPlayerModel?
    public var XLAudioPlayer: AudioPlayerModel?
    public var NBAudioPlayer: AudioPlayerModel?
    
    public var eyeDown = false
    public var eyeUp = false
    public var browDown = false
    public var browUp = false
    public var smile = false
    public var cheekPuff = false
    public var eyeLeft = false
    public var eyeRight = false
    
    public var timer = Timer()
    
    public enum HeadState {
        case initial
        case up
        case down
    }
    
    
    public var headState: HeadState = .initial
    public var previousHeadState: HeadState? = nil
    public var isNodded = false
    public var canChange = false
    
    public init(_ view: ARSCNView){
        self.sceneView = view
        super.init()
        guard ARFaceTrackingConfiguration.isSupported else {
            print("Face tracking is not supported on this device")
            return
            
        }
        // Create a session configuration
        public var configuration = ARFaceTrackingConfiguration()
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
    public func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        public var faceMesh = ARSCNFaceGeometry(device: sceneView.device!)!
        public var material = faceMesh.firstMaterial!
        
        material.diffuse.contents = UIImage(named: "faceMask0")
        material.lightingModel = .physicallyBased
        
        public var node = SCNNode(geometry: faceMesh)
        //        node.geometry?.firstMaterial?.fillMode = .lines
        return node
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if var faceAnchor = anchor as? ARFaceAnchor, var faceGeometry = node.geometry as? ARSCNFaceGeometry {
            faceGeometry.update(from: faceAnchor.geometry)
            
            
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
            
            DispatchQueue.main.async {
                // Report changes to SwiftUI code
                self.headNod(faceAnchor: faceAnchor, node: node)
            }
            
            if self.canChange {
                var material = faceGeometry.firstMaterial!
                material.diffuse.contents = UIImage(named: self.chooseMask())
                self.canChange = false
            }
            //            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] _ in
            //                if self.eyeLeft{
            //                    let material = faceGeometry.firstMaterial!
            //                    material.diffuse.contents = UIImage(named: self.chooseMask())
            //                    self.eyeLeft = false
            //                    print("do left")
            //                }
            //                })
            //            if self.eyeLeft {
            //                let material = faceGeometry.firstMaterial!
            //                material.diffuse.contents = UIImage(named: self.chooseMask())
            //                self.eyeLeft = false
            //                print("do left")
            //            }
        }
        
    }
    
    public func headNod(faceAnchor: ARFaceAnchor,node: SCNNode){
        if faceAnchor.lookAtPoint.y <= 0.07 {
            headState = .up
            print("A head is Up")
        }
        
        else if node.orientation.x >= Float.pi/30 {
            headState = .down
            print("A head is down")
        }
        
        if (headState == .down && previousHeadState == .up && !isNodded) {
            // The head first went up and then down
            print(headState,previousHeadState)
            self.faceOrientation = "Head nod detected"
            print("Head nod detected!")
            // Perform the action you want to do in response to this event
            self.canChange = true
            // Set the flag to true to indicate the action has been performed
            isNodded = true
        } else if (headState == .up && previousHeadState == .down) {
            // The head first went down and then up
            // Reset the flag to false to allow the action to be performed again
            isNodded = false
        }
        
        //            self.faceOrientation = ""
        previousHeadState = headState
    }
    
    public func expression(anchor: ARFaceAnchor) {
        public var leftEyeDown = anchor.blendShapes[.eyeLookDownLeft]
        public var rightEyeDown = anchor.blendShapes[.eyeLookDownRight]
        public var leftEyeUp = anchor.blendShapes[.eyeLookUpLeft]
        public var rightEyeUp = anchor.blendShapes[.eyeLookUpRight]
        
        public var smileLeft = anchor.blendShapes[.mouthSmileLeft]
        public var smileRight = anchor.blendShapes[.mouthSmileRight]
        public var cheekPuff = anchor.blendShapes[.cheekPuff]
        
        public var jawOpen = anchor.blendShapes[.jawOpen]
        
        public var browDownLeft = anchor.blendShapes[.browDownLeft]
        public var browDownRight = anchor.blendShapes[.browDownRight]
        public var browInnerUp = anchor.blendShapes[.browInnerUp]
        
        self.analysis = ""
        
        if(anchor.lookAtPoint.x > 0.1){
            self.eyeRight = true
        }
        if(anchor.lookAtPoint.x < -0.25){
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                self.eyeLeft = true
                print("left")
            }
//            self.eyeLeft = true
//            print("left")
        }
        
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
    
    public func updateIcon(){
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

    
    public func chooseMask() -> String{
        self.maskNum = (self.maskNum+1)%4
        public var faceMask = ["faceMask0","wireframeTexture","faceMask0","wireframeTexture"]
        return faceMask[self.maskNum]
    }

    
}

