//
//  MaskIntroView.swift
//  FaceMesh
//
//  Created by ldy on 4/25/23.
//  Copyright © 2023 AppCoda. All rights reserved.
//

import SwiftUI

struct MaskSheetView: View {
    var body: some View {
        NavigationView {
            List{
                Section{
                    Text("Sheng, Dan, Jing and Chou are the four major roles of Chinese opera. According to different identity, temperament and character of the characters, each role has fixed makeup, costumes and stage movements.")
                }
                Section("Sheng/生"){
                    HStack{
                        VStack{
                            Image("SM")
                        }
                        Text("Sheng is the male role in Peking Opera. This role has several subtypes according to the character’s age, personality and status, including Laosheng (Senior Male Role), Wusheng (Acrobatic Male Role), etc.")
                    }
                }
                Section("Dan/旦"){
                    HStack{
                        VStack{
                            Image("DM")
                        }
                        Text("Dan is the term for female roles in Peking Opera. Dan can be a traditional wife image (Qingyi/青衣), or a stronger, more forceful character like a brave warrior image (Daomadan/刀马旦), etc.")
                    }
                }
                Section("Jing/净"){
                    HStack{
                        VStack{
                            Image("JM")
                        }
                        Text("Sheng is the male role in Peking Opera. This role has several subtypes according to the character’s age, personality and status, including Laosheng (Senior Male Role), Wusheng (Acrobatic Male Role), etc.")
                    }
                }
                Section("Chou/丑"){
                    HStack{
                        VStack{
                            Image("SM")
                        }
                        Text("A Jing role is a prominent male character with high social position. They can be either positive or negative characters. As they always come with painted face, people can tell the role’s characteristic from his face color.")
                    }
                }
            }.navigationTitle("The Four Roles")
        }
    }
}
