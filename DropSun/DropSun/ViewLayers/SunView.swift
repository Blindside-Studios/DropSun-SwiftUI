//
//  SunView.swift
//  DropSun
//
//  Created by Nicolas Helbig on 18.06.25.
//

import SwiftUI

struct SunView: View {
    var position: CGPoint = .zero
    var size: Int = 150
    
    var body: some View {
        Circle()
            .fill(Color.yellow)
            .frame(width: 150, height: 150)
            .position(position)
            .shadow(radius: 10)
    }
}

#Preview {
    SunView()
}
