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
    //    @Binding var nowPlaying: [String:Bool]
    @EnvironmentObject var faceARModel: FaceARModel
    var body: some View {
        GeometryReader{ geometry in
            ZStack(alignment: .center){
                VStack(alignment: .center){
                    HStack{
                        Button(action: {
                            self.introShow = .Naobo
                        }){
                            Image("Naobo")
                                .foregroundColor(faceARModel.nowPlaying["NB"] ?? false ? Color.yellow : Color.primary)
                        }
                        Spacer()
                        Button(action: {
                            self.introShow = .Xiaoluo
                        }){
                            Image("Xiaoluo")
                                .foregroundColor(faceARModel.nowPlaying["XL"] ?? false ? Color.yellow : Color.primary)
                        }
                        Spacer()
                        Button(action: {
                            self.introShow = .Daluo
                        }){
                            Image("Daluo")
                                .foregroundColor(faceARModel.nowPlaying["DL"] ?? false ? Color.yellow : Color.primary)
                        }
                        Spacer()
                        Button(action: {
                            self.introShow = .Ban
                        }){
                            Image("Ban")
                                .foregroundColor(faceARModel.nowPlaying["Ban"] ?? false ? Color.yellow : Color.primary)
                        }
                        Spacer()
                        Button(action: {
                            self.introShow = .Gu
                        }){
                            Image("Gu")
                                .foregroundColor(faceARModel.nowPlaying["Gu"] ?? false ? Color.yellow : Color.primary)
                        }
                    }.padding()
                    HStack(alignment: .center){
                        switch self.introShow {
                        case .Naobo:
                            introBox(introShow: $introShow,introTitle: "Cymbals (NaoBo)",introContent: "Cymbals are a pair of metal discs with a cymbal scarf tied to the center of each one. It is usually used at the climax of the music. Cymbal sounds can either create a loud hurricane-like effect or somulate the gentle sound of water", imgName: "B")
                        case .Daluo:
                            introBox(introShow: $introShow,introTitle: "Large Gong", introContent: "A metal body-sounding instrument with no fixed pitch. Its sound is low, bright, and strong, with a long and lasting aftertone. Usually used to express a tense atmosphere and ominous omen", imgName: "DL")
                        case .Xiaoluo:
                            introBox(introShow: $introShow,introTitle: "Small Gong", introContent: "Small Gong has a bright, crisp tone. Highlighting timbral characteristics; it also strikes an  unique pattern to enrich the effect of the ensemble.", imgName: "XL")
                        case .Gu:
                            introBox(introShow: $introShow,introTitle: "Drum (Ban Gu)", introContent: "When struck by one or two small bamboo sticks, it creates a sharp dry sound essential to the aesthetics of Chinese opera. Striking the drum in different places produces different sounds", imgName: "JG")
                        case .Ban:
                            introBox(introShow: $introShow,introTitle: "Clappers (Tan Ban)", introContent: "Traditional Chinese clappers consist of multiple rectangular rosewood boards. It’s usually used for instrumental ensembles or opera accompaniment, playing a role in strengthening the rhythm", imgName: "TB")
                        case .Default:
                            Text("")
                        }
                    }
                    Spacer()
                }
            }
        }
        
    }
}

struct introBox: View{
    @Binding var introShow: IntroShow
    var introTitle:String
    var introContent:String
    var imgName: String
    var body: some View{
        GeometryReader{ geometry in
            VStack{
                Text(introTitle)
                    .font(.largeTitle)
                HStack{
                    Image(imgName)
                        .resizable()
                        .frame(width: 100, height: 100)
                    Text(introContent)
                        .padding()
                }
                Button("dismiss"){
                    introShow = .Default
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height * 1/2)
            .background(Color.secondary.colorInvert())
            .cornerRadius(20)
            .transition(.slide)
        }
    }
}
