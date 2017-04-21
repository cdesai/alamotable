//
//  TrackPlayer.swift
//  AlamoTable
//
//  Created by Chinmay Desai on 20/4/17.
//  Copyright © 2017 Chinmay Desai. All rights reserved.
//

import UIKit
import AVFoundation

class TrackPlayer: UIViewController {
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var albumArtImage: UIImageView!
    @IBOutlet var trackName: UILabel!
    @IBOutlet var playPauseButton: UIButton!
    
    var previewTrack: Track!
    var trackPlayer: AVAudioPlayer!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Feed UI Objects with the data
        backgroundImage.image = previewTrack.albumImage
        albumArtImage.image = previewTrack.albumImage
        trackName.text = previewTrack.trackName
        
        // Run a background task to download 30 seconds preview track from the URL we found from JSON
        // This will also start playing the song.
        downloadPreviewTrackFromURL(url: URL(string: previewTrack.previewURL)!)
        
        // Set the title to Pause,as song has alreadu started playing
        playPauseButton.setTitle("Pause", for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // Before we move back to track list, stop playing the track
        trackPlayer.stop()
    }
    
    func downloadPreviewTrackFromURL(url: URL) {
        var downloadTask = URLSessionDownloadTask()
        
        // Create a URLSessionTask  to download preview track.
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (downloadedUrl, response, error) in
            
            // Once the track is downloaded play it
            self.playTrack(url: downloadedUrl!)
        })
        
        downloadTask.resume()
    }
    
    // Prepare Audio Player session and play the track.
    func playTrack(url: URL) {
        do {
            trackPlayer =  try AVAudioPlayer(contentsOf: url)
            trackPlayer.prepareToPlay()
            trackPlayer.play()
        } catch {
            print(error)
        }
        
    }
    
    // Play/Pause track based on the state of the audio player.
    @IBAction func pauseTrack(_ sender: UIButton) {
        switch(sender.currentTitle!) {
        case "Pause":
            playPauseButton.setTitle("Play", for: .normal)
            trackPlayer.pause()
        case "Play":
            playPauseButton.setTitle("Pause", for: .normal)
            trackPlayer.play()
        default:
            print("No such action")
            
        }
    }
}
