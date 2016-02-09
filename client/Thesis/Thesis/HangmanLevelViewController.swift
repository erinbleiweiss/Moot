//
//  HangmanLevelViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 10/23/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


/// View controller for the hangman scanning level
    
class HangmanLevelViewController: GenericLevelViewController {
    
    @IBOutlet weak var currentGameLabel: UILabel!
    @IBOutlet weak var currentGuessLabel: UILabel!
    @IBOutlet weak var gameMessageLabel: UILabel!

    let controller: HangmanGameController
    required init?(coder aDecoder: NSCoder) {
        controller = HangmanGameController()
        super.init(coder: aDecoder)
    }
    
    
    /// Display margin between tiles
    // TODO: adapt margin based on screen size
    let TileMargin: CGFloat = 20.0
    
    @IBAction func cancelToHangmanLevelViewController(segue:UIStoryboardSegue) {
//        self.currentGameLabel.text = productName
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let level1 = Level(levelNumber: 1)

        // Add one layer for all game elements
        let gameView = UIView(frame: CGRectMake(0, -200, ScreenWidth, ScreenHeight))
        self.view.addSubview(gameView)
        self.controller.gameView = gameView
        

        // Initial load, no target word
        if (self.controller.targetWord == "") {
            // Generate target word
            self.controller.getRandomWord(){ responseObject, error in
                print("responseObject = \(responseObject); error = \(error)")

                // On load, generate blank game
                self.layoutTiles()
                
                for (index, _) in self.controller.targetWord.characters.enumerate() {
                    self.controller.currentGame += "_"
                }

                self.currentGameLabel.attributedText = self.letterStyles(self.controller.currentGame)
                self.currentGuessLabel.attributedText = self.guessStyles(self.controller.currentGuess)
                
            }
            
        }
        else {
            self.controller.playHangman(self.controller.upc){ responseObject, error in
                
                self.controller.checkForSuccess()
            }
            

        }

    
    }
    
    override func viewDidAppear(animated: Bool) {
        if (controller.targetWord != "" && controller.upc != ""){
            controller.playHangman(controller.upc){ responseObject, error in
                // Display feedback message if letter is an incorrect guess
                if (responseObject!["status"] == 2){
                    self.gameMessageLabel.text = "Not in word"
                }
                else{
                    self.gameMessageLabel.text = ""
                }
                self.currentGameLabel.attributedText = self.letterStyles(self.controller.currentGame)
                self.controller.checkForSuccess()
            }
        }
    }
    
    
    /**
        On load, create and display one tile for each letter in the target word.
        This function also calculates the appropriate size for the tiles based on the device's screen
        width, as well as the margin size between tiles.
    
        - Parameters: none
        - Returns: none
    
    */
    func layoutTiles(){
        
        // Calculate the tile size
        let tileSide = ceil(ScreenWidth * 0.9 / CGFloat(self.controller.targetWord.characters.count)) - self.TileMargin
        
        //get the left margin for first tile
        var xOffset = (ScreenWidth - CGFloat(self.controller.targetWord.characters.count) * (tileSide + self.TileMargin)) / 2.0
        
        //adjust for tile center (instead of the tile's origin)
        xOffset += tileSide / 2.0
        
        // For each letter in the target word, create a new tile object (initialized with a blank "_" by default)
        // Add each tile to the view, and append the tile to the controller's list of tile objects
        for (index, _) in self.controller.targetWord.characters.enumerate(){
            let tile = HangmanTile(letter: "_", sideLength: tileSide)
            tile.center = CGPointMake(xOffset + CGFloat(index)*(tileSide + self.TileMargin), ScreenHeight/4*3)
            self.controller.gameView.addSubview(tile)
            self.controller.gameTiles.append(tile)
        }
    }
    
    func letterStyles(currentGame: String) -> NSMutableAttributedString{
        let fontAttributes = [
            NSFontAttributeName: UIFont(
                name: "Anonymous",
                size: 50.0
                )!,
            NSKernAttributeName: 15
        ]
        
        let returnString: NSMutableAttributedString = NSMutableAttributedString(string: currentGame, attributes: fontAttributes)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        returnString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, returnString.length))
        
        
        return returnString
        
    }
    
    func guessStyles(currentGame: String) -> NSMutableAttributedString{
        let fontAttributes = [
            NSFontAttributeName: UIFont(
                name: "Anonymous",
                size: 75.0
                )!
        ]
        
        let returnString: NSMutableAttributedString = NSMutableAttributedString(string: currentGame, attributes: fontAttributes)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        returnString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, returnString.length))
        
        
        return returnString
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}