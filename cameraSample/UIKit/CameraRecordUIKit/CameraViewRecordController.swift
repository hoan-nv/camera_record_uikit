import UIKit

class CameraViewRecordController: UIViewController, AVAssetWriterManagerDelegate {
    func updateProgress(progress: CGFloat) {
        
    }
 
    @IBOutlet weak var previewView: UIView!
    
    lazy var assetWriteManager: AvAssetWriteManager = {
        return AvAssetWriteManager.init(supview: self.previewView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        assetWriteManager.delegate = self
    }
}
