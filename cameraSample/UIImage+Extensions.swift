import UIKit

extension UIImage {
    
    //https://gist.github.com/toddhopkinson/51defbec932b7eafadc5a0921880514f
    func downsample(reductionAmount: Float, size: CGSize = CGSizeMake(100, 100)) -> UIImage? {
        if let data = self.pngData() {
            return self.downsampleImage(imageData: data, to: size)
        }
        let image = UIKit.CIImage(image: self)
        guard let lanczosFilter = CIFilter(name: "CILanczosScaleTransform") else { return nil }
        lanczosFilter.setValue(image, forKey: kCIInputImageKey)
        lanczosFilter.setValue(NSNumber.init(value: reductionAmount), forKey: kCIInputScaleKey)

        guard let outputImage = lanczosFilter.outputImage else { return nil }
        let context = CIContext(options: [CIContextOption.useSoftwareRenderer: false])
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil}
        return UIImage(cgImage: cgImage )
    }
    
    //https://github.com/2ZGroupSolutionsArticles/Article_KZ004/blob/master/ImagePerfomanceTest/ImagePerfomanceTest/Data/ImageDownsamplingOperation.swift
    func downsampleImage(imageData: Data, to pointSize: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage {
            let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
            guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions) else { return UIImage() }

            let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
            let downsampleOptions = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceShouldCacheImmediately: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
            ] as CFDictionary

            guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else { return UIImage() }
            return UIImage(cgImage: downsampledImage)
        }
    
 
    func cgImageWithFixedOrientation() -> CGImage? {
        if imageOrientation == .up {
            return cgImage
        }
        
        guard let cgImage = cgImage, let colorSpace = cgImage.colorSpace else {
            return nil
        }
        
        let width  = size.width
        let height = size.height
        
        var transform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: width, y: height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.rotated(by: 0.5 * .pi)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: height)
            transform = transform.rotated(by: -0.5 * .pi)
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        guard let context = CGContext(
            data: nil,
            width: Int(width),
            height: Int(height),
            bitsPerComponent: cgImage.bitsPerComponent,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: UInt32(cgImage.bitmapInfo.rawValue)
        ) else {
            return nil
        }
        
        context.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: height, height: width))
        default:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        
        return context.makeImage()
    }
    
    func fixOrientation() -> UIImage {
        guard let cgimg = self.cgImageWithFixedOrientation() else { return self }
        return  UIImage(cgImage: cgimg)
    }
}
