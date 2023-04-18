//
//  AudioIconView.swift
//  FaceBandPreview
//
//  Created by ldy on 4/14/23.
//

import SwiftUI

public enum IntroShow{
    case Default, Naobo, Daluo, Xiaoluo, Gu, Ban
}

public struct AudioIconView: View {
    @State public var DLbox = false
    @State public var introShow: IntroShow = .Default
    @Binding public var nowPlaying: [String:Bool]
    public var body: some View {
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

public struct introBox: View{
    @Binding public var introShow: IntroShow
    public var introContent:String
    public var body: some View{
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
