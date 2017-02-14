//
//  SoundManager.swift
//  Tic_Tac_Toe
//
//  Created by Victoria Wu on 2/12/17.
//  Copyright © 2017 Gurugulle. All rights reserved.
//

import Foundation
import AVFoundation

/**
 SoundManager manages sound
 */
class SoundManager {
    
    // Static class variable
    static let sharedInstance = SoundManager()
    
    var musicPlayer: AVAudioPlayer!
    
    /// This("private" qualifier) prevents others from using the default '()' initializer for this class.
    private init() {}

    /// Play a sound
    func playSound(filename: String){
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        guard let newURL = url else {
            print("Coud not find file:\(filename)")
            return
        }
        do{
            musicPlayer = try AVAudioPlayer(contentsOf:newURL)
            musicPlayer.numberOfLoops = -1
            //musicPlayer.prepareToPlay()
            musicPlayer.play()
            
        }catch let error as NSError{
            print(error.description)
        }
    }
    
    ///Stop playing sound
    func stopPlaying(){
        if musicPlayer.isPlaying {
            musicPlayer.stop()
        }

    }
}
