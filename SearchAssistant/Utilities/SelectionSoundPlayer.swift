import AudioToolbox
import Foundation

final class SelectionSoundPlayer {
    var soundID: SystemSoundID = 0
    
    init() {
        guard let soundURL = Bundle.main.url(forResource: "selection", withExtension: "caf") else { return }
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
    }
    
    deinit {
        AudioServicesDisposeSystemSoundID(soundID)
    }
    
    func play() {
        guard soundID != 0 else { return }
        AudioServicesPlaySystemSound(soundID)
    }
}
