//
//  AudioIconView.swift
//  FaceBandPreview
//
//  Created by ldy on 4/14/23.
//

import SwiftUI

struct AudioIconView: View {
    @State var DLbox = false
    var body: some View {
        VStack{
            ZStack{
                VStack{
                    HStack{
                        AudioIconBtn(showBox: $DLbox, iconImg: "Naobo")
                            .sheet(isPresented: $DLbox){
                                introBox(isPresented: $DLbox)
                            }
                        Spacer()
//                        AudioIconBtn(iconImg: "Daluo")
//                        Spacer()
//                        AudioIconBtn(iconImg: "Xiaoluo")
//                        Spacer()
//                        AudioIconBtn(iconImg: "Gu")
//                        Spacer()
//                        AudioIconBtn(iconImg: "Ban")
                    }
                }
            }
            Spacer()
        }
    }
}

struct AudioIconBtn: View{
    @State private var didTap:Bool = false
    @Binding var showBox:Bool
    var iconImg: String
    var body: some View{
        Button(action: {
            self.didTap = !self.didTap
            self.showBox = true
        }){
            Image(iconImg)
                .foregroundColor(didTap ? Color.gray:Color.primary)
        }
    }
}

struct introBox: View{
    @Binding var isPresented: Bool
    var body: some View{
        Button("dismiss"){
            isPresented = false
        }
    }
}

struct AudioIconView_Previews: PreviewProvider {
    static var previews: some View {
        AudioIconView()
    }
}
