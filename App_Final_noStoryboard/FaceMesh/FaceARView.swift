import SwiftUI
import ARKit
import SceneKit
import AVFoundation
import Combine

struct FaceARView: UIViewRepresentable {
    typealias UIViewType = ARSCNView
    @EnvironmentObject var faceARModel: FaceARModel
    
    var view:ARSCNView
    
    func makeUIView(context: Context) -> ARSCNView {
        view.session.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ view: ARSCNView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        let cdr = Coordinator(self.view, faceARModel: faceARModel)
        return cdr
    }
}
