//
//  LevelPickerViewController.swift
//  
//
//  Created by Erin Bleiweiss on 10/15/15.
//
//

import UIKit

class LevelPickerViewController: MootViewController, UICollectionViewDataSource, UICollectionViewDelegate, FlipTransitionProtocol, FlipTransitionCVProtocol {
    
    var finishedTransitioning = true
    
    @IBAction func cancelToLevelPicker(segue:UIStoryboardSegue) {
    }
    
    @IBOutlet weak var levelCollectionView: UICollectionView!
    var tabBar: MootTabBarController?
    var selectedIndexPath: NSIndexPath?
    
    let colors: [UIColor] = [
        mootColors["blue"]!,
        mootColors["green"]!,
        mootColors["red"]!,
        mootColors["yellow"]!
    ]
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        self.levelCollectionView.collectionViewLayout = layout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.itemSize = CGSize(width: ScreenWidth/2, height: ScreenHeight/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        levelCollectionView.dataSource = self
        levelCollectionView.delegate = self
        self.levelCollectionView!.registerClass(LevelCell.self, forCellWithReuseIdentifier: "LevelCell")
        self.levelCollectionView.backgroundColor = UIColor.whiteColor()
        self.levelCollectionView.scrollEnabled = false
        self.levelCollectionView.pagingEnabled = false
        
        LevelManager.sharedInstance.unlockLevel(1)
    }
    

    override func viewWillAppear(animated: Bool) {
        let tabBar = self.parentViewController?.tabBarController as! MootTabBarController
        tabBar.removeCameraButton()
        (self.tabBarController as! MootTabBarController).setupTabColors()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.levelCollectionView.reloadData()
        (self.tabBarController as! MootTabBarController).setupTabColors()
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
        
        let colorIndex: Int = indexPath.row % colors.count
        cell.backgroundColor = colors[colorIndex]
        cell.setLevelforCell(level)

        // Set up cell
        return cell
    }
    
    
    /**
        Behavior when collection cell is selected
     */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let level: Level = LevelManager.sharedInstance.listLevels()[indexPath.row]
        if !level.isLocked(){
            if finishedTransitioning{
                selectedIndexPath = indexPath
                self.navigationController?.pushViewController(level.getVC(), animated: true)
            }
        }
        
    }
    
    
    /**
     Setup size of collection cells
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = levelCollectionView.bounds.size.width/2
        let height = levelCollectionView.bounds.size.height/2
        return CGSize(width: width, height: height)
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
    
    


}
