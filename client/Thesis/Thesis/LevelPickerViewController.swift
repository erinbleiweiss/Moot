//
//  LevelPickerViewController.swift
//  
//
//  Created by Erin Bleiweiss on 10/15/15.
//
//

import UIKit

class LevelPickerViewController: MootViewController, UICollectionViewDataSource, UICollectionViewDelegate, FlipTransitionProtocol, FlipTransitionCVProtocol {
    @IBAction func cancelToLevelPicker(segue:UIStoryboardSegue) {
    }
    
    @IBOutlet weak var levelCollectionView: UICollectionView!
    var tabBar: MootTabBarController?
    var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        print("viewdidload")
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        self.levelCollectionView.collectionViewLayout = layout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
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
    
    /**
        Returns number of collection cells to display
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let allLevels = LevelManager.sharedInstance.listLevels()
        return allLevels.count
    }
    
    /**
        Setup collection cells
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = levelCollectionView.dequeueReusableCellWithReuseIdentifier("LevelCell", forIndexPath: indexPath) as! LevelCell
        let level: Level = LevelManager.sharedInstance.listLevels()[indexPath.row]
        cell.setLevelforCell(level)
        cell.layoutSubviews()

        // Set up cell
        return cell
    }
    
    
    /**
        Behavior when collection cell is selected
     */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let level: Level = LevelManager.sharedInstance.listLevels()[indexPath.row]
        if !level.isLocked(){
            selectedIndexPath = indexPath
            self.navigationController?.modalTransitionStyle = .FlipHorizontal
            self.navigationController?.pushViewController(level.getVC(), animated: true)
        }
        
    }
    
    
    /**
     Setup size of collection cells
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: ScreenWidth/2, height: ScreenHeight/2)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0) // margin between cells
    }
    
    
    
    func flipViewForTransition(transition: FlipTransition) -> UIView? {
        return self.view
    }

    func transitionCollectionView() -> UICollectionView!{
        return self.levelCollectionView
    }
    
    func getSelectedCell() -> LevelCell! {
        return levelCollectionView.cellForItemAtIndexPath(self.selectedIndexPath!) as! LevelCell
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
