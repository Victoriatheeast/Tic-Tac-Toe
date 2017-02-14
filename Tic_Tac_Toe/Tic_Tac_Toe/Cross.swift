//
//  Cross.swift
//  Tic_Tac_Toe
//
//  Created by Victoria Wu on 2/12/17.
//  Copyright © 2017 Gurugulle. All rights reserved.
//

import UIKit

/*
 Subclass of Symbol: cross
 */
class Cross: SymbolView{
    
    //Mark: Initialization
    init(){
        let crossImage = UIImage(named:"Cross")
        super.init(image: crossImage)
        self.frame = CGRect(x:60, y:500, width:98, height:103)
        super.player = "X"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
