//
//  ContentView.swift
//  FaceMesh
//
//  Created by jht2 on 3/1/23.
//

import SwiftUI

struct ContentView: View {
    @State var analysis: String = ""
//    @State var smile: Bool = false
    
    var body: some View {
        VStack {
            Text(analysis).frame(height: 40)
//            BridgeView(analysis: $analysis, smile: $smile)
            BridgeView(analysis: $analysis)
        }
        //.padding()
    }
}

struct BridgeView: UIViewControllerRepresentable {
    @Binding var analysis: String
//    @Binding var smile: Bool

    func makeUIViewController(context: Context) -> some UIViewController {
        let viewCtl = ViewController()
        
        print("BridgeView viewCtl", viewCtl)

        viewCtl.reportChange = {
            // print("reportChange")
            analysis = viewCtl.analysis
//            smile = viewCtl.smile
        }
        return viewCtl
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // print("BridgeView updateUIViewController")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
