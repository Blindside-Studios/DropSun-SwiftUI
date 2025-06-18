//
//  ContentView.swift
//  DropSun
//
//  Created by Nicolas Helbig on 18.06.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = SunViewModel()
    
    var body: some View {
        ZStack {
            
            Color.blue.ignoresSafeArea()
            
            SunView(position: viewModel.sunPosition, size: viewModel.sunSize)
            
            MouseTrackingView(viewModel: viewModel)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
