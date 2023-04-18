//
//  AudioIconView.swift
//  FaceMesh
//
//  Created by ldy on 4/16/23.
//  Copyright © 2023 AppCoda. All rights reserved.
//

import SwiftUI


enum IntroShow{
    case Default, Naobo, Daluo, Xiaoluo, Gu, Ban
}

struct AudioIconView: View {
    @State var DLbox = false
    @State var introShow: IntroShow = .Default
    @Binding var nowPlaying: [String:Bool]
    var body: some View {
        GeometryReader{ geometry in
            ZStack(alignment: .center){
                VStack(alignment: .center){
                    HStack(alignment: .center){
                        Spacer()
                        Button(action: {
                            self.introShow = .Naobo
                        }){
                            Image("Naobo")
                                .foregroundColor(self.nowPlaying["NB"] ?? false ? Color.yellow : Color.primary)
                        }
                        Button(action: {
                            self.introShow = .Naobo
                        }){
                            Image("Xiaoluo")
                                .foregroundColor(self.nowPlaying["XL"] ?? false ? Color.yellow : Color.primary)
                        }
                        Button(action: {
                            self.introShow = .Daluo
                        }){
                            Image("Daluo")
                                .foregroundColor(self.nowPlaying["DL"] ?? false ? Color.yellow : Color.primary)
                        }
                        Button(action: {
                            self.introShow = .Daluo
                        }){
                            Image("Ban")
                                .foregroundColor(self.nowPlaying["Ban"] ?? false ? Color.yellow : Color.primary)
                        }
                        Button(action: {
                            self.introShow = .Daluo
                        }){
                            Image("Gu")
                                .foregroundColor(self.nowPlaying["Guf"] ?? false ? Color.yellow : Color.primary)
                        }
                        Spacer()
                    }
                    HStack(alignment: .center){
                        switch self.introShow {
                        case .Default:
                            Text("")
                        case .Naobo:
                            introBox(introShow: $introShow, introContent: "Naobo")
                        case .Daluo:
                            introBox(introShow: $introShow, introContent: "Daluo")
                        case .Xiaoluo:
                            Text("")
                        case .Gu:
                            Text("")
                        case .Ban:
                            Text("")
                        }
                    }
            Spacer()
                }
            }
        }
            
        }
}

//struct AudioIconBtn: View{
//    @State private var didTap:Bool = false
//    @Binding var introShow: IntroShow
////    @Binding var showBox:Bool
//    var iconImg: String
//    var body: some View{
//        Button(action: {
//            self.didTap = !self.didTap
//            self.introShow = .Naobo
////            self.showBox = true
//        }){
//            Image(iconImg)
//                .foregroundColor(didTap ? Color.gray:Color.primary)
//        }
//    }
//}

struct introBox: View{
    @Binding var introShow: IntroShow
    var introContent:String
    var body: some View{
        GeometryReader{ geometry in
            VStack(alignment: .center){
                Text(introContent)
                Button("dismiss"){
                    introShow = .Default
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height * 2/5)
            .background(Color.secondary.colorInvert())
            .cornerRadius(20)
            .transition(.slide)
        }
    }
}
