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
    @State var showToast = false
    @State var introShow: IntroShow = .Default
    var body: some View {
        VStack{
            ZStack{
                VStack{
                    HStack{
                        Button(action: {
                            withAnimation{
                                self.showToast.toggle()
                            }
//                            self.introShow = .Naobo
                        }){
                            Image("Naobo")
                                .foregroundColor(Color.primary)
                        }
                        Button(action: {
//                            self.introShow = .Daluo
                        }){
                            Image("Daluo")
                                .foregroundColor(Color.primary)
                        }
                        
                    }
                    .toast(isShowing: $showToast, text: Text("anything"))
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

struct Toast<Presenting>: View where Presenting: View {
    /// The binding that decides the appropriate drawing in the body.
    @Binding var isShowing: Bool
    /// The view that will be "presenting" this toast
    let presenting: () -> Presenting
    /// The text to show
    let text: Text

    var body: some View {

        GeometryReader { geometry in

            ZStack(alignment: .center) {

                self.presenting()
                    .blur(radius: self.isShowing ? 1 : 0)

                VStack {
                    self.text
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .transition(.slide)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
}

extension View {
    func toast(isShowing: Binding<Bool>, text: Text) -> some View {
        Toast(isShowing: isShowing,
              presenting: { self },
              text: text)
    }
}

struct AudioIconView_Previews: PreviewProvider {
    static var previews: some View {
        AudioIconView()
    }
}
