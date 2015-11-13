//
//  HangmanLevelViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 10/23/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit
import Alamofire


class HangmanLevelViewController: GenericLevelViewController {
    
    @IBOutlet weak var currentGameLabel: UILabel!
    @IBOutlet weak var currentGuessLabel: UILabel!
    @IBOutlet weak var gameMessageLabel: UILabel!
    var upc: String = ""
    var productName: String = ""
    var targetWord: String = ""
    var currentGuess: String = ""
    var currentGame: String = ""
    var guess: String!
    
    private let controller: HangmanGameController
    required init?(coder aDecoder: NSCoder) {
        controller = HangmanGameController()
        super.init(coder: aDecoder)
    }
    
    private var gameTiles = [HangmanTile]()
    let TileMargin: CGFloat = 20.0
    
    @IBAction func cancelToHangmanLevelViewController(segue:UIStoryboardSegue) {
//        self.currentGameLabel.text = productName
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let level1 = Level(levelNumber: 1)

        //add one layer for all game elements
        let gameView = UIView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight))
        self.view.addSubview(gameView)
//        controller.gameView = gameView
        

        // Initial load, no target word
        if (targetWord == "") {
            // Generate target word
            controller.getRandomWord(){ responseObject, error in
                print("responseObject = \(responseObject); error = \(error)")
                self.targetWord = responseObject!
                self.currentGame = ""
                
                //calculate the tile size
                let tileSide = ceil(ScreenWidth * 0.9 / CGFloat(self.targetWord.characters.count)) - self.TileMargin
                
                //get the left margin for first tile
                var xOffset = (ScreenWidth - CGFloat(self.targetWord.characters.count) * (tileSide + self.TileMargin)) / 2.0
                
                //adjust for tile center (instead of the tile's origin)
                xOffset += tileSide / 2.0
                
                // On load, generate blank game
                for (index, _) in self.targetWord.characters.enumerate() {
                    self.currentGame += "_"
                    let tile = HangmanTile(letter: "_", sideLength: tileSide)
                    tile.center = CGPointMake(xOffset + CGFloat(index)*(tileSide + self.TileMargin), ScreenHeight/4*3)
                    
                    gameView.addSubview(tile)
                    self.gameTiles.append(tile)
                    
                }

                self.currentGameLabel.attributedText = self.letterStyles(self.currentGame)
                self.currentGuessLabel.attributedText = self.guessStyles(self.currentGuess)
                
            }
            
        }
        else {
            playHangman(self.upc){ responseObject, error in
                self.currentGame = responseObject!
                self.currentGameLabel.text = responseObject!
            }
        }

    
    }
    
    
    override func viewDidAppear(animated: Bool) {
        if (self.targetWord != "" && self.upc != ""){
            playHangman(self.upc){ responseObject, error in
                
                self.currentGame = responseObject!
                self.currentGameLabel.attributedText = self.letterStyles(self.currentGame)
                
            }
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
    
//    // Get random word from DB
//    func getRandomWord(completionHandler: (responseObject: String?, error: NSError?) -> ()) {
//        let url: String = hostname + rest_prefix + "/generate_random_word"
//        Alamofire.request(.GET, url).responseJSON { (_, _, result) in
//            
//            let json = JSON(result.value!)
//            if let word = json["word"].string{
//                completionHandler(responseObject: word, error: result.error as? NSError)
//            } else {
//                completionHandler(responseObject: "Not Found", error: result.error as? NSError)
//            }
//            
//        }
//    }
    
    
    func playHangman(upc: String, completionHandler: (responseObject: String?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/play_hangman"
        Alamofire.request(.GET, url, parameters: ["upc": upc, "target_word": targetWord, "letters_guessed": currentGame]).responseJSON { (_, _, result) in
            
            let json = JSON(result.value!)
            if let letters_guessed = json["letters_guessed"].string{
                self.currentGuessLabel.attributedText = self.guessStyles(json["guess"].string!)
                if (json["status"] == 2){
                    self.gameMessageLabel.text = "Not in word"
                }
                else{
                    self.gameMessageLabel.text = ""
                }
                completionHandler(responseObject: letters_guessed, error: result.error as? NSError)
            } else {
                completionHandler(responseObject: "Not Found", error: result.error as? NSError)
            }
            
            
        }
        
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