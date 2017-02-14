//
//  ViewController.swift
//  Tic_Tac_Toe
//
//  Created by Victoria Wu on 2/11/17.
//  Copyright © 2017 Gurugulle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Mark properties
    
    //Current player
    var currentPlayer: SymbolView!
    
    //Array of symbols on board
    var symbols = [SymbolView]()
    
    //Winner of the game
    var winner: String?
    
    //Array of symbols waiting to be dragged
    var symbolsInPlay = [SymbolView]()
    
    //Array of winning lines
    let winningLines = [[0,1,2], [3,4,5], [6,7,8],//vertical
                        [0,3,6], [1,4,7], [2,5,8],//horizontal
                        [0,4,8], [2,4,6]]//diagonal
   
    //Array of UIViews on board
    var viewArray = [UIView]()
    
    //Array of symbol X's tag number
    var tagX =  [Int]()
    
    //Array of symbol O's tag number
    var tagO =  [Int]()
    
    //Drawing line
    let line =  CAShapeLayer()
    
    //If the game has winner
    var isWin = false
    
    //Info button connects to information view
    @IBAction func toInfoView(_ sender: UIButton) {
        let infoText: String = "Tic-tac-toe (also known as noughts and crosses or Xs and Os) is a paper-and-pencil game for two players, X and O, who take turns marking the spaces in a 3×3 grid. The player who succeeds in placing three of their marks in a horizontal, vertical, or diagonal row wins the game."

        let info = InformationView(content: infoText)
        info.center.y -= info.bounds.height
        self.view.addSubview(info)
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseOut], animations: {
        info.center.y += info.bounds.height
        }, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createViews()
        startNewGame()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Create 9 UIViews
    func createViews(){
        
        for i in 1...3{
            for j in 1...3 {
                
                let gridView = UIView(frame: CGRect(x:24+(i-1)*114, y: 116+(j-1)*116, width:98, height:100))
                print("\(gridView.frame.origin.x) \(gridView.frame.origin.y)")
                gridView.isOpaque = false
                self.view.addSubview(gridView)
                self.viewArray.append(gridView)
                
            }
        }
        
        for view in viewArray{
            view.tag = viewArray.index(of: view)!
        }
    }
    
    //Start a new game
    func startNewGame(){
        
        self.clear()
        isWin = false
        let crossX = Cross()
        symbolsInPlay.append(crossX)
        let panGestureX = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        crossX.addGestureRecognizer(panGestureX)
        let naughtO = Naught()
        symbolsInPlay.append(naughtO)
        let panGestureO = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        naughtO.addGestureRecognizer(panGestureO)
        currentPlayer = symbolsInPlay.first
        naughtO.isUserInteractionEnabled = false
        naughtO.alpha = 0.5
        crossX.animateDisplay()
 
        self.view.addSubview(crossX)
        self.view.addSubview(naughtO)
       
    }
    
    //clear the symbols
    func clear(){
        for symbol in symbols{
            symbol.removeFromSuperview()
        }
        self.symbols.removeAll()
        self.tagX.removeAll()
        self.tagO.removeAll()
        for symbol in symbolsInPlay{
            symbol.removeFromSuperview()
        }
        self.symbolsInPlay.removeAll()
        line.removeFromSuperlayer()
    
    }
    
    
    //Mark: Pan Gesture Recognizer
    func handlePan(_ recognizer:UIPanGestureRecognizer){
        
        //Determine where the image view is in relation to its superview
        let translation = recognizer.translation(in: self.view)
        print(translation)
        
        if let view = recognizer.view{
            
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
            print(view.center)
        }
        
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        if (recognizer.state == UIGestureRecognizerState.ended){
            bounceBack()
            snapInTo()
        }
       
    
}
    //The symbol bounceback if it intesects with another symbol
    func bounceBack(){
        var backPoint: CGPoint!
        for symbol in symbols{
            if currentPlayer.frame.intersects(symbol.frame) {
                SoundManager.sharedInstance.playSound(filename: "toggle.mp3")
                
                if currentPlayer.player == "X"{
                    backPoint = CGPoint(x:60, y:500)
                } else {
                    backPoint = CGPoint(x:215, y:500)
                }
                UIView.animate(withDuration: 0.5, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.currentPlayer.frame.origin = backPoint
                    
                }, completion: {finished in
                    SoundManager.sharedInstance.stopPlaying()
                self.snapInTo()})
            }
            
        }
    }
 
    
    //The symbol snaps into the space if it is empty
    func snapInTo(){
    for gridview in viewArray {
          let viewFrame = gridview.frame
            if currentPlayer.frame.intersects(viewFrame){
                SoundManager.sharedInstance.playSound(filename: "drag.mp3")
                
                let finalPoint = viewFrame.origin
                currentPlayer.tag = gridview.tag
                if(currentPlayer.player == "X"){
                    tagX.append(currentPlayer.tag)
                } else {
                    tagO.append(currentPlayer.tag)
                }
                UIView.animate(withDuration: 0.2, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.currentPlayer.frame.origin = finalPoint
                    
                }, completion: {finished in
                    SoundManager.sharedInstance.stopPlaying()
                    self.currentPlayer.isUserInteractionEnabled = false
                    self.symbols.append(self.currentPlayer)
                    self.checkWin()
                    self.checkStaleMate()
                    self.switchPlayer()
                    
                })
            
            }
        
        }
        
    }
 
    //Switch the player when the current player has placed the symbol into the space
    func switchPlayer(){
        currentPlayer = symbolsInPlay.last
        currentPlayer.alpha = 1.0
        currentPlayer.isUserInteractionEnabled = true
        //Grows and shrinks to display it is the current player's turn
        currentPlayer.animateDisplay()
        symbolsInPlay.removeFirst()
        if  currentPlayer.player == "O" {
            let newCross = Cross()
            newCross.alpha = 0.5
            newCross.isUserInteractionEnabled = false
            let panX = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            newCross.addGestureRecognizer(panX)
            symbolsInPlay.append(newCross)
            self.view.addSubview(newCross)
        } else {
            let newNaught = Naught()
            newNaught.alpha = 0.5
            newNaught.isUserInteractionEnabled = false
            let panO = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            newNaught.addGestureRecognizer(panO)
            symbolsInPlay.append(newNaught)
            self.view.addSubview(newNaught)
        }
    }

    //Check if there is a winner
    func checkWin(){
        
        let tagXSet = Set(self.tagX)
        let tagOSet = Set(self.tagO)
        
        for line in winningLines {
            let lineSet = Set(line)
            if lineSet.isSubset(of: tagXSet){
                winner = "X"
                drawLines(match: Array(tagXSet.intersection(lineSet)))
                isWin = true
                displayWinner(winner: self.winner!)
            } else if lineSet.isSubset(of: tagOSet){
                winner = "O"
                drawLines(match: Array(tagOSet.intersection(lineSet)))
                isWin = true
                displayWinner(winner: self.winner!)
            }
        }
        
    }
    
    //Display the winner using alert controller
    func displayWinner(winner: String){
        SoundManager.sharedInstance.playSound(filename: "Congrat.mp3")
        let title = "Game Over"
        let message = "\(winner) wins!"
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "New Game", style: .default,
                                   handler: {action in
                                    self.startNewGame()
                                    SoundManager.sharedInstance.stopPlaying()})
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //Draw the lines for the match
    func drawLines(match: Array<Int>){
        let sortedMatch = match.sorted()
        if sortedMatch == self.winningLines[0]{
            addLine(fromPoint: CGPoint(x:73,y:116), toPoint: CGPoint(x:73,y:450))
        } else if sortedMatch == self.winningLines[1]{
            addLine(fromPoint: CGPoint(x:187,y:116), toPoint: CGPoint(x:187,y:450))
        } else if sortedMatch == self.winningLines[2]{
            addLine(fromPoint: CGPoint(x:301,y:116), toPoint: CGPoint(x:301,y:450))
        } else if sortedMatch == self.winningLines[3]{
            addLine(fromPoint: CGPoint(x:24,y:166), toPoint: CGPoint(x: 352,y:166))
        } else if sortedMatch == self.winningLines[4]{
            addLine(fromPoint: CGPoint(x:24, y:282), toPoint: CGPoint(x: 352, y:282))
        } else if sortedMatch == self.winningLines[5]{
            addLine(fromPoint: CGPoint(x:24, y: 398), toPoint: CGPoint(x: 352, y:398))
        } else if sortedMatch == self.winningLines[6]{
            addLine(fromPoint: CGPoint(x:24, y:116), toPoint: CGPoint(x: 352, y: 448))
        } else if sortedMatch == self.winningLines[7]{
            addLine(fromPoint: CGPoint(x:352, y:116), toPoint: CGPoint(x: 24,y:448))
        }
    }
 
    //Attribution: http://stackoverflow.com/questions/40556112/how-to-draw-a-line-in-swift-3
   //Add line
       func addLine(fromPoint start: CGPoint, toPoint end:CGPoint) {
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = UIColor.red.cgColor
        line.lineWidth = 4
        line.lineJoin = kCALineJoinRound
        self.view.layer.addSublayer(line)
        
    }
    
    //Check if there is a tie at the end
    func checkStaleMate(){
        if symbols.count == 9 && isWin == false{
            let title = "Game Over"
            let message = "It's a tie, play again!"
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "New Game", style: .default,
                                       handler: {action in
                                        self.startNewGame()})
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
    }
    

    
    


}

