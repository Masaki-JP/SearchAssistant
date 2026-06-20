import AVFAudio
import Foundation

final class SelectionSoundPlayer {
    private var audioPlayer: AVAudioPlayer?
    
    init() {
        guard let soundURL = Bundle.main.url(forResource: "selection", withExtension: "caf") else { return }
        audioPlayer = try? AVAudioPlayer(contentsOf: soundURL)
        audioPlayer?.prepareToPlay()
    }
    
    func play() {
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
    }
}
