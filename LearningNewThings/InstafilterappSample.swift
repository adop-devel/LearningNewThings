//
//  InstafilterappSample.swift
//  LearningNewThings
//
//  Created by ADOP_Mac on 2021/12/12.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct InstafilterSample: View {
    @State var image: Image?
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage)
    }
    
    func loadImage() {
        let inputImage = UIImage(named: "someSampleImage")!
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.sepiaTone()
        
        currentFilter.inputImage = beginImage
        currentFilter.intensity = 1
        
        let outputImage = currentFilter.outputImage!
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)!
        let uiImage = UIImage(cgImage: cgImage)
        image = Image(uiImage: uiImage)
    }
}

struct InstafilterSample_previews: PreviewProvider {
    static var previews: some View {
        InstafilterSample()
    }
}
