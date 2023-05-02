//
//  FaceARModel.swift
//  FaceMesh
//
//  Created by ldy on 4/25/23.
//  Copyright © 2023 AppCoda. All rights reserved.
//

import SwiftUI

class FaceARModel: ObservableObject{
    @Published var analysis = ""
    @Published var nowPlaying = ["DL":false, "XL":false, "NB":false, "Ban":false,"Gu":false]
    @Published var faceOrientation = ""
    @Published var maskNum = 0
    @Published var canChange = false
}

