//
//  AudioPlayerModel.swift
//  FaceMesh
//
//  Created by ldy on 4/12/23.
//  Copyright © 2023 AppCoda. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayerModel{
    
    var audioModel: AudioModel
    var player: AVAudioPlayer? = nil
    init(audioModel: AudioModel){
        self.audioModel = audioModel
    }
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
    func playAudio(){
        let bundleAudio = self.audioModel.soundAssets
        self.player = loadBundleAudio(bundleAudio[0])
        print("player", player as Any)
        // Loop indefinitely
        self.player?.numberOfLoops = 0
        self.player?.play()
        print(player?.isPlaying)
        print("it should play sth")
        if(player?.isPlaying == false){
            print("stopped")
        }
    }
}
