//
//  LevelPickerViewController.swift
//  
//
//  Created by Erin Bleiweiss on 10/15/15.
//
//

import UIKit

protocol UIViewLoading {}
extension UIView : UIViewLoading {}

extension UIViewLoading where Self : UIView {
    
    /**
     Creates a new instance of the class on which this method is invoked,
     instantiated from a nib of the given name. If no nib name is given
     then a nib with the name of the class is used.
     
     - Parameter nibNameOrNil: The name of the nib to instantiate from, or
     nil to indicate the nib with the name of the class should be used.
     
     - Returns: A new instance of the class, loaded from a nib.
     */
    
    static func loadFromNib(nibNameOrNil: String? = nil) -> Self {
        let nibName = nibNameOrNil ?? self.className
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiateWithOwner(self, options: nil).first as! Self
    }
    
    static private var className: String {
        let className = "\(self)"
        let components = className.characters.split{$0 == "."}.map ( String.init )
        return components.last!
    }
    
}


class LevelPickerViewController: UIViewController, UIViewLoading {
    @IBAction func cancelToLevelPicker(segue:UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.displayLevelTiles()
        
    }
    
    
    /**
        Using LevelManager singleton, display grid of UIButtons (custom class LevelTile). Add targets that respond to clickPressed()
     
        - Parameters: none
    */
    func displayLevelTiles(){
        let allLevels = LevelManager.sharedInstance.listLevels()
        
        let length = allLevels.count
        let size = 3
        
        var row = 0
        var col = 0
        
        for level in allLevels{
            let frame = CGRect(x: 50 + (100 * (col+1)), y: 200 + (100 * row), width: 100, height: 100)
            //            let button = UIButton(frame: frame)
            
            let levelView = LevelTile(level: level, frame: frame)
            levelView.addTarget(self, action: "clickPressed:", forControlEvents: .TouchUpInside)
            
            //            levelView.backgroundColor = UIColor(white: 1, alpha: 0.5)
            levelView.backgroundColor = UIColor.blueColor()
            
            self.view.addSubview(levelView)
            col++
            if (col >= size){
                col=0
                row++
            }
            
        }
    }


    
    
    /**
        Target action, called for each of the LevelTile buttons.  Presents root view controller, defined in Level object
     
        - Parameters:
            - sender: LevelTile (UIButton subclass)
    
    */
    func clickPressed(sender: LevelTile!){
        presentViewController(sender.rootVC!, animated: true, completion: nil)
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
