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

public struct FaceARView: UIViewRepresentable {
    public typealias UIViewType = ARSCNView
    @Binding public var analysis: String
    @Binding public var orientation: String
    @Binding public var nowPlaying: [String:Bool]
    @Binding public var headUp: Bool
    public var view:ARSCNView! = nil
    
//    public init() {
//        _analysis = Binding(initialValue: analysis)
//        _orientation = Binding(initialValue: orientation)
//        _nowPlaying = Binding(initialValue: nowPlaying)
//        _headUp = Binding(initialValue: headUp)
//        self.analysis = analysis
//        self.orientation = orientation
//        self.nowPlaying = nowPlaying
//        self.headUp = headUp
//        self.view = view
//    }
    public func makeUIView(context: Context) -> ARSCNView {
        view.session.delegate = context.coordinator
        return view
    }
    
    public func updateUIView(_ view: ARSCNView, context: Context) {
    }
    
    public func makeCoordinator() -> Coordinator {
        public var cdr = Coordinator(self.view)
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
