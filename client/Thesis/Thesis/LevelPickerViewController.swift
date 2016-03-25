//
//  LevelPickerViewController.swift
//  
//
//  Created by Erin Bleiweiss on 10/15/15.
//
//

import UIKit

class LevelPickerViewController: MootViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBAction func cancelToLevelPicker(segue:UIStoryboardSegue) {
    }
    
    @IBOutlet weak var levelCollectionView: UICollectionView!
    var levelTiles: [LevelTile] = []
    var tabBar: MootTabBarController?
    
    override func viewDidLoad() {
        print("viewdidload")
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true

        levelCollectionView.dataSource = self
        levelCollectionView.delegate = self
        self.levelCollectionView!.registerClass(LevelCell.self, forCellWithReuseIdentifier: "LevelCell")
        self.levelCollectionView.backgroundColor = UIColor.whiteColor()
        
        LevelManager.sharedInstance.unlockLevel(1)
    }

    override func viewWillAppear(animated: Bool) {
        let tabBar = self.parentViewController?.tabBarController as! MootTabBarController
        tabBar.removeCameraButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.levelCollectionView.reloadData()

    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let allLevels = LevelManager.sharedInstance.listLevels()
        return allLevels.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = levelCollectionView.dequeueReusableCellWithReuseIdentifier("LevelCell", forIndexPath: indexPath) as! LevelCell
        let level: Level = LevelManager.sharedInstance.listLevels()[indexPath.row]
        cell.setLevelforCell(level)
        cell.backgroundColor = UIColor.blueColor()

        // Set up cell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let level: Level = LevelManager.sharedInstance.listLevels()[indexPath.row]
        if !level.isLocked(){
            self.navigationController?.pushViewController(level.getVC(), animated: true)
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
