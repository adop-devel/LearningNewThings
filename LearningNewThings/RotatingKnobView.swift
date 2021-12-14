//
//  RotatingKnobView.swift
//  LearningNewThings
//
//  Created by ADOP_Mac on 2021/11/28.
//

import SwiftUI

struct RotatingKnobView: View {
    @Binding var angleValueInRadians: Double
    
    var body: some View {
        ZStack{
            DottedCircle()
            Circle()
                .trim(from: 0, to: angleValueInRadians / (2 * .pi))
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 4))
                .frame(width: 200, height: 200)
                .rotationEffect(.radians(-Double.pi/2))
            Circle()
                .fill(Color.blue)
                .frame(width: 30, height: 30)
                .padding(10)
                .offset(y: -100)
                .rotationEffect(.radians(angleValueInRadians))
                .gesture(DragGesture(minimumDistance: 3.0)
                            .onChanged({ dragValue in
                    let adjustedAngle = -atan2((dragValue.location.x - 25), (dragValue.location.y - 25)) + .pi
                    guard !(abs(angleValueInRadians - adjustedAngle) > (.pi / 2)) else { return }
                    angleValueInRadians = adjustedAngle
                }))
        }
    }
}

struct DottedCircle: View {
    let radius: CGFloat = 100
    let pi = Double.pi
    let dotCount = 10
    let dotLength: CGFloat = 3
    let spaceLength: CGFloat

    init() {
        let circumerence: CGFloat = CGFloat(2.0 * pi) * radius
        spaceLength = circumerence / CGFloat(dotCount) - dotLength
    }
    
    var body: some View {
        Circle()
            .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, lineCap: .butt, lineJoin: .miter, miterLimit: 0, dash: [dotLength, spaceLength], dashPhase: 0))
            .frame(width: radius * 2, height: radius * 2)
    }
}
