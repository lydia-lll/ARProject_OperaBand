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
    @State var orientation: String = ""
    @State var nowPlaying: [String:Bool] = [:]
    @State var arview = ARSCNView()
    @State var headUp = false
    
    var body: some View {
        ZStack{
            VStack {
//                if headUp{
//                    Text(orientation).frame(height: 40)
//                }
                Text(orientation).frame(height: 40)
                CustomARView(analysis: $analysis, orientation: $orientation, nowPlaying: $nowPlaying, headUp: $headUp, view: arview)
                
            }
            AudioIconView(nowPlaying: $nowPlaying)
        }
        //.padding()
    }
}

struct CustomARView: UIViewRepresentable {
    typealias UIViewType = ARSCNView
    @Binding var analysis: String
    @Binding var orientation: String
    @Binding var nowPlaying: [String:Bool]
    @Binding var headUp: Bool
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
            orientation = cdr.faceOrientation
            headUp = cdr.headUp
        }
        return cdr
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
