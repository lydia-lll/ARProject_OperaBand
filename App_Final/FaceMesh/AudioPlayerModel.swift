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
    var soundAssets: [String] = []
    var soundIndex = 0
    var pitch: Float
    var volume: Float
    var speed: Float
//    var audioModel: AudioModel
    var player: AVAudioPlayer? = nil
    var isPlaying = false
    init(soundAssets: [String],pitch: Float, volume: Float, speed: Float){
        self.soundAssets = soundAssets
        self.pitch = pitch
        self.volume = volume
        self.speed = speed
//        self.audioModel = AudioModel
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
        self.player = loadBundleAudio(self.soundAssets[soundIndex])
        print("player", player as Any)
        // Loop indefinitely
        self.player?.numberOfLoops = 0
        self.player?.volume = volume
        self.player?.play()
        print(player?.isPlaying)
        print("it should play sth")
    }
    func playAudioWDelay(){
        if(!isPlaying){
            self.player = loadBundleAudio(self.soundAssets[soundIndex])
            print("player", player as Any)
            // Loop indefinitely
            self.player?.numberOfLoops = 0
            self.player?.volume = volume
            self.player?.play()
            print(player?.isPlaying)
            print("it should play sth")
            self.isPlaying = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                //call any function
                print("stopped")
                self.isPlaying = false
            }
        }
    }
}
