//
//  MazeLevelViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 10/23/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit
extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
    }
}

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
        
        let length = tiles.count
        let size_double = sqrt(Double(length))
        let size = Int(size_double)
        
        var row = 0
        var col = 0
        
        for tile in tiles{
            let walls = self.getWalls(tile)
            
            
            let north = evaluateWall(walls[0])
            let west = evaluateWall(walls[1])
            let south = evaluateWall(walls[2])
            let east = evaluateWall(walls[3])

            let frame = CGRect(x: 100 + (100 * (col+1)), y: 200 + (100 * row), width: 100, height: 100)
            let customView = MazeTile(north: north, west: west, south: south, east: east, frame: frame)
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
    
    func getWalls(num: Int) -> String {
        var str = String(num, radix: 2)         // Decimal to binary
        let binaryInt = Int(str)
        str = String(format: "%04d", binaryInt!)        // Pad with zeroes
        return str
    }
    
    func evaluateWall (ch: Character) -> Bool{
        return (ch == "1")
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
