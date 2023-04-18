import SwiftUI
import ARKit
import SceneKit
import PlaygroundSupport

struct ContentView: View {
    @State var analysis: String = ""
    @State var orientation: String = ""
    @State var nowPlaying: [String:Bool] = [:]
    @State var arview = ARSCNView()
    @State var headUp = false
    
    @EnvironmentObject var audioRecorder: AudioRecorder
    @State private var showingList = false
    @State private var showingRecord = false
    
    var body: some View {
        ZStack{
            VStack {
//                Text(orientation).frame(height: 40)
                FaceARView(analysis: $analysis, orientation: $orientation, nowPlaying: $nowPlaying, headUp: $headUp, view: arview)
                
            }
            VStack{
                AudioIconView(nowPlaying: $nowPlaying)
                HStack{
                    RecordBtn()
                    Button{
                        showingList = true
                    }label: {
                        Image(systemName: "list.bullet")
                            .imageScale(.large)
                            .frame(width: 60, height: 60)
                    }
//                    Button("Show Recordings"){
//                        showingList = true
//                    }
                }
                .sheet(isPresented: $showingList){
                    NavigationView{
                        VStack{
                            DismissBtn(isPresented: $showingList)
                            RecordingsList(audioRecorder: audioRecorder)
                        }
                    }
                    .navigationBarTitle("Voice List")
                    .navigationBarItems(trailing: EditButton())
                }
            }
        }
    }
}

struct RecordBtn: View{
    @EnvironmentObject var audioRecorder: AudioRecorder
    var body: some View{
        VStack{
            if audioRecorder.recording == false {
                Button(action: {self.audioRecorder.startRecording()}) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipped()
                        .foregroundColor(.red)
                        .padding(.bottom, 40)
                }
            } else {
                Button(action: {self.audioRecorder.stopRecording()}) {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipped()
                        .foregroundColor(.red)
                        .padding(.bottom, 40)
                }
            }
        }
    }
}

struct DismissBtn: View{
    @Binding var isPresented: Bool

    var body: some View{
        Button("dismiss"){
            isPresented = false
        }
    }
}

