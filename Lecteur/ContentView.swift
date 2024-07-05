// Application développée par Sergio Wicramachine
// Date : 5 juillet 2024

import SwiftUI
import WidgetKit

struct ContentView: View {
    @StateObject private var audioPlayer = AudioPlayer() // Instance de la classe AudioPlayer
    @State private var isDocumentPickerPresented = false // Indicateur de présentation du sélecteur de documents
    @State private var isLinksSheetPresented = false // Indicateur de présentation de la feuille de liens
    
    var body: some View {
        VStack {
            // Affichage du titre de la chanson en cours
            Text("En cours de lecture : \(audioPlayer.currentSongTitle)")
                .font(.headline)
                .padding()
            
            HStack {
                // Bouton lecture/pause
                Button(action: {
                    withAnimation {
                        if audioPlayer.isPlaying {
                            audioPlayer.pause()
                        } else {
                            audioPlayer.resume()
                        }
                    }
                }) {
                    Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                }
                .padding()

                // Bouton chanson précédente
                Button(action: {
                    withAnimation {
                        audioPlayer.previous()
                    }
                }) {
                    Image(systemName: "backward.fill")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }
                .padding()

                // Bouton chanson suivante
                Button(action: {
                    withAnimation {
                        audioPlayer.next()
                    }
                }) {
                    Image(systemName: "forward.fill")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }
                .padding()

                // Bouton lecture aléatoire
                Button(action: {
                    withAnimation {
                        audioPlayer.shuffle()
                    }
                }) {
                    Image(systemName: audioPlayer.isShuffling ? "shuffle.circle.fill" : "shuffle.circle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                }
                .padding()

                // Bouton pour ouvrir le sélecteur de documents
                Button(action: {
                    isDocumentPickerPresented = true
                }) {
                    Image(systemName: "folder.fill")
                        .font(.largeTitle)
                        .foregroundColor(.purple)
                }
                .padding()
            }
            .padding()
            
            // Slider pour avancer/reculer dans la chanson
            Slider(value: $audioPlayer.currentTime, in: 0...audioPlayer.duration, onEditingChanged: { editing in
                if !editing {
                    audioPlayer.seek(to: audioPlayer.currentTime)
                }
            })
            .padding()
            
            // Liste des chansons
            List(audioPlayer.songs, id: \.self) { song in
                VStack(alignment: .leading) {
                    Text(song.lastPathComponent) // Affichage du nom de la chanson
                        .font(.headline)
                    if song == audioPlayer.songs[audioPlayer.currentSongIndex] {
                        Text("En cours de lecture")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                }
                .onTapGesture {
                    if let index = audioPlayer.songs.firstIndex(of: song) {
                        audioPlayer.playSong(at: index)
                    }
                }
            }

            // Bouton pour afficher les liens externes
            Button(action: {
                isLinksSheetPresented = true
            }) {
                Text("Info Pratiques")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
            }
            .sheet(isPresented: $isLinksSheetPresented) {
                LinksSheetView()
            }
        }
        .sheet(isPresented: $isDocumentPickerPresented) {
            DocumentPickerView(audioPlayer: audioPlayer) // Sélecteur de documents pour ajouter des chansons
        }
        .onAppear {
            // Charger l'état de la lecture
        }
        .onDisappear {
            // Sauvegarder l'état de la lecture
        }
    }
}

// Vue pour afficher les liens externes
struct LinksSheetView: View {
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Link("GitHub", destination: URL(string: "https://github.com/wicra")!)
                    Link("LinkedIn", destination: URL(string: "https://www.linkedin.com/in/wicramachine-sergio-8006a72a0?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=ios_app")!)
                    Link("Envoyer un e-mail", destination: URL(string: "mailto:wicramachine@gmail.com")!)
                }
                
                Spacer()
                
                // Paragraphe explicatif du projet
                VStack(alignment: .leading, spacing: 10) {
                    Text("Fatigué des pubs, j'ai créé ce lecteur de musique en 2 jours avec l'aide de l'IA")
                    
                    Text("Mon GitHub a un script Python pour télécharger des playlists YouTube en MP3.")
                    
                    Text("L'icône a été faite par une IA.")
                    
                }
                .font(.body)
                .padding()
                .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .navigationTitle("Liens externes")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
