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


class Coordinator: NSObject, ARSessionDelegate, ARSCNViewDelegate{
    
    var sceneView: ARSCNView
    var headUp = false
    var headDown = false
    @ObservedObject var faceARModel: FaceARModel
    
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
    var eyeLeft = false
    var eyeRight = false
    
    var nowChange = false
    
    var timer = Timer()
    
    enum HeadState {
        case initial
        case up
        case down
    }
    
    
    var headState: HeadState = .initial
    var previousHeadState: HeadState? = nil
    var isNodded = false
    
    init(_ view: ARSCNView, faceARModel: FaceARModel){
        self.sceneView = view
        self.faceARModel = faceARModel
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
        
        material.diffuse.contents = UIImage(#imageLiteral(resourceName: "Sheng.png"))
        material.lightingModel = .physicallyBased
        
        let node = SCNNode(geometry: faceMesh)
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry {
            faceGeometry.update(from: faceAnchor.geometry)
            expression(anchor: faceAnchor)
            audioPlay()
            headNod(faceAnchor: faceAnchor, node: node)
            DispatchQueue.main.async() {
                self.updateIcon()
            }
            DispatchQueue.main.async() {
                if self.nowChange {
                    self.changeMask(faceGeometry: faceGeometry)
                    self.nowChange = false
                }
            }
            
        }
        
    }
    
    func changeMask(faceGeometry: ARSCNFaceGeometry){
        let num = (faceARModel.maskNum + 1) % 5
        let material = faceGeometry.firstMaterial!
        
        switch num {
        case 0:
            material.diffuse.contents = UIImage(named: "Sheng.png")
        case 1:
            material.diffuse.contents = UIImage(named: "Dan.png")
        case 2:
            material.diffuse.contents = UIImage(named: "Jing.png")
        case 3:
            material.diffuse.contents = UIImage(named: "Chou.png")
        case 4:
            //material.transparency = 0.0
            material.diffuse.contents = UIImage(named:"Blank.png")
        default:
            break
        }
        faceARModel.maskNum = num
    }
    
    func headNod(faceAnchor: ARFaceAnchor,node: SCNNode){
        if faceAnchor.lookAtPoint.y <= 0.06 {
            headState = .up
            print("A head is Up")
        }
        
        else if node.orientation.x >= Float.pi/32 {
            headState = .down
            print("A head is down")
        }
        else if (faceAnchor.lookAtPoint.y <= 0.06) && (node.orientation.x >= Float.pi/32){
            headState = .initial
        }
        
        if (headState == .down && previousHeadState == .up && !isNodded) {
            // The head first went up and then down
            if(faceAnchor.lookAtPoint.y >= 0.062){
                print("Head nod detected!")
                // Perform the action in response to this event
                self.nowChange = true
                // Set the flag to true to indicate the action has been performed
                isNodded = true
            }
        } else if (headState == .up && previousHeadState == .down) {
            // The head first went down and then up
            // Reset the flag to false to allow the action to be performed again
            if (faceAnchor.lookAtPoint.y <= 0.05){
                isNodded = false
            }
        }
        previousHeadState = headState
    }
    
    func expression(anchor: ARFaceAnchor) {
        let leftEyeDown = anchor.blendShapes[.eyeLookDownLeft]
        let rightEyeDown = anchor.blendShapes[.eyeLookDownRight]
        let leftEyeUp = anchor.blendShapes[.eyeLookUpLeft]
        let rightEyeUp = anchor.blendShapes[.eyeLookUpRight]
        
        let smileLeft = anchor.blendShapes[.mouthSmileLeft]
        let smileRight = anchor.blendShapes[.mouthSmileRight]
        let cheekPuff = anchor.blendShapes[.cheekPuff]
        
       // let jawOpen = anchor.blendShapes[.jawOpen]
        
        let browDownLeft = anchor.blendShapes[.browDownLeft]
        let browDownRight = anchor.blendShapes[.browDownRight]
        let browInnerUp = anchor.blendShapes[.browInnerUp]
        
        if ((leftEyeDown?.decimalValue ?? 0.0) + (rightEyeDown?.decimalValue ?? 0.0)) > 0.7 {
            self.XLAudioPlayer?.volume = (leftEyeDown?.floatValue ?? 0.0) + (rightEyeDown?.floatValue ?? 0.0) - 0.5
            self.XLAudioPlayer?.soundIndex = 0
            self.eyeDown = true
        }
        if ((leftEyeUp?.decimalValue ?? 0.0) + (rightEyeUp?.decimalValue ?? 0.0)) > 0.82 {
            self.NBAudioPlayer?.volume = (leftEyeUp?.floatValue ?? 0.0) + (rightEyeUp?.floatValue ?? 0.0) - 0.82
            self.NBAudioPlayer?.soundIndex = 1
            self.eyeUp = true
        }
        
        if ((browDownLeft?.decimalValue ?? 0.0) + (browDownRight?.decimalValue ?? 0.0)) > 0.82 {
            self.DLAudioPlayer?.soundIndex = 2
            self.DLAudioPlayer?.volume = (browDownLeft?.floatValue ?? 0.0) + (browDownRight?.floatValue ?? 0.0) - 0.82
            self.browDown = true;
            
        }
        if browInnerUp?.decimalValue ?? 0.0 > 0.08{
            if browInnerUp?.decimalValue ?? 0.0 > 0.2{
                self.DLAudioPlayer?.soundIndex = 1
                self.DLAudioPlayer?.volume = (browInnerUp?.floatValue ?? 0.0) - 0.17
                self.browUp = true;
            }else{
                self.DLAudioPlayer?.soundIndex = 0
                self.DLAudioPlayer?.volume = (browInnerUp?.floatValue ?? 0.0) - 0.08
                self.browUp = true;
            }
        }
        
        if ((smileLeft?.decimalValue ?? 0.0) + (smileRight?.decimalValue ?? 0.0)) > 0.9 {
            self.BanAudioPlayer?.soundIndex = 0
            self.BanAudioPlayer?.volume = ((smileLeft?.floatValue ?? 0.0) + (smileRight?.floatValue ?? 0.0)) - 0.8
            self.smile = true
        }
        
        if cheekPuff?.decimalValue ?? 0.0 > 0.1 {
            self.GuAudioPlayer?.soundIndex = 1
            self.BanAudioPlayer?.volume = (cheekPuff?.floatValue ?? 0.0) - 0.08
            self.cheekPuff = true
        }
        
        
        //        if jawOpen?.decimalValue ?? 0.0 > 0.1{
        //            faceARModel.analysis += "jawOpen"
        //        }
        
    }
    
    func updateIcon(){
        faceARModel.faceOrientation = ""
        if(DLAudioPlayer!.isPlaying){
            faceARModel.nowPlaying["DL"] = true
            print("DL Playing")
            print(faceARModel.nowPlaying["DL"])
        }else{
            faceARModel.nowPlaying["DL"] = false
        }
        
        if(NBAudioPlayer!.isPlaying){
            faceARModel.nowPlaying["NB"] = true
        }else{
            faceARModel.nowPlaying["NB"] = false
        }
        if(BanAudioPlayer!.isPlaying){
            faceARModel.nowPlaying["Ban"] = true
            print("Ban Playing")
            faceARModel.faceOrientation += "Ban Playing"
        }else{
            faceARModel.nowPlaying["Ban"] = false
        }
        if(GuAudioPlayer!.isPlaying){
            faceARModel.nowPlaying["Gu"] = true
        }else{
            faceARModel.nowPlaying["Gu"] = false
        }
        
        if(XLAudioPlayer!.isPlaying){
            faceARModel.nowPlaying["XL"] = true
        }else{
            faceARModel.nowPlaying["XL"] = false
        }
    }
    
    func audioPlay(){
        if (headState == previousHeadState && !isNodded) {
            if(eyeDown && !nowChange){
                XLAudioPlayer?.playAudioWDelay()
                eyeDown = false
            }
            if(eyeUp && !nowChange){
                NBAudioPlayer?.playAudioWDelay()
                eyeUp = false
            }
            if(browDown && !nowChange){
                DLAudioPlayer?.playAudioWDelay()
                browDown = false
            }
            if(browUp && !nowChange){
                DLAudioPlayer?.playAudioWDelay()
                browUp = false
            }
            if(smile && !nowChange){
                BanAudioPlayer?.playAudioWDelay()
                smile = false
            }
            if(cheekPuff && !nowChange){
                GuAudioPlayer?.playAudioWDelay()
                cheekPuff = false
            }
        }
    }
    
    
}

