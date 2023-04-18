//
//  AudioPlayerModel.swift
//  FaceMesh
//
//  Created by ldy on 4/12/23.
//  Copyright © 2023 AppCoda. All rights reserved.
//

import Foundation
import AVFoundation

public class AudioPlayerModel{
    var soundAssets: [String] = []
    var soundIndex = 0
    var pitch: Float
    var volume: Float
    var speed: Float
//    var audioModel: AudioModel
    var player: AVAudioPlayer? = nil
    var isPlaying = false
    public init(soundAssets: [String],pitch: Float, volume: Float, speed: Float){
        self.soundAssets = soundAssets
        self.pitch = pitch
        self.volume = volume
        self.speed = speed
//        self.audioModel = AudioModel
    }
    
    public func loadBundleAudio(_ fileName:String) -> AVAudioPlayer? {
        var path = Bundle.main.path(forResource: fileName, ofType:nil)!
        var url = URL(fileURLWithPath: path)
        do {
            return try AVAudioPlayer(contentsOf: url)
        } catch {
            print("loadBundleAudio error", error)
        }
        return nil
    }
    public func playAudio(){
        self.player = loadBundleAudio(self.soundAssets[soundIndex])
        print("player", player as Any)
        // Loop indefinitely
        self.player?.numberOfLoops = 0
        self.player?.volume = volume
        self.player?.play()
        print(player?.isPlaying)
        print("it should play sth")
    }
    public func playAudioWDelay(delay: Double = 0.7){
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
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                //call any function
                print("stopped")
                self.isPlaying = false
            }
        }
    }
}
