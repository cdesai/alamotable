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
    }
    
    func playTrack(url: URL) {
        do {
            trackPlayer =  try AVAudioPlayer(contentsOf: url)
        } catch {
            print(error)
        }
        
    }
}
