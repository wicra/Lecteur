// Application développée par Sergio Wicramachine
// Date : 5 juillet 2024

import AVFoundation
import SwiftUI
import WidgetKit

// Classe pour gérer la lecture audio
class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    var player: AVAudioPlayer?
    var songs: [URL] = [] // Liste des chansons
    @Published var isPlaying = false // Indique si une chanson est en cours de lecture
    @Published var currentSongTitle = "" // Titre de la chanson actuelle
    @Published var currentSongIndex = 0 // Index de la chanson actuelle
    @Published var isShuffling = false // Indique si la lecture aléatoire est activée
    @Published var currentTime: TimeInterval = 0 // Temps écoulé de la chanson actuelle
    @Published var duration: TimeInterval = 0 // Durée de la chanson actuelle

    var timer: Timer?

    override init() {
        super.init()
        configureAudioSession()
    }

    // Configure la session audio pour la lecture
    func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Échec de la configuration de la session audio : \(error.localizedDescription)")
        }
    }

    // Lecture d'une chanson à un index donné
    func playSong(at index: Int) {
        guard index < songs.count else {
            print("Index hors limites.")
            return
        }
        currentSongIndex = index
        let songURL = songs[currentSongIndex]

        do {
            player = try AVAudioPlayer(contentsOf: songURL)
            player?.delegate = self
            player?.prepareToPlay()
            player?.play()
            isPlaying = true
            currentSongTitle = songURL.lastPathComponent
            duration = player?.duration ?? 0

            startTimer()

            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("Erreur lors de la lecture audio : \(error.localizedDescription)")
        }
    }

    // Démarre un timer pour mettre à jour le temps écoulé
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.currentTime = self.player?.currentTime ?? 0
        }
    }

    // Met en pause la lecture
    func pause() {
        player?.pause()
        isPlaying = false
        timer?.invalidate()
        WidgetCenter.shared.reloadAllTimelines()
    }

    // Reprend la lecture
    func resume() {
        player?.play()
        isPlaying = true
        startTimer()
        WidgetCenter.shared.reloadAllTimelines()
    }

    // Lecture de la chanson suivante
    func next() {
        if isShuffling {
            currentSongIndex = Int.random(in: 0..<songs.count)
        } else {
            currentSongIndex = (currentSongIndex + 1) % songs.count
        }
        playSong(at: currentSongIndex)
        WidgetCenter.shared.reloadAllTimelines()
    }

    // Lecture de la chanson précédente
    func previous() {
        currentSongIndex = (currentSongIndex - 1 + songs.count) % songs.count
        playSong(at: currentSongIndex)
        WidgetCenter.shared.reloadAllTimelines()
    }

    // Active ou désactive la lecture aléatoire
    func shuffle() {
        isShuffling.toggle()
    }

    // Fonction appelée lorsque la lecture d'une chanson est terminée
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            next()
        }
    }

    // Avance ou recule dans la chanson
    func seek(to time: TimeInterval) {
        player?.currentTime = time
        currentTime = time
    }
}
