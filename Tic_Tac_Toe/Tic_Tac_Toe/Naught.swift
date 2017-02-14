//
//  Naught.swift
//  Tic_Tac_Toe
//
//  Created by Victoria Wu on 2/12/17.
//  Copyright © 2017 Gurugulle. All rights reserved.
//

import UIKit

/*
 Subclass of Symbol: cross
 */
class Naught:SymbolView{
    
    //Mark: Initialization
    init(){
        let naughtImage = UIImage(named:"Naught")
        super.init(image: naughtImage)
        self.frame = CGRect(x:215, y:500, width:98, height:103)
        super.player = "O"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
