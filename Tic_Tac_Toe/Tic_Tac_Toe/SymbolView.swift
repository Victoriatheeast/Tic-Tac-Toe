//
//  SymbolView.swift
//  Tic_Tac_Toe
//
//  Created by Victoria Wu on 2/12/17.
//  Copyright © 2017 Gurugulle. All rights reserved.
//

import UIKit

/**
 Super class Symbol
 */
class SymbolView: UIImageView {
    
    //Player
    var player: String?
    
    //Initialization
    override init(image: UIImage?){
    super.init(image: image)
        self.isUserInteractionEnabled = true
        self.tag = -1

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Mark: - Animation
    /**
     Grow to a factor of 2 and shrink
    */
    func animateDisplay(){
        UIView.animate(withDuration: 1, animations: {
            self.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        }) { (finished) in
            UIView.animate(withDuration: 1, animations: {
                self.transform = CGAffineTransform.identity
            })
        }
    }
    

    // MARK: - Touch handling
    //Play music when the player drags the symbol
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        SoundManager.sharedInstance.playSound(filename: "Succeed.mp3")
        
    }

    //Stop playing music when the player's touches ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        SoundManager.sharedInstance.stopPlaying()
    }
    
    //Stop playing music when the player's touches cancelled
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       SoundManager.sharedInstance.stopPlaying()
    }

    
}
