//
//  InformationView.swift
//  Tic_Tac_Toe
//
//  Created by Victoria Wu on 2/12/17.
//  Copyright © 2017 Gurugulle. All rights reserved.
//

import UIKit

/*
 Information view
 */
class InformationView: UIView{
    
    var content: String
    
    //Mark: Initialization
    init (content: String) {
        self.content = content
        super.init(frame : CGRect(x: 375/2 - 150, y: 100,
                                  width: 300, height: 300))
        self.isUserInteractionEnabled = true
        backgroundColor = UIColor.lightGray
        
        createTextView()
        createButton()
        creatLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Create the text view
    func createTextView(){
        let textView = UITextView(frame:CGRect(x: 0, y: 0,
                                           width: 300, height: 200))
        textView.backgroundColor = UIColor(red:1.00, green:0.72, blue:0.00,alpha: 1.0)
        
        let attribute = [NSFontAttributeName: UIFont(name: "Verdana", size: 17.0)! ]
        let aString = NSAttributedString(string: self.content, attributes: attribute)
        textView.attributedText = aString
        self.addSubview(textView)
        
    }
    
    //Create the button
    func createButton(){
        let dismiss = UIButton(frame:CGRect(x: 375/2 - 60, y:220, width: 50, height: 50))
        dismiss.setTitle("OK", for: .normal)
        dismiss.backgroundColor = UIColor.blue
        self.addSubview(dismiss)
        dismiss.addTarget(self, action: #selector(dismissAction), for: UIControlEvents.touchUpInside)
        
    }
    //Dismiss the view
    func dismissAction(sender: UIButton!) {
        self.removeFromSuperview()
    }
    
    //Create the Version Label
    func creatLabel(){
        let versionDisplay = UILabel(frame: CGRect(x: 375/2-160, y: 220, width: 100, height:50))
        versionDisplay.textColor = UIColor.blue
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionDisplay.text = "Version:\(version)"
        }
        self.addSubview(versionDisplay)
    }
}
