import AVFAudio
import Foundation

final class SelectionSoundPlayer {
    private var audioPlayer: AVAudioPlayer?
    
    init() {
        guard
            let _ = try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default),
            let soundURL = Bundle.main.url(forResource: "selection", withExtension: "caf"),
            let audioPlayer = try? AVAudioPlayer(contentsOf: soundURL)
        else {
            return
        }
        
        self.audioPlayer = audioPlayer
        self.audioPlayer?.prepareToPlay()
    }
    
    func play() {
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
    }
}
