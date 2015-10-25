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
    var productName: String!
    @IBOutlet weak var productLabel: UILabel!
    var targetWord: String!
    var currentGame: String!
    var guess: String!
    
    @IBAction func cancelToHangmanLevelViewController(segue:UIStoryboardSegue) {
        self.productLabel.text = productName
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRandomWord(){ responseObject, error in
            print("responseObject = \(responseObject); error = \(error)")
            self.targetWord = responseObject!
        }
        
//        playHangman(detectionString){ responseObject, error in
//            print("responseObject = \(responseObject); error = \(error)")
//            self.productName = responseObject!
//            self.performSegueWithIdentifier("barcodeScannedSegue", sender: nil)
//        }
    
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
            if let guess = json["guess"].string{
                completionHandler(responseObject: guess, error: result.error as? NSError)
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