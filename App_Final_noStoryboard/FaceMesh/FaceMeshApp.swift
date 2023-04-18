//
//  FaceMeshApp.swift
//  FaceMesh
//
//  Created by jht2 on 3/1/23.
//

import SwiftUI

@main
struct FaceMeshApp: App {
    @StateObject var audioRecorder = AudioRecorder()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(audioRecorder)
        }
    }
}
