//
//  MazeLevelViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 10/23/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class MazeLevelViewController: UIViewController {
    var color: String!
    @IBOutlet weak var colorLabel: UILabel!
    
    @IBAction func cancelToMazeLevelViewController(segue:UIStoryboardSegue) {
        self.colorLabel.text = color
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tiles = [12, 8, 10, 10, 9,
                      7,  5, 12, 9,  5,
                     14, 3, 5,  6,  3,
                     12, 9, 6,  9,  13,
                      7,  6, 10, 2,  3]
        
        let size = tiles.count
        var row = 0
        var col = 0
        
        for tile in tiles{
            let walls = self.getWalls(tile)
            
//            let north = Int(walls[0]) == 0 ? false : true
//            let west = Int(walls[1]) == 0 ? false : true
//            let south = Int(walls[2]) == 0 ? false : true
//            let east = Int(walls[3]) == 0 ? false : true
            
            let north = true
            let south = true
            let east = true
            let west = true
            
            let frame = CGRect(x: 100 + (100 * (col+1)), y: (100 * row), width: 100, height: 100)
            let customView = MazeTile(frame: frame, north: north, west: west, south: south, east: east)
            customView.backgroundColor = UIColor(white: 1, alpha: 0.5)
            
            self.view.addSubview(customView)
            col++
            if (col >= size){
                col=0
                row++
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func getWalls(num: Int) -> [String] {
        var str = String(num, radix: 2)         // Decimal to binary
        str = String(format: "%4d", str)        // Pad with zeroes
        let result = Array(arrayLiteral: str)   // String to array
    
        return result
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
