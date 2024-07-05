// Application développée par Sergio Wicramachine
// Date : 5 juillet 2024

import SwiftUI
import UniformTypeIdentifiers

// Vue pour le sélecteur de documents
struct DocumentPickerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode // Mode de présentation pour gérer la fermeture de la vue
    var audioPlayer: AudioPlayer // Instance de la classe AudioPlayer

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Création du contrôleur de vue UIDocumentPickerViewController
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.audio], asCopy: true)
        documentPicker.allowsMultipleSelection = true // Permet la sélection multiple
        documentPicker.delegate = context.coordinator // Définition du délégué
        return documentPicker
    }

    // Mise à jour du contrôleur de vue (si nécessaire)
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        // Mettre à jour l'interface utilisateur (si nécessaire)
    }

    // Coordonnateur pour gérer les actions du sélecteur de documents
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPickerView

        init(_ parent: DocumentPickerView) {
            self.parent = parent
        }

        // Gestion de la sélection des documents
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.audioPlayer.songs = urls // Mise à jour de la liste des chansons
            parent.audioPlayer.currentSongIndex = 0 // Réinitialisation de l'index de la chanson actuelle
            parent.audioPlayer.playSong(at: 0) // Lecture de la première chanson
            parent.presentationMode.wrappedValue.dismiss() // Fermeture de la vue du sélecteur de documents
        }
    }
}
