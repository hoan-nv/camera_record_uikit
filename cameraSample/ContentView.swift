import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var cameraRecordModel = CameraRecordModel()
    @State var isForeground = true
    var body: some View {
        ZStack {
            CameraRecordViewUIkitPresent(cameraRecordModel: cameraRecordModel)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Button(action: {
                    cameraRecordModel.recordAction()
                }, label: {
                    ZStack {
                        Color.red.frame(width: 80, height: 80)
                            .clipShape(Circle())
                        switch cameraRecordModel.state {
                        case .recording:
                            Color.blue.frame(width: 80, height: 80).clipShape(Circle())
                        case .finish:
                            Color.yellow.frame(width: 80, height: 80).clipShape(Circle())
                        default:
                            Color.white.frame(width: 60, height: 60).clipShape(Circle())
                        
                        }
                       
                    }
                })
                .padding(.vertical)
            }
        }
        .onChange(of: scenePhase) { scenePhase in
            switch scenePhase {
            case .active:
                if !isForeground {
                    if cameraRecordModel.state == .recording {
                        cameraRecordModel.recordAction()
                    }
                }
            case .background:
                isForeground = false
            default:
                break
            }
        }
    }
}

#Preview {
    ContentView()
}
