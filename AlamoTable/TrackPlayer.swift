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
        
        backgroundImage.image = previewTrack.albumImage
        albumArtImage.image = previewTrack.albumImage
        trackName.text = previewTrack.trackName
        downloadPreviewTrackFromURL(url: URL(string: previewTrack.previewURL)!)
        
        playPauseButton.setTitle("Pause", for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        trackPlayer.stop()
    }
    
    func downloadPreviewTrackFromURL(url: URL) {
        var downloadTask = URLSessionDownloadTask()
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (downloadedUrl, response, error) in
            self.playTrack(url: downloadedUrl!)
        })
        
        downloadTask.resume()
    }
    
    func playTrack(url: URL) {
        do {
            trackPlayer =  try AVAudioPlayer(contentsOf: url)
            trackPlayer.prepareToPlay()
            trackPlayer.play()
        } catch {
            print(error)
        }
        
    }
    
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
