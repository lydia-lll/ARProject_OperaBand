//
//  MaskBtnView.swift
//  FaceMesh
//
//  Created by ldy on 4/25/23.
//  Copyright © 2023 AppCoda. All rights reserved.
//
import SwiftUI
private struct MaskBtn: View{
    @State private var maskIntro: MaskIntroShow = .Default
    @EnvironmentObject var faceARModel: FaceARModel
    var body: some View{
           ZStack{
                //VStack{
                    //Spacer()
//                    HStack{
                        if faceARModel.maskNum == 0 {
                            Button(action: {self.maskIntro = .Sheng},
                                   label: {Image(uiImage: #imageLiteral(resourceName: "SM.png")).resizable().frame(width: 35,height: 35)})
                        }
                        else if faceARModel.maskNum == 1 {
                            Button(action: {self.maskIntro = .Dan},
                                   label: {Image(uiImage: #imageLiteral(resourceName: "DM.png")).resizable().frame(width: 35,height: 35)})
                        }
                        else if faceARModel.maskNum == 2 {
                            Button(action: {self.maskIntro = .Jing},
                                   label: {Image(uiImage: #imageLiteral(resourceName: "JM.png")).resizable().frame(width: 35,height: 35)})
                        }
                        else if faceARModel.maskNum == 3 {
                            Button(action: {self.maskIntro = .Chou},
                                   label: {Image(uiImage: #imageLiteral(resourceName: "CM.png")).resizable().frame(width: 35,height: 35)})
                        }
                        else {
                            Button(action: {}, label: {Image(systemName: "nosign.app").imageScale(.large).frame(width: 35,height: 35)})
                        }
               HStack{
                   Spacer()
                   switch self.maskIntro {
                   case .Sheng:
                       MaskIntroBox(introShow: $maskIntro, introContent: "Sheng")
                   case .Dan:
                       MaskIntroBox(introShow: $maskIntro, introContent: "Dan")
                   case .Jing:
                       MaskIntroBox(introShow: $maskIntro, introContent: "Jing")
                   case .Chou:
                       MaskIntroBox(introShow: $maskIntro, introContent: "Chou")
                   case .Default:
                       Text("")
                   }
               }
//                    }
                //}
         }
    }
}

struct MaskIntroBox: View{
    @Binding var introShow: MaskIntroShow
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
//        VStack(alignment: .center){
//            Text(introContent)
//            Button("dismiss"){
//                introShow = .Default
//            }
//        }
//        .frame(width: 200, height: 200)
//        .background(Color.secondary.colorInvert())
//        .cornerRadius(20)
    }
}

