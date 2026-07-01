import AVFoundation

/// Thin AVAudioPlayer wrapper around the bundled `he-.mp3`.
final class AudioPlayer {
    private var player: AVAudioPlayer?

    init() {
        guard let url = Bundle.module.url(forResource: "he-", withExtension: "mp3") else {
            NSLog("hee-button: he-.mp3 not found in bundle")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
        } catch {
            NSLog("hee-button: failed to load he-.mp3: \(error)")
        }
    }

    /// Plays from the start. If already playing, restarts from the top so
    /// rapid clicks retrigger the sound instead of stacking or being ignored.
    func play() {
        guard let player else { return }
        player.currentTime = 0
        player.play()
    }
}
