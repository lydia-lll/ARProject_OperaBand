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
//    var player: AVAudioPlayer? = nil
    var reportChange: (() -> Void)!
    var smile = false
//    var play = false
    var audioManager: AudioManager?
    
//    let urlSounds = [
//        "https://www.youraccompanist.com/images/stories/Reference%20Scales_On%20A%20Flat-G%20Sharp.mp3",
//        "https://www.youraccompanist.com/images/stories/Reference%20Scales_Pentatonic%20on%20F%20Sharp.mp3",
//        "https://www.youraccompanist.com/images/stories/Reference%20Scales_Chromatic%20Scale%20On%20F%20Sharp.mp3",
//    ]
//
//    func loadUrlAudio(_ urlString:String) -> AVAudioPlayer? {
//        let url = URL(string: urlString)
//        do {
//            let data = try Data(contentsOf: url!)
//            return try AVAudioPlayer(data: data)
//        } catch {
//            print("loadUrlSound error", error)
//        }
//        return nil
//    }
    
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
        let audioMananager = AudioManager()
        if let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry {
            faceGeometry.update(from: faceAnchor.geometry)
            expression(anchor: faceAnchor)
            audioMananager.playAudio()
            
            DispatchQueue.main.async {
                // Disable UIKit label in Main.storyboard
                // self.faceLabel.text = self.analysis
                // Report changes to SwiftUI code
                self.reportChange()
            }
            
        }
    }
    
    func expression(anchor: ARFaceAnchor) {
        let smileLeft = anchor.blendShapes[.mouthSmileLeft]
        let smileRight = anchor.blendShapes[.mouthSmileRight]
        let cheekPuff = anchor.blendShapes[.cheekPuff]
        let tongue = anchor.blendShapes[.tongueOut]
        let leftEyeBlink = anchor.blendShapes[.eyeBlinkLeft]
        self.analysis = ""
        
        if ((smileLeft?.decimalValue ?? 0.0) + (smileRight?.decimalValue ?? 0.0)) > 0.9 {
            self.analysis += "You are smiling. "
            self.smile = true;
//        }else{
//            self.smile = false;
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
    }
    
//    func playAudio(){
//        if (smile && !play){
//            self.player = loadUrlAudio(urlSounds[0])
//            print("player", player as Any)
//            // Loop indefinitely
//            self.player?.numberOfLoops = 0
//            self.player?.play()
//            self.play = true
//            print(player?.isPlaying)
//            print("it should play sth")
//        }
//        if(player?.isPlaying == false){
//            self.play = false
//            self.smile = false
//            print("stopped")
//        }
//    }
    
    
}

class AudioManager{
    var player: AVAudioPlayer? = nil
    var play = false
    var viewController: ViewController?
    
    let urlSounds = [
        "https://www.youraccompanist.com/images/stories/Reference%20Scales_On%20A%20Flat-G%20Sharp.mp3",
        "https://www.youraccompanist.com/images/stories/Reference%20Scales_Pentatonic%20on%20F%20Sharp.mp3",
        "https://www.youraccompanist.com/images/stories/Reference%20Scales_Chromatic%20Scale%20On%20F%20Sharp.mp3",
    ]
    func loadUrlAudio(_ urlString:String) -> AVAudioPlayer? {
        let url = URL(string: urlString)
        do {
            let data = try Data(contentsOf: url!)
            return try AVAudioPlayer(data: data)
        } catch {
            print("loadUrlSound error", error)
        }
        return nil
    }
    func playAudio(){
        let viewController = ViewController()
        if (viewController.smile && !play){
            self.player = loadUrlAudio(urlSounds[0])
            print("player", player as Any)
            // Loop indefinitely
            self.player?.numberOfLoops = 0
            self.player?.play()
            self.play = true
            print(player?.isPlaying)
            print("it should play sth")
        }
        if(player?.isPlaying == false){
            self.play = false
            viewController.smile = false
            print("stopped")
        }
    }
}
