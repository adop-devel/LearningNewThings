//
//  Colored.swift
//  LearningNewThings
//
//  Created by ADOP_Mac on 2021/11/28.
//

import SwiftUI
import UIKit

struct ColoredHeartHoleIcon: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isTapped: Bool
    
    let iconColor: UIColor
    let diameter: CGFloat
    
    var red: CGFloat = CGFloat(0)
    var green: CGFloat = CGFloat(0)
    var blue: CGFloat = CGFloat(0)
    
    init(iconColor: UIColor, diameter: CGFloat, isTapped: Binding<Bool>) {
        self.iconColor = iconColor
        self.diameter = diameter
        self._isTapped = isTapped
        
        iconColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
    }
    
    var body: some View {
        coloredCircleWithHeartHoleInTheMiddle
            .shadow(
                color: Color(red: red, green: green, blue: blue, opacity: 0.6),
                radius: diameter * 0.034, x: 0, y: diameter * 0.034
            ).onTapGesture {
                isTapped.toggle()
            }
    }
    
    var coloredCircleWithHeartHoleInTheMiddle: some View {
        ZStack {
            coloredCircle
            heartInTheMiddle(isDestinationOut: true)
            if isTapped {
                heartInTheMiddle(isDestinationOut: false)
                    .foregroundColor(Color(.displayP3, red: 1, green: 0.45, blue: 0.45, opacity: 1))
            }
        }
        .frame(width: diameter, height: diameter)
        .compositingGroup()
    }
    
    var coloredCircle: some View {
        Circle()
            .fill(
                AngularGradient(
                    colors: [colorScheme == .dark ? iconColor.convertUIColor() : iconColor.convertUIColor(),
                             Color(red: (red + 1) > 255 ? 255 : (red + 1),
                                   green: (green + 1) > 255 ? 255 : (green + 1),
                                   blue: (blue + 1) > 255 ? 255 : (blue + 1))
                            ],
                    center: .topLeading)
            )
    }
}

struct heartInTheMiddle: View {
    let isDestinationOut: Bool
    @State var sizeOfHeart: CGFloat = 1.3
    
    var heartShape: some View {
        GeometryReader { geometry in
            isDestinationOut ?
              Image(systemName: "heart.fill")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: (geometry.size.width * 0.50), alignment: .center)
                .position(x: geometry.size.width / 2,
                          y: geometry.size.width / 2 + geometry.size.width * 0.02)
            : Image(systemName: "heart.fill")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: (geometry.size.width * 0.50 * sizeOfHeart), alignment: .center)
                .position(x: geometry.size.width / 2,
                          y: geometry.size.width / 2 + geometry.size.width * 0.02)
        }.onAppear(perform: {
            guard !isDestinationOut else { return }
            
            let baseAnimation = Animation.easeOut(duration: 0.25)
            withAnimation(baseAnimation) {
                sizeOfHeart = 1
            }
        })
    }
    
    var body: some View {
        if isDestinationOut {
            heartShape
                .blendMode(.destinationOut)
        } else {
            heartShape
        }
    }
}
