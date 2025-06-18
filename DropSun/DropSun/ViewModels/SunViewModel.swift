//
//  SunViewModel.swift
//  DropSun
//
//  Created by Nicolas Helbig on 18.06.25.
//

import Foundation
import SwiftUI
import simd

class SunViewModel: ObservableObject{
    @Published var sunPosition: CGPoint = .zero
    @Published var pointerEngaged: Bool = true
    @Published var pointerPosition: CGPoint = .zero{
        didSet{
            startPhysicsIfNeeded()
        }
    }
    @Published var sunSize: Int = 150
    
    var sunSpeed: simd_float2 = .zero
    var lastTranslation: simd_float2 = .zero
    
    let rubberBandingModifier: Float = 3.5
    let maxVectorDelta: Float = 10
    let trailingCoefficient: Float = 48
    var refreshRate: Float = 60
    
    
    private var timer: Timer?
    func startPhysicsIfNeeded(){
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / Double(refreshRate), repeats: true) { [weak self] _ in
            self?.calculateSunPosition()
        }
    }
    
    
    func calculateSunPosition(){
        let pointer: simd_float2 = simd_float2(x: Float(pointerPosition.x), y: Float(pointerPosition.y))
        let sun: simd_float2 = simd_float2(x: Float(sunPosition.x), y: Float(sunPosition.y))
        
        var direction: simd_float2 = .zero
        
        if pointerEngaged{
            direction = pointer - sun
            let scaledDirection = direction * (rubberBandingModifier / refreshRate)
            
            var deltaVector = scaledDirection - sunSpeed
            
            if (length(deltaVector) > (maxVectorDelta / refreshRate)){
                deltaVector = normalize(deltaVector) * (maxVectorDelta / refreshRate)
            }
            
            direction = sunSpeed + deltaVector
        }
        else{
            direction = sunSpeed * (trailingCoefficient / refreshRate)
        }
        
        let finalTranslation = CGPoint(
            x: CGFloat(sun.x + direction.x),
            y: CGFloat(sun.y + direction.y)
            )
        
        sunSpeed = direction
        lastTranslation = sun + direction
        sunPosition = finalTranslation
        
        if length(direction) < 0.1 && length (sun - pointer) < 0.1 {
            timer?.invalidate()
            timer = nil
            return
        }
    }
}
