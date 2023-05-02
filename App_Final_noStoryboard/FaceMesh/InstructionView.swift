//
//  InstructionView.swift
//  FaceMesh
//
//  Created by ldy on 4/25/23.
//  Copyright © 2023 AppCoda. All rights reserved.
//

import SwiftUI

struct InstructionView: View {
    var body: some View {
        NavigationView{
            List{
                Section{
                    Text("Want to become a master of Peking opera percussion? With the app, you can make it with just the movements of your face! Here's how to get started:")
                }
                Section("Before It Starts"){
                    Text("Lift the phone to the level of your face and keep your eyes level")
                }
                Section("To Get the Music Playing:"){
                    HStack{
                        Text("To trigger different sounds, simply use your facial muscles in the following ways:")
                    }
                    HStack{
                        Text("-")
                        Image(systemName: "eyebrow")
                        Text("Raise or frown your eyebrows to play the sounds of large gongs")
                    }
                    HStack{
                        Text("-")
                        Image(systemName: "arrow.up")
                        Text("Look up to play the shimmering cymbals")
                    }
                    HStack{
                        Text("-")
                        Image(systemName: "arrow.down")
                        Text("Look down to play the small gongs")
                    }
                    HStack{
                        Text("-")
                        Image(systemName: "face.smiling")
                        Text("Smile to activate the playful clappers")
                    }
                    HStack{
                        Text("-")
                        Image(systemName: "arrow.left.and.right.circle")
                        Text("Puff your cheeks to bring the powerful sounds of the Peking opera drum")
                    }
                    HStack{
                        Text("The volume of each instrument will increase with the extent to which you twit your face")
                    }
                }
                Section("To save your musical masterpiece:"){
                    HStack{
                        Image(systemName: "circle.fill")
                            .foregroundColor(.red)
                        Text("Hit the record button to capture and save your composition")
                    }
                }
                Section("To learn more about the opera:"){
                    HStack{
                        VStack{
                            Image("Naobo")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Image("DM")
                                .resizable()
                                .frame(width: 15, height: 15)
                        }
                        Text("Hit the icons provided to access brief introductions to each instrument / role")
                    }
                }
                Section("Wanna get more immersive?"){
                    HStack{
                        Image(systemName: "arrow.up.and.down")
                        Text("Nod your head to switch between the four main roles of Peking opera.")
                    }
                    HStack{
                        Text("  *Note: the feature of switching different face filters is still in beta testing.")
                    }
                    HStack{
                        Text("If it's not working perfectly, make sure the phone is at the level of your face and slightly increase the nod")
                    }
                }
            }.navigationTitle("How To Start 💫")
        }
    }
}

