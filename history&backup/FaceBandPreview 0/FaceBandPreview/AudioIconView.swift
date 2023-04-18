//
//  AudioIconView.swift
//  FaceBandPreview
//
//  Created by ldy on 4/14/23.
//

import SwiftUI

enum IntroShow{
    case Default, Naobo, Daluo, Xiaoluo, Gu, Ban
}

struct AudioIconView: View {
    @State var DLbox = false
    @State var introShow: IntroShow = .Default
    var body: some View {
        VStack{
            ZStack{
                VStack{
                    HStack{
                        Button(action: {
                            self.introShow = .Naobo
                        }){
                            Image("Naobo")
                                .foregroundColor(Color.primary)
                        }
                        Button(action: {
                            self.introShow = .Daluo
                        }){
                            Image("Daluo")
                                .foregroundColor(Color.primary)
                        }
                        
                    }
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
            }
            Spacer()
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
        VStack{
            Text(introContent)
            Button("dismiss"){
                introShow = .Default
            }
        }
    }
}

struct AudioIconView_Previews: PreviewProvider {
    static var previews: some View {
        AudioIconView()
    }
}
