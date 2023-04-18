//
//  FaceARView.swift
//  FaceMesh
//
//  Created by ldy on 4/16/23.
//  Copyright © 2023 AppCoda. All rights reserved.
//

import SwiftUI
import ARKit
import SceneKit

struct FaceARView: UIViewRepresentable {
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
//struct FaceARView_Previews: PreviewProvider {
//    static var previews: some View {
//        FaceARView()
//    }
//}
