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
import MessageUI

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
    
    override func viewWillAppear(animated: Bool) {
        self.displayCamera = true
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controller.level = 1
        self.controller.loadLevelData()
        self.layoutTiles()
        
        self.setCameraButton(self.controller.level!)


        // Add one layer for all game elements (-200 accounts for height of top bar)
        let gameView = UIView(frame: CGRectMake(0, yOffset, ScreenWidth, ScreenHeight - yOffset))
        self.view.addSubview(gameView)
        self.controller.gameView = gameView

        self.setUpLevel()
    
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.controller.refreshData()
        self.controller.upc = ""
        self.updateGame()
        if self.controller.level != nil {
            self.header?.levelBadge!.update(self.controller.level!)
            self.view.layoutSubviews()
        }
    }
    
    
    
    /**
        When the level is loaded, make an initial call to the controller to get a new word and setup the level tiles with a blank game

    */
    override func setUpLevel(){
        self.controller.refreshData()
        // Initial load, no target word
        if (self.controller.hangmanData.getTargetWord() == "") {
            // Generate target word
            self.controller.getRandomWord(){ responseObject, error in
                if error != nil {
                    self.displayNetworkAlert("playing level 1.")
                } else {
                    // Set current game string in controller (if not first level)
                    let difficulty = self.controller.getCurrentStage()
                    
                    if (difficulty == 1 && self.controller.hangmanData.getTargetWord() == "scan"){
                        self.controller.hangmanData.set_CurrentGame("sc_n")
                    } else {
                        for (_, _) in self.controller.hangmanData.getTargetWord().characters.enumerate() {
                            var currentGame = self.controller.hangmanData.getCurrentGame()
                            currentGame += "_"
                            self.controller.hangmanData.set_CurrentGame(currentGame)
                        }
                    }
                    
                    self.controller.refreshData()
                    // Generate game with blank tiles
                    self.layoutTiles()
                }
                
            }
            
        }
        if self.controller.level != nil {
            self.header?.levelBadge!.update(self.controller.level!)
            self.view.layoutSubviews()
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
        let tileSide = ceil(ScreenWidth * 0.9 / CGFloat(self.controller.hangmanData.getTargetWord().characters.count)) - self.TileMargin
        var xOffset = (ScreenWidth - CGFloat(self.controller.hangmanData.getTargetWord().characters.count) * (tileSide + self.TileMargin)) / 2.0
        xOffset += tileSide / 2.0 //adjust for tile center (instead of the tile's origin)
        
        // For each letter in the target word, create a new tile object (initialized with a blank "_" by default)
        // Add each tile to the view, and append the tile to the controller's list of tile objects
        for (index, letter) in self.controller.hangmanData.getCurrentGame().characters.enumerate(){
            let tile = HangmanTile(letter: letter, sideLength: tileSide)
            tile.center = CGPointMake(xOffset + CGFloat(index)*(tileSide + self.TileMargin), ScreenHeight/2 - (tileSide / 2))
            self.view.addSubview(tile)
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
        self.controller.refreshData()
        if (controller.hangmanData.getTargetWord() != "" && controller.upc != ""){
            SwiftSpinner.show("Scanning")
            controller.playHangman(controller.upc){ responseObject, error in
                // Display feedback message if letter is an incorrect guess
                if error != nil {
                    SwiftSpinner.show("Problem scanning. Try again!", animated: false)
                } else {
                    SwiftSpinner.show("", animated: false)
                    SwiftSpinner.setTitleFont(UIFont.systemFontOfSize(100))
                    if (responseObject!["game_state"] == 2){
                        SwiftSpinner.show(self.controller.hangmanData.getCurrentGuess(), animated: false).addTapHandler({}, subtitle: "Not in word")
                        self.delay(1.5){
                            SwiftSpinner.hide()
                        }
                    } else if (responseObject!["game_state"] == 1){
                        SwiftSpinner.show(self.controller.hangmanData.getCurrentGuess(), animated: false).addTapHandler({}, subtitle: "Already guessed.")
                        self.delay(1.5){
                            SwiftSpinner.hide()
                        }
                    }
                    else{
                        // Guess is correct, check for success
                        SwiftSpinner.show(self.controller.hangmanData.getCurrentGuess(), animated: false)
                        self.delay(1.5){
                            SwiftSpinner.hide()
                        }

                        let return_code = self.controller.checkForSuccess()
                        if (return_code == 1) {
                            // Stage is complete
                            self.shouldDisplayStageCompleted = true
                        } else if (return_code == 2){
                            // Level is complete
                            self.shouldDisplayLevelCompleted = true
                        }
                        

                    }
                    self.delay(1.5){
                        self.showProductPopup(responseObject!["product_name"].string!, color: responseObject!["color"].string!, url: responseObject!["product_img"].string!)
                    }
                    
                    let points_earned = responseObject!["points_earned"]
                    self.particles = ["+\(points_earned)"]
                    self.updateMootPoints()
                }
            }
        }
    }
    
    
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController!) -> UIModalPresentationStyle {
        return .None
    }

    override func resetButtonTouched(sender: UIButton) {
        
        let alertController = UIAlertController(title: "Reset", message: "Reset the entire level or just this stage?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let deleteAction = UIAlertAction(title: "Reset Level", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            self.controller.resetCurrentLevel()
            self.controller.reset()
            self.layoutTiles()
            self.setUpLevel()
            if self.controller.level != nil {
                self.header?.levelBadge!.update(self.controller.level!)
            }
        })
        alertController.addAction(deleteAction)
        
        let okAction = UIAlertAction(title: "Reset Stage", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            self.controller.reset()
            self.layoutTiles()
            self.setUpLevel()
            if self.controller.level != nil {
                self.header?.levelBadge!.update(self.controller.level!)
            }
        })
        alertController.addAction(okAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(alert :UIAlertAction!) in
        })
        alertController.addAction(cancelAction)
        

        
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = sender.frame
        presentViewController(alertController, animated: true, completion: nil)
        
    }

    
    /**
        Transition to the "Level Completed" controller, then prepare for new nevel
     */
    override func displayLevelCompletionView(){
        if self.controller.level != nil {
            let level = LevelManager.sharedInstance.getLevelByNumber(self.controller.level!)
            let identifier = "\(level.getVCName())Complete"
            self.performSegueWithIdentifier(identifier, sender: nil)
            self.setUpLevel()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}