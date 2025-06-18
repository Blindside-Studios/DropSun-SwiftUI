//
//  MouseTrackingView.swift
//  DropSun
//
//  Created by Nicolas Helbig on 18.06.25.
//

import AppKit
import SwiftUI

struct MouseTrackingView: NSViewRepresentable {
    @ObservedObject var viewModel: SunViewModel

    func makeNSView(context: Context) -> NSView {
        let view = TrackingNSView()
        view.onMouseMove = { point in
            DispatchQueue.main.async {
                let flippedY = view.bounds.height - point.y
                viewModel.pointerPosition = CGPoint(x: point.x, y: flippedY)
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

class TrackingNSView: NSView {
    var onMouseMove: ((CGPoint) -> Void)?

    override func updateTrackingAreas() {
        super.updateTrackingAreas()

        trackingAreas.forEach { removeTrackingArea($0) }

        let options: NSTrackingArea.Options = [
            .mouseMoved,
            .activeInKeyWindow,
            .inVisibleRect
        ]

        let trackingArea = NSTrackingArea(
            rect: self.bounds,
            options: options,
            owner: self,
            userInfo: nil
        )
        addTrackingArea(trackingArea)
    }

    override func mouseMoved(with event: NSEvent) {
        let localPoint = convert(event.locationInWindow, from: nil)
        onMouseMove?(localPoint)
    }
}
