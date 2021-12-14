//
//  BlurView.swift
//  LearningNewThings
//
//  Created by ADOP_Mac on 2021/12/11.
//

import SwiftUI
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    
    static func makeMaskForEdgeBlur(inputImage: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        
        let context = CIContext()
        
        let inputImage = CIImage(image: inputImage)!
        
        let w = width
        let h = height
        let topGradient = CIFilter(name:"CILinearGradient")!
        topGradient.setValue(CIVector(x:0, y:0.95 * h),
                             forKey:"inputPoint0")
        topGradient.setValue(CIColor.green,
                             forKey:"inputColor0")
        topGradient.setValue(CIVector(x:0, y:0.85 * h),
                             forKey:"inputPoint1")
        topGradient.setValue(CIColor(red:0, green:1, blue:0, alpha:0),
                             forKey:"inputColor1")
        
        let bottomGradient = CIFilter(name:"CILinearGradient")!
        bottomGradient.setValue(CIVector(x:0, y:0.05 * h),
                                forKey:"inputPoint0")
        bottomGradient.setValue(CIColor.green,
                                forKey:"inputColor0")
        bottomGradient.setValue(CIVector(x:0, y:0.15 * h),
                                forKey:"inputPoint1")
        bottomGradient.setValue(CIColor(red:0, green:1, blue:0, alpha:0),
                                forKey:"inputColor1")
        
        let leftGradient = CIFilter(name: "CILinearGradient")!
        leftGradient.setValue(CIVector(x:0.05 * w, y:0),
                              forKey: "inputPoint0")
        leftGradient.setValue(CIColor.green,
                              forKey: "inputColor0")
        leftGradient.setValue(CIVector(x: 0.15 * w, y: 0),
                              forKey: "inputPoint1")
        leftGradient.setValue(CIColor(red: 0, green: 1, blue: 0, alpha: 0),
                              forKey: "inputColor1")
        
        let rightGradient = CIFilter(name: "CILinearGradient")!
        rightGradient.setValue(CIVector(x:0.95 * w, y:0),
                              forKey: "inputPoint0")
        rightGradient.setValue(CIColor.green,
                              forKey: "inputColor0")
        rightGradient.setValue(CIVector(x: 0.85 * w, y: 0),
                              forKey: "inputPoint1")
        rightGradient.setValue(CIColor(red: 0, green: 1, blue: 0, alpha: 0),
                              forKey: "inputColor1")
        
        let gradientMask = CIFilter(name:"CIAdditionCompositing")!
        gradientMask.setValue(topGradient.outputImage,
                              forKey: kCIInputImageKey)
        gradientMask.setValue(bottomGradient.outputImage,
                              forKey: kCIInputBackgroundImageKey)
        
        let gradientMask2 = CIFilter(name: "CIAdditionCompositing")!
        gradientMask2.setValue(gradientMask.outputImage, forKey: kCIInputImageKey)
        gradientMask2.setValue(leftGradient.outputImage, forKey: kCIInputBackgroundImageKey)
        
        let gradientMask3 = CIFilter(name: "CIAdditionCompositing")!
        gradientMask3.setValue(gradientMask2.outputImage, forKey: kCIInputImageKey)
        gradientMask3.setValue(rightGradient.outputImage, forKey: kCIInputBackgroundImageKey)
        
        let maskedVariableBlur = CIFilter(name:"CIMaskedVariableBlur")!
        maskedVariableBlur.setValue(inputImage, forKey: kCIInputImageKey)
        maskedVariableBlur.setValue(10, forKey: kCIInputRadiusKey)
        maskedVariableBlur.setValue(gradientMask3.outputImage, forKey: "inputMask")
        let selectivelyFocusedCIImage = maskedVariableBlur.outputImage!
        
        let cgImage = context.createCGImage(selectivelyFocusedCIImage, from: selectivelyFocusedCIImage.extent)!
        
        return UIImage(cgImage: cgImage)
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: self.style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
