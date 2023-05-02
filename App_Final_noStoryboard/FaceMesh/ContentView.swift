//
//  ContentView.swift
//  FaceMesh
//
//  Created by jht2 on 3/1/23.
//

import SwiftUI
import ARKit
import SceneKit

import SwiftUI
import ARKit
import SceneKit
import AVFoundation
import Combine

struct ContentView: View {
    @State var arview = ARSCNView()
    @StateObject var faceARModel = FaceARModel()
    //    @EnvironmentObject var audioRecorder: AudioRecorder
    @State private var showingList = false
    @State private var showingRecord = false
    @StateObject var audioRecorder: AudioRecorder = AudioRecorder()
    
    var body: some View {
        ZStack{
            FaceARView(view: arview)
            Spacer()
            VStack{
                AudioIconView()
                Spacer()
                MaskRecordView()
            }
        }
        .environmentObject(audioRecorder)
        .environmentObject(faceARModel)
    }
}
