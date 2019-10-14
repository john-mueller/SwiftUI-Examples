//
//  ContentView.swift
//  SwiftUI-Examples
//
//  Created by John Mueller on 10/14/19.
//  Copyright © 2019 John Mueller. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink("FlowLayoutDemo", destination: {
                    FlowLayoutDemo()
                        .navigationBarTitle("FlowLayoutDemo", displayMode: .inline)
                }())
                NavigationLink("VSliderDemo", destination: {
                    VSliderDemo()
                        .navigationBarTitle("VSliderDemo", displayMode: .inline)
                }())
                Spacer()
            }
            .padding()
            .navigationBarTitle("SwiftUI-Examples")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
