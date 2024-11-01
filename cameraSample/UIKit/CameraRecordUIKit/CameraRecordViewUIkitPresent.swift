import SwiftUI
import UIKit
class CameraRecordModel: NSObject, ObservableObject {
    let vc = CameraViewRecordController()
    
    @Published var state: RecordState = .initing
    
    var assetWriteManager: AvAssetWriteManager {
        vc.assetWriteManager
    }
    
    func recordAction() {
        if state == .initing {
            DispatchQueue.global().async {
                self.setState(.recording)
                self.assetWriteManager.startRecord()
            }
           
        } else if state == .recording {
            DispatchQueue.global().async {
                self.setState(.initing)
                self.assetWriteManager.stopRecord()
                self.assetWriteManager.reset()
            }
        }
    }
    
    func setState(_ state: RecordState) {
        DispatchQueue.main.async {
            self.state = state
        }
    }
}

struct CameraRecordViewUIkitPresent: UIViewControllerRepresentable {
    @ObservedObject var cameraRecordModel: CameraRecordModel
    func makeUIViewController(context: Context) -> CameraViewRecordController {
        cameraRecordModel.vc
    }
    
    func updateUIViewController(_ uiViewController: CameraViewRecordController, context: Context) {
        
    }
    
    typealias UIViewControllerType = CameraViewRecordController
    
    
}
