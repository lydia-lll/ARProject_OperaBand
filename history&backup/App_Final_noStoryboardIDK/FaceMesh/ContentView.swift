//
//  ContentView.swift
//  FaceMesh
//
//  Created by jht2 on 3/1/23.
//

import SwiftUI
import ARKit
import SceneKit

struct ContentView: View {
    @State var analysis: String = ""
    @State var nowPlaying: [String:Bool] = [:]
    @State var arview = ARSCNView()
    
    var body: some View {
        ZStack{
            VStack {
                Text(analysis).frame(height: 40)
                CustomARView(analysis: $analysis, nowPlaying: $nowPlaying, view: arview)
    //            if(nowPlaying.DL){
    //                Text("DL")
    //            }
                
            }
            AudioIconView(nowPlaying: $nowPlaying)
        }
        //.padding()
    }
}

struct CustomARView: UIViewRepresentable {
    typealias UIViewType = ARSCNView
    @Binding var analysis: String
    @Binding var nowPlaying: [String:Bool]
    var view:ARSCNView
    
    func makeUIView(context: Context) -> ARSCNView {
        view.session.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ view: ARSCNView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        let cdr = Coordinator(self.view)
        cdr.reportChange = {
            analysis = cdr.analysis
            nowPlaying = cdr.nowPlaying
        }
        return cdr
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
