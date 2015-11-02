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
    var upc: String = ""
    var productName: String = ""
    var targetWord: String = ""
    var currentGuess: String = ""
    var currentGame: String = ""
    var guess: String!
    
    @IBAction func cancelToHangmanLevelViewController(segue:UIStoryboardSegue) {
//        self.currentGameLabel.text = productName
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initial load, no target word
        if (targetWord == "") {
            // Generate target word
            getRandomWord(){ responseObject, error in
                print("responseObject = \(responseObject); error = \(error)")
                self.targetWord = responseObject!
                self.currentGame = ""
                
                // On load, generate blank game
                for _ in 1...self.targetWord.characters.count {
                    self.currentGame += "_"
                }
                
                let attributes = [
                    NSFontAttributeName: UIFont(
                                            name: "Anonymous",
                                            size: 50.0
                                        )!,
                    NSKernAttributeName: 15
                ]
                self.currentGameLabel.attributedText = NSMutableAttributedString(string: self.currentGame, attributes: attributes)
             
                self.currentGuessLabel.text = ""
                
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

                let attributes = [
                    NSFontAttributeName: UIFont(
                        name: "Anonymous",
                        size: 50.0
                        )!,
                    NSKernAttributeName: 15
                ]
                self.currentGameLabel.attributedText = NSMutableAttributedString(string: self.currentGame, attributes: attributes)
                
            }
        }
    }
    
    // Get random word from DB
    func getRandomWord(completionHandler: (responseObject: String?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/generate_random_word"
        Alamofire.request(.GET, url).responseJSON { (_, _, result) in
            
            let json = JSON(result.value!)
            if let word = json["word"].string{
                completionHandler(responseObject: word, error: result.error as? NSError)
            } else {
                completionHandler(responseObject: "Not Found", error: result.error as? NSError)
            }
            
        }
    }
    
    
    func playHangman(upc: String, completionHandler: (responseObject: String?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/play_hangman"
        Alamofire.request(.GET, url, parameters: ["upc": upc, "target_word": targetWord, "letters_guessed": currentGame]).responseJSON { (_, _, result) in
            
            let json = JSON(result.value!)
            if let letters_guessed = json["letters_guessed"].string{
                self.currentGuessLabel.text = json["guess"].string
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