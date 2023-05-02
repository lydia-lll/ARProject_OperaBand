//
//  RecordBtnView.swift
//  FaceMesh
//
//  Created by ldy on 4/25/23.
//  Copyright © 2023 AppCoda. All rights reserved.
//

import SwiftUI
import AVFoundation

struct RecordBtn: View{
    @EnvironmentObject var audioRecorder: AudioRecorder
    var body: some View{
        VStack{
            if audioRecorder.recording == false {
                Button(action: {self.audioRecorder.startRecording()}) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipped()
                        .foregroundColor(.red)
                        .padding(.bottom, 40)
                }
            } else {
                Button(action: {self.audioRecorder.stopRecording()}) {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipped()
                        .foregroundColor(.red)
                        .padding(.bottom, 40)
                }
            }
        }
    }
}

struct DismissBtn: View{
    @Binding var isPresented: Bool
    
    var body: some View{
        Button("dismiss"){
            isPresented = false
        }
    }
}


