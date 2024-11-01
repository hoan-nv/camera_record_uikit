import Foundation
import Photos
import AVFoundation
import CoreMedia
import UIKit

final class Common: NSObject {
    static let shared = Common()

    static func formatAudioTimeDuration(duration: CGFloat?) -> String {
        if let duration = duration {
            let milliseconds =  floor(duration/1000)
            let minutes = Int((milliseconds.truncatingRemainder(dividingBy: 3600)) / 60)
            let seconds = Int(milliseconds.truncatingRemainder(dividingBy: 60))
            if minutes < 10 {
                if seconds < 10 {
                    return "0\(minutes):0\(seconds)"
                }
                return "0\(minutes):\(seconds)"
            } else {
                if seconds < 10 {
                    return "\(minutes):0\(seconds)"
                }
                return "\(minutes):\(seconds)"
            }
        }
        return ""
    }
    
    static func formatTimeDuration(duration: TimeInterval) -> String {
        let durationTime = CMTimeGetSeconds(CMTime(seconds: duration, preferredTimescale: 1000000))
        let minutes = Int((durationTime.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(durationTime.truncatingRemainder(dividingBy: 60))
        if minutes < 10 {
            if seconds < 10 {
                return "0\(minutes):0\(seconds)"
            }
            return "0\(minutes):\(seconds)"
        } else {
            if seconds < 10 {
                return "\(minutes):0\(seconds)"
            }
            return "\(minutes):\(seconds)"
        }
    }
    
    func vibrate() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    
    func triggerFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func requestPhotoAccess(for level: PHAccessLevel, onComplete: @escaping ((PHAuthorizationStatus) -> Void)) {
        PHPhotoLibrary.requestAuthorization(for: level) { status in
            onComplete(status)
        }
    }
    
    func openEpicReelApp() {
        if let appStoreUrl = URL(string: "https://apps.apple.com/us/app/voice-changer-prank-sounds/id6468240264"), UIApplication.shared.canOpenURL(appStoreUrl) {
            UIApplication.shared.open(appStoreUrl, options: [:], completionHandler: nil)
        }
    }
    
}

struct MailContent {
    let recipients: [String]
    let subject: String
    let messageBody: String
}
