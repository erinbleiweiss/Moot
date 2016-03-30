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
import SwiftSpinner


/// View controller for the hangman scanning level

class HangmanLevelViewController: GenericLevelViewController {
    
    /// Display margin between tiles
    // TODO: adapt margin based on screen size
    let TileMargin: CGFloat = ScreenWidth / 20
    
    @IBAction func cancelToHangmanLevelViewController(segue:UIStoryboardSegue) {
    }
    
    var controller: HangmanGameController
    required init?(coder aDecoder: NSCoder) {
        controller = HangmanGameController()
        super.init(coder: aDecoder)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controller.level = 1
        self.setCameraButton(self.controller.level!)


        // Add one layer for all game elements (-200 accounts for height of top bar)
        let gameView = UIView(frame: CGRectMake(0, yOffset, ScreenWidth, ScreenHeight - yOffset))
        self.view.addSubview(gameView)
        self.controller.gameView = gameView
        self.setUpLevel()
    
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.updateGame()
    }
    
    
    
    /**
        When the level is loaded, make an initial call to the controller to get a new word and setup the level tiles with a blank game

    */
    override func setUpLevel(){
        // Initial load, no target word
        if (self.controller.targetWord == "") {
            // Generate target word
            self.controller.getRandomWord(){ responseObject, error in
                print("responseObject = \(responseObject); error = \(error)")
                
                // Set current game string in controller (if not first level)
                let difficulty = self.controller.getCurrentStage()
                
                if (difficulty == 1 && self.controller.targetWord == "scan"){
                    self.controller.currentGame = "sc_n"
                } else {
                    for (_, _) in self.controller.targetWord.characters.enumerate() {
                        self.controller.currentGame += "_"
                    }
                }
                
                // Generate game with blank tiles
                self.layoutTiles()
                
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
        // Calculate the tile size and left margin (xOffset)
        let tileSide = ceil(ScreenWidth * 0.9 / CGFloat(self.controller.targetWord.characters.count)) - self.TileMargin
        var xOffset = (ScreenWidth - CGFloat(self.controller.targetWord.characters.count) * (tileSide + self.TileMargin)) / 2.0
        xOffset += tileSide / 2.0 //adjust for tile center (instead of the tile's origin)
        
        // For each letter in the target word, create a new tile object (initialized with a blank "_" by default)
        // Add each tile to the view, and append the tile to the controller's list of tile objects
        for (index, letter) in self.controller.currentGame.characters.enumerate(){
            let tile = HangmanTile(letter: letter, sideLength: tileSide)
            tile.center = CGPointMake(xOffset + CGFloat(index)*(tileSide + self.TileMargin), ScreenHeight/3)
            self.controller.gameView.addSubview(tile)
            self.controller.gameTiles.append(tile)
        }
    }
    
    
    
    /**
        When returning to the view (such as from the camera):
            - check to see if upc is not blank (Make sure something was scanned)
            - display SwiftSpinner to indicate loadings
            - provide feedback on whether or not word is correct
            - hide SwiftSpinner after a delay
     
     */
    func updateGame(){
        if (controller.targetWord != "" && controller.upc != ""){
            SwiftSpinner.show("Scanning")
            controller.playHangman(controller.upc){ responseObject, error in
                // Display feedback message if letter is an incorrect guess
                if (responseObject!["game_state"].string == "2"){
                    SwiftSpinner.show("Not in word", animated: false)
                    self.delay(1.5){
                        SwiftSpinner.hide()
                    }
                } else if (responseObject!["game_state"].string == "1"){
                    SwiftSpinner.show("Already guessed!", animated: false)
                    self.delay(1.5){
                        SwiftSpinner.hide()
                    }
                }
                else{
                    // Guess is correct, check for success
                    SwiftSpinner.show("", animated: false)
                    SwiftSpinner.setTitleFont(UIFont.systemFontOfSize(100))
                    SwiftSpinner.show(self.controller.currentGuess, animated: false)
                    self.delay(1.5){
                        SwiftSpinner.hide()
                    }
                    
                    let return_code = self.controller.checkForSuccess()
                    if (return_code == 1) {
                        // Stage is complete
                        self.displayStageCompletionView()
                    } else if (return_code == 2){
                        // Level is complete
                        self.displayLevelCompletionView()
                    }
                    

                }

                self.controller.showProductPopup(responseObject!["product_name"].string!, color: responseObject!["color"].string!, url: responseObject!["product_img"].string!)
                self.updateMootPoints()
            }
        }
    }
    

    



    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
}