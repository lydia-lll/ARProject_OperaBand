//
//  MaskRecordView.swift
//  FaceMesh
//
//  Created by ldy on 4/25/23.
//  Copyright © 2023 AppCoda. All rights reserved.
//

import SwiftUI


enum MaskIntroShow{
    case Default, Sheng, Dan, Jing, Chou
}

struct MaskRecordView: View {
    @State private var showingList = false
    @State private var showingMaskIntro = false
    @State private var showingHelp = true
    @State var maskIntro: MaskIntroShow = .Default
    @EnvironmentObject var faceARModel: FaceARModel
    @EnvironmentObject var audioRecorder: AudioRecorder
    var body: some View {
                        ZStack{
                            HStack{
                                if faceARModel.maskNum == 0 {
                                    Button(action: {showingMaskIntro = true},
                                           label: {Image(uiImage: #imageLiteral(resourceName: "SM.png")).resizable().frame(width: 35,height: 35)})
                                }
                                else if faceARModel.maskNum == 1 {
                                    Button(action: {showingMaskIntro = true},
                                           label: {Image(uiImage: #imageLiteral(resourceName: "DM.png")).resizable().frame(width: 35,height: 35)})
                                }
                                else if faceARModel.maskNum == 2 {
                                    Button(action: {showingMaskIntro = true},
                                           label: {Image(uiImage: #imageLiteral(resourceName: "JM.png")).resizable().frame(width: 35,height: 35)})
                                }
                                else if faceARModel.maskNum == 3 {
                                    Button(action: {showingMaskIntro = true},
                                           label: {Image(uiImage: #imageLiteral(resourceName: "CM.png")).resizable().frame(width: 35,height: 35)})
                                }
                                else {
                                    Button(action: {showingMaskIntro = true}, label: {Image(systemName: "nosign.app").imageScale(.large).frame(width: 35,height: 35)})
                                }
                                Spacer()
                                Button{
                                    showingList = true
                                }label: {
                                    Image(systemName: "list.bullet")
                                        .imageScale(.large)
                                        .frame(width: 30, height: 30)
                                        .padding()
                                }
                                Button{
                                    showingHelp = true
                                }label: {
                                    Image(systemName: "info.circle")
                                        .imageScale(.large)
                                        .frame(width: 30, height: 30)
                                        .padding()
                                }
                                
                            }
                            .padding()
                            RecordBtn()
                        }
                        .sheet(isPresented: $showingList){
                            NavigationView{
                                VStack{
                                    DismissBtn(isPresented: $showingList)
                                    RecordingsList(audioRecorder: audioRecorder)
                                }
                            }
                            .navigationBarTitle("Voice List")
                            .navigationBarItems(trailing: EditButton())
                        }
                        .sheet(isPresented: $showingMaskIntro){
                            DismissBtn(isPresented: $showingMaskIntro)
                            MaskSheetView()
                        }
                        .sheet(isPresented: $showingHelp){
                            DismissBtn(isPresented: $showingHelp)
                            InstructionView()
                        }
    }
}

