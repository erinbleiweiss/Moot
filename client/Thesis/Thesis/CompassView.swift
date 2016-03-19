//
//  CompassView.swift
//
//  Code generated using QuartzCode 1.39.12 on 3/19/16.
//  www.quartzcodeapp.com
//

import UIKit


extension CALayer {
    private struct AssociatedKeys {
        static var DescriptiveName = "nsh_DescriptiveName"
    }
    
    @IBInspectable var descriptiveName: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.DescriptiveName) as? String
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.DescriptiveName,
                    newValue as NSString?,
                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
}

class CompassView: UIView {
    
    var layers : Dictionary<String, AnyObject> = [:]
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperties()
        setupLayers()
        for (idx, layer) in self.layers{
            print(layer.descriptiveName)
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setupProperties()
        setupLayers()
    }
    
    override var frame: CGRect{
        didSet{
            setupLayerFrames()
        }
    }
    
    override var bounds: CGRect{
        didSet{
            setupLayerFrames()
        }
    }
    
    func getArrow() -> CAShapeLayer {
        let arrow = layers["arrow"] as! CAShapeLayer
        return arrow
    }
    
    func setupProperties(){
        
    }
    
    func setupLayers(){
        let Colors = CALayer()
        Colors.descriptiveName = "Colors"
        self.layer.addSublayer(Colors)
        layers["Colors"] = Colors
        let red = CAShapeLayer()
        red.descriptiveName = "red"
        Colors.addSublayer(red)
        layers["red"] = red
        let orange = CAShapeLayer()
        orange.descriptiveName = "orange"
        Colors.addSublayer(orange)
        layers["orange"] = orange
        let yellow = CAShapeLayer()
        yellow.descriptiveName = "yellow"
        Colors.addSublayer(yellow)
        layers["yellow"] = yellow
        let greenyellow = CAShapeLayer()
        greenyellow.descriptiveName = "greenyellow"
        Colors.addSublayer(greenyellow)
        layers["greenyellow"] = greenyellow
        let green = CAShapeLayer()
        green.descriptiveName = "green"
        Colors.addSublayer(green)
        layers["green"] = green
        let teal = CAShapeLayer()
        teal.descriptiveName = "teal"
        Colors.addSublayer(teal)
        layers["teal"] = teal
        let blue = CAShapeLayer()
        blue.descriptiveName = "blue"
        Colors.addSublayer(blue)
        layers["blue"] = blue
        let purple = CAShapeLayer()
        purple.descriptiveName = "purple"
        Colors.addSublayer(purple)
        layers["purple"] = purple
        
        let Compass = CALayer()
        Compass.descriptiveName = "Compass"
        self.layer.addSublayer(Compass)
        layers["Compass"] = Compass
        let Main = CALayer()
        Main.descriptiveName = "Main"
        Compass.addSublayer(Main)
        layers["Main"] = Main
        let rose = CAShapeLayer()
        rose.descriptiveName = "rose"
        Main.addSublayer(rose)
        layers["rose"] = rose
        let rose2 = CAShapeLayer()
        rose2.descriptiveName = "rose2"
        Main.addSublayer(rose2)
        layers["rose2"] = rose2
        let rose3 = CAShapeLayer()
        rose3.descriptiveName = "rose3"
        Main.addSublayer(rose3)
        layers["rose3"] = rose3
        let rose4 = CAShapeLayer()
        rose4.descriptiveName = "rose4"
        Main.addSublayer(rose4)
        layers["rose4"] = rose4
        let rose5 = CAShapeLayer()
        rose5.descriptiveName = "rose5"
        Main.addSublayer(rose5)
        layers["rose5"] = rose5
        let rose6 = CAShapeLayer()
        rose6.descriptiveName = "rose6"
        Main.addSublayer(rose6)
        layers["rose6"] = rose6
        let rose7 = CAShapeLayer()
        rose7.descriptiveName = "rose7"
        Main.addSublayer(rose7)
        layers["rose7"] = rose7
        let rose8 = CAShapeLayer()
        rose8.descriptiveName = "rose8"
        Main.addSublayer(rose8)
        layers["rose8"] = rose8
        let Ticks = CALayer()
        Ticks.descriptiveName = "Ticks"
        Compass.addSublayer(Ticks)
        layers["Ticks"] = Ticks
        let path = CAShapeLayer()
        path.descriptiveName = "path"
        Ticks.addSublayer(path)
        layers["path"] = path
        let path2 = CAShapeLayer()
        path2.descriptiveName = "path2"
        Ticks.addSublayer(path2)
        layers["path2"] = path2
        let path3 = CAShapeLayer()
        path3.descriptiveName = "path3"
        Ticks.addSublayer(path3)
        layers["path3"] = path3
        let path4 = CAShapeLayer()
        path4.descriptiveName = "path4"
        Ticks.addSublayer(path4)
        layers["path4"] = path4
        let path5 = CAShapeLayer()
        path5.descriptiveName = "path5"
        Ticks.addSublayer(path5)
        layers["path5"] = path5
        let path6 = CAShapeLayer()
        path6.descriptiveName = "path6"
        Ticks.addSublayer(path6)
        layers["path6"] = path6
        let path7 = CAShapeLayer()
        path7.descriptiveName = "path7"
        Ticks.addSublayer(path7)
        layers["path7"] = path7
        let path8 = CAShapeLayer()
        path8.descriptiveName = "path8"
        Ticks.addSublayer(path8)
        layers["path8"] = path8
        let center = CAShapeLayer()
        center.descriptiveName = "center"
        Compass.addSublayer(center)
        layers["center"] = center
        
        let Arrow = CALayer()
        Arrow.descriptiveName = "Arrow"
        self.layer.addSublayer(Arrow)
        layers["Arrow"] = Arrow
        let arrow = CAShapeLayer()
        arrow.descriptiveName = "arrow"
        Arrow.addSublayer(arrow)
        layers["arrow"] = arrow
        
        resetLayerPropertiesForLayerIdentifiers(nil)
        setupLayerFrames()
    }
    
    func resetLayerPropertiesForLayerIdentifiers(layerIds: [String]!){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if layerIds == nil || layerIds.contains("red"){
            let red = layers["red"] as! CAShapeLayer
            red.fillColor = UIColor(red:0.718, green: 0.196, blue:0.2, alpha:1).CGColor
            red.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("orange"){
            let orange = layers["orange"] as! CAShapeLayer
            orange.fillColor = UIColor(red:0.937, green: 0.498, blue:0.00392, alpha:1).CGColor
            orange.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("yellow"){
            let yellow = layers["yellow"] as! CAShapeLayer
            yellow.fillColor = UIColor(red:0.988, green: 0.792, blue:0.31, alpha:1).CGColor
            yellow.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("greenyellow"){
            let greenyellow = layers["greenyellow"] as! CAShapeLayer
            greenyellow.fillColor = UIColor(red:0.784, green: 0.824, blue:0.098, alpha:1).CGColor
            greenyellow.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("green"){
            let green = layers["green"] as! CAShapeLayer
            green.fillColor = UIColor(red:0.545, green: 0.643, blue:0.0314, alpha:1).CGColor
            green.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("teal"){
            let teal = layers["teal"] as! CAShapeLayer
            teal.fillColor = UIColor(red:0.00392, green: 0.533, blue:0.518, alpha:1).CGColor
            teal.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("blue"){
            let blue = layers["blue"] as! CAShapeLayer
            blue.fillColor = UIColor(red:0, green: 0.447, blue:0.725, alpha:1).CGColor
            blue.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("purple"){
            let purple = layers["purple"] as! CAShapeLayer
            purple.fillColor = UIColor(red:0.627, green: 0.333, blue:0.596, alpha:1).CGColor
            purple.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("rose"){
            let rose = layers["rose"] as! CAShapeLayer
            rose.fillColor = UIColor(red:0.502, green: 0.502, blue:0.502, alpha:1).CGColor
            rose.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("rose2"){
            let rose2 = layers["rose2"] as! CAShapeLayer
            rose2.fillColor = UIColor(red:0.8, green: 0.8, blue:0.8, alpha:1).CGColor
            rose2.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("rose3"){
            let rose3 = layers["rose3"] as! CAShapeLayer
            rose3.fillColor = UIColor(red:0.502, green: 0.502, blue:0.502, alpha:1).CGColor
            rose3.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("rose4"){
            let rose4 = layers["rose4"] as! CAShapeLayer
            rose4.fillColor = UIColor(red:0.8, green: 0.8, blue:0.8, alpha:1).CGColor
            rose4.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("rose5"){
            let rose5 = layers["rose5"] as! CAShapeLayer
            rose5.fillColor = UIColor(red:0.502, green: 0.502, blue:0.502, alpha:1).CGColor
            rose5.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("rose6"){
            let rose6 = layers["rose6"] as! CAShapeLayer
            rose6.fillColor = UIColor(red:0.8, green: 0.8, blue:0.8, alpha:1).CGColor
            rose6.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("rose7"){
            let rose7 = layers["rose7"] as! CAShapeLayer
            rose7.fillColor = UIColor(red:0.502, green: 0.502, blue:0.502, alpha:1).CGColor
            rose7.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("rose8"){
            let rose8 = layers["rose8"] as! CAShapeLayer
            rose8.fillColor = UIColor(red:0.8, green: 0.8, blue:0.8, alpha:1).CGColor
            rose8.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("path"){
            let path = layers["path"] as! CAShapeLayer
            path.fillColor = UIColor(red:0.2, green: 0.2, blue:0.2, alpha:1).CGColor
            path.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("path2"){
            let path2 = layers["path2"] as! CAShapeLayer
            path2.fillColor = UIColor(red:0.2, green: 0.2, blue:0.2, alpha:1).CGColor
            path2.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("path3"){
            let path3 = layers["path3"] as! CAShapeLayer
            path3.fillColor = UIColor(red:0.2, green: 0.2, blue:0.2, alpha:1).CGColor
            path3.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("path4"){
            let path4 = layers["path4"] as! CAShapeLayer
            path4.fillColor = UIColor(red:0.2, green: 0.2, blue:0.2, alpha:1).CGColor
            path4.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("path5"){
            let path5 = layers["path5"] as! CAShapeLayer
            path5.fillColor = UIColor(red:0.2, green: 0.2, blue:0.2, alpha:1).CGColor
            path5.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("path6"){
            let path6 = layers["path6"] as! CAShapeLayer
            path6.fillColor = UIColor(red:0.2, green: 0.2, blue:0.2, alpha:1).CGColor
            path6.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("path7"){
            let path7 = layers["path7"] as! CAShapeLayer
            path7.fillColor = UIColor(red:0.2, green: 0.2, blue:0.2, alpha:1).CGColor
            path7.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("path8"){
            let path8 = layers["path8"] as! CAShapeLayer
            path8.fillColor = UIColor(red:0.2, green: 0.2, blue:0.2, alpha:1).CGColor
            path8.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("center"){
            let center = layers["center"] as! CAShapeLayer
            center.fillColor = UIColor.blackColor().CGColor
            center.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("arrow"){
            let arrow = layers["arrow"] as! CAShapeLayer
            arrow.fillColor = UIColor.blackColor().CGColor
            arrow.lineWidth = 0
        }
        
        CATransaction.commit()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let Colors : CALayer = layers["Colors"] as? CALayer{
            Colors.frame = CGRectMake(0.0371 * Colors.superlayer!.bounds.width, 0.03665 * Colors.superlayer!.bounds.height, 0.92579 * Colors.superlayer!.bounds.width, 0.9267 * Colors.superlayer!.bounds.height)
        }
        
        if let red : CAShapeLayer = layers["red"] as? CAShapeLayer{
            red.frame = CGRectMake(0.30935 * red.superlayer!.bounds.width, 0, 0.38312 * red.superlayer!.bounds.width, 0.16333 * red.superlayer!.bounds.height)
            red.path  = redPathWithBounds((layers["red"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let orange : CAShapeLayer = layers["orange"] as? CAShapeLayer{
            orange.frame = CGRectMake(0.64195 * orange.superlayer!.bounds.width, 0.03916 * orange.superlayer!.bounds.height, 0.31934 * orange.superlayer!.bounds.width, 0.31931 * orange.superlayer!.bounds.height)
            orange.path  = orangePathWithBounds((layers["orange"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let yellow : CAShapeLayer = layers["yellow"] as? CAShapeLayer{
            yellow.frame = CGRectMake(0.8389 * yellow.superlayer!.bounds.width, 0.30827 * yellow.superlayer!.bounds.height, 0.1611 * yellow.superlayer!.bounds.width, 0.38333 * yellow.superlayer!.bounds.height)
            yellow.path  = yellowPathWithBounds((layers["yellow"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let greenyellow : CAShapeLayer = layers["greenyellow"] as? CAShapeLayer{
            greenyellow.frame = CGRectMake(0.64723 * greenyellow.superlayer!.bounds.width, 0.63386 * greenyellow.superlayer!.bounds.height, 0.31558 * greenyellow.superlayer!.bounds.width, 0.32752 * greenyellow.superlayer!.bounds.height)
            greenyellow.path  = greenyellowPathWithBounds((layers["greenyellow"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let green : CAShapeLayer = layers["green"] as? CAShapeLayer{
            green.frame = CGRectMake(0.30838 * green.superlayer!.bounds.width, 0.83621 * green.superlayer!.bounds.height, 0.38532 * green.superlayer!.bounds.width, 0.16379 * green.superlayer!.bounds.height)
            green.path  = greenPathWithBounds((layers["green"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let teal : CAShapeLayer = layers["teal"] as? CAShapeLayer{
            teal.frame = CGRectMake(0.03762 * teal.superlayer!.bounds.width, 0.63891 * teal.superlayer!.bounds.height, 0.32722 * teal.superlayer!.bounds.width, 0.3232 * teal.superlayer!.bounds.height)
            teal.path  = tealPathWithBounds((layers["teal"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let blue : CAShapeLayer = layers["blue"] as? CAShapeLayer{
            blue.frame = CGRectMake(0, 0.30663 * blue.superlayer!.bounds.height, 0.16287 * blue.superlayer!.bounds.width, 0.38463 * blue.superlayer!.bounds.height)
            blue.path  = bluePathWithBounds((layers["blue"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let purple : CAShapeLayer = layers["purple"] as? CAShapeLayer{
            purple.frame = CGRectMake(0.03846 * purple.superlayer!.bounds.width, 0.03821 * purple.superlayer!.bounds.height, 0.32404 * purple.superlayer!.bounds.width, 0.31981 * purple.superlayer!.bounds.height)
            purple.path  = purplePathWithBounds((layers["purple"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let Compass : CALayer = layers["Compass"] as? CALayer{
            Compass.frame = CGRectMake(0.0371 * Compass.superlayer!.bounds.width, 0.0383 * Compass.superlayer!.bounds.height, 0.92579 * Compass.superlayer!.bounds.width, 0.92505 * Compass.superlayer!.bounds.height)
        }
        
        if let Main : CALayer = layers["Main"] as? CALayer{
            Main.frame = CGRectMake(0.03894 * Main.superlayer!.bounds.width, 0.03469 * Main.superlayer!.bounds.height, 0.92341 * Main.superlayer!.bounds.width, 0.92634 * Main.superlayer!.bounds.height)
        }
        
        if let rose : CAShapeLayer = layers["rose"] as? CAShapeLayer{
            rose.frame = CGRectMake(0.29197 * rose.superlayer!.bounds.width, 0, 0.21034 * rose.superlayer!.bounds.width, 0.50356 * rose.superlayer!.bounds.height)
            rose.path  = rosePathWithBounds((layers["rose"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let rose2 : CAShapeLayer = layers["rose2"] as? CAShapeLayer{
            rose2.frame = CGRectMake(0.50064 * rose2.superlayer!.bounds.width, 0.00262 * rose2.superlayer!.bounds.height, 0.20674 * rose2.superlayer!.bounds.width, 0.49882 * rose2.superlayer!.bounds.height)
            rose2.path  = rose2PathWithBounds((layers["rose2"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let rose3 : CAShapeLayer = layers["rose3"] as? CAShapeLayer{
            rose3.frame = CGRectMake(0.4985 * rose3.superlayer!.bounds.width, 0.2939 * rose3.superlayer!.bounds.height, 0.50124 * rose3.superlayer!.bounds.width, 0.21079 * rose3.superlayer!.bounds.height)
            rose3.path  = rose3PathWithBounds((layers["rose3"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let rose4 : CAShapeLayer = layers["rose4"] as? CAShapeLayer{
            rose4.frame = CGRectMake(0.5 * rose4.superlayer!.bounds.width, 0.50144 * rose4.superlayer!.bounds.height, 0.5 * rose4.superlayer!.bounds.width, 0.20689 * rose4.superlayer!.bounds.height)
            rose4.path  = rose4PathWithBounds((layers["rose4"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let rose5 : CAShapeLayer = layers["rose5"] as? CAShapeLayer{
            rose5.frame = CGRectMake(0.49643 * rose5.superlayer!.bounds.width, 0.49577 * rose5.superlayer!.bounds.height, 0.2116 * rose5.superlayer!.bounds.width, 0.50423 * rose5.superlayer!.bounds.height)
            rose5.path  = rose5PathWithBounds((layers["rose5"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let rose6 : CAShapeLayer = layers["rose6"] as? CAShapeLayer{
            rose6.frame = CGRectMake(0.29197 * rose6.superlayer!.bounds.width, 0.50118 * rose6.superlayer!.bounds.height, 0.20969 * rose6.superlayer!.bounds.width, 0.49882 * rose6.superlayer!.bounds.height)
            rose6.path  = rose6PathWithBounds((layers["rose6"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let rose7 : CAShapeLayer = layers["rose7"] as? CAShapeLayer{
            rose7.frame = CGRectMake(0, 0.50079 * rose7.superlayer!.bounds.height, 0.49974 * rose7.superlayer!.bounds.width, 0.20754 * rose7.superlayer!.bounds.height)
            rose7.path  = rose7PathWithBounds((layers["rose7"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let rose8 : CAShapeLayer = layers["rose8"] as? CAShapeLayer{
            rose8.frame = CGRectMake(0, 0.29455 * rose8.superlayer!.bounds.height, 0.5 * rose8.superlayer!.bounds.width, 0.20689 * rose8.superlayer!.bounds.height)
            rose8.path  = rose8PathWithBounds((layers["rose8"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let Ticks : CALayer = layers["Ticks"] as? CALayer{
            Ticks.frame = CGRectMake(0, 0,  Ticks.superlayer!.bounds.width,  Ticks.superlayer!.bounds.height)
        }
        
        if let path : CAShapeLayer = layers["path"] as? CAShapeLayer{
            path.frame = CGRectMake(0.48375 * path.superlayer!.bounds.width, 0, 0.03491 * path.superlayer!.bounds.width, 0.13238 * path.superlayer!.bounds.height)
            path.path  = pathPathWithBounds((layers["path"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let path2 : CAShapeLayer = layers["path2"] as? CAShapeLayer{
            path2.frame = CGRectMake(0, 0.48159 * path2.superlayer!.bounds.height, 0.13525 * path2.superlayer!.bounds.width, 0.03572 * path2.superlayer!.bounds.height)
            path2.path  = path2PathWithBounds((layers["path2"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let path3 : CAShapeLayer = layers["path3"] as? CAShapeLayer{
            path3.frame = CGRectMake(0.14877 * path3.superlayer!.bounds.width, 0.14743 * path3.superlayer!.bounds.height, 0.10575 * path3.superlayer!.bounds.width, 0.10648 * path3.superlayer!.bounds.height)
            path3.path  = path3PathWithBounds((layers["path3"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let path4 : CAShapeLayer = layers["path4"] as? CAShapeLayer{
            path4.frame = CGRectMake(0.14545 * path4.superlayer!.bounds.width, 0.74513 * path4.superlayer!.bounds.height, 0.10732 * path4.superlayer!.bounds.width, 0.10703 * path4.superlayer!.bounds.height)
            path4.path  = path4PathWithBounds((layers["path4"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let path5 : CAShapeLayer = layers["path5"] as? CAShapeLayer{
            path5.frame = CGRectMake(0.4799 * path5.superlayer!.bounds.width, 0.86715 * path5.superlayer!.bounds.height, 0.03499 * path5.superlayer!.bounds.width, 0.13285 * path5.superlayer!.bounds.height)
            path5.path  = path5PathWithBounds((layers["path5"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let path6 : CAShapeLayer = layers["path6"] as? CAShapeLayer{
            path6.frame = CGRectMake(0.74582 * path6.superlayer!.bounds.width, 0.75078 * path6.superlayer!.bounds.height, 0.10379 * path6.superlayer!.bounds.width, 0.10417 * path6.superlayer!.bounds.height)
            path6.path  = path6PathWithBounds((layers["path6"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let path7 : CAShapeLayer = layers["path7"] as? CAShapeLayer{
            path7.frame = CGRectMake(0.86816 * path7.superlayer!.bounds.width, 0.48585 * path7.superlayer!.bounds.height, 0.13184 * path7.superlayer!.bounds.width, 0.0348 * path7.superlayer!.bounds.height)
            path7.path  = path7PathWithBounds((layers["path7"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let path8 : CAShapeLayer = layers["path8"] as? CAShapeLayer{
            path8.frame = CGRectMake(0.75007 * path8.superlayer!.bounds.width, 0.15011 * path8.superlayer!.bounds.height, 0.10499 * path8.superlayer!.bounds.width, 0.10461 * path8.superlayer!.bounds.height)
            path8.path  = path8PathWithBounds((layers["path8"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let center : CAShapeLayer = layers["center"] as? CAShapeLayer{
            center.frame = CGRectMake(0.47827 * center.superlayer!.bounds.width, 0.47825 * center.superlayer!.bounds.height, 0.04346 * center.superlayer!.bounds.width, 0.04349 * center.superlayer!.bounds.height)
            center.path  = centerPathWithBounds((layers["center"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let Arrow : CALayer = layers["Arrow"] as? CALayer{
            Arrow.frame = CGRectMake(0.40248 * Arrow.superlayer!.bounds.width, 0.03665 * Arrow.superlayer!.bounds.height, 0.19503 * Arrow.superlayer!.bounds.width, 0.9267 * Arrow.superlayer!.bounds.height)
        }
        
        if let arrow : CAShapeLayer = layers["arrow"] as? CAShapeLayer{
            arrow.frame = CGRectMake(0, 0,  arrow.superlayer!.bounds.width, 1 * arrow.superlayer!.bounds.height)
            arrow.path  = arrowPathWithBounds((layers["arrow"] as! CAShapeLayer).bounds).CGPath;
        }
        
        CATransaction.commit()
    }
    
    
    //MARK: - Bezier Path
    
    func redPathWithBounds(bound: CGRect) -> UIBezierPath{
        let redPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        redPath.moveToPoint(CGPointMake(minX + w, minY + 0.23537 * h))
        redPath.addCurveToPoint(CGPointMake(minX + 0.49826 * w, minY), controlPoint1:CGPointMake(minX + 0.84595 * w, minY + 0.08545 * h), controlPoint2:CGPointMake(minX + 0.67546 * w, minY))
        redPath.addCurveToPoint(CGPointMake(minX, minY + 0.2308 * h), controlPoint1:CGPointMake(minX + 0.3218 * w, minY), controlPoint2:CGPointMake(minX + 0.15353 * w, minY + 0.08207 * h))
        redPath.addLineToPoint(CGPointMake(minX, minY + 0.2308 * h))
        redPath.addLineToPoint(CGPointMake(minX + 0.1364 * w, minY + 0.98385 * h))
        redPath.addCurveToPoint(CGPointMake(minX + 0.49826 * w, minY + 0.81801 * h), controlPoint1:CGPointMake(minX + 0.24804 * w, minY + 0.87694 * h), controlPoint2:CGPointMake(minX + 0.37021 * w, minY + 0.81801 * h))
        redPath.addCurveToPoint(CGPointMake(minX + 0.86712 * w, minY + h), controlPoint1:CGPointMake(minX + 0.62705 * w, minY + 0.81801 * h), controlPoint2:CGPointMake(minX + 0.75496 * w, minY + 0.8919 * h))
        redPath.addLineToPoint(CGPointMake(minX + w, minY + 0.23537 * h))
        redPath.closePath()
        redPath.moveToPoint(CGPointMake(minX + w, minY + 0.23537 * h))
        
        return redPath;
    }
    
    func orangePathWithBounds(bound: CGRect) -> UIBezierPath{
        let orangePath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        orangePath.moveToPoint(CGPointMake(minX + w, minY + 0.84023 * h))
        orangePath.addCurveToPoint(CGPointMake(minX + 0.15689 * w, minY), controlPoint1:CGPointMake(minX + 0.84091 * w, minY + 0.46121 * h), controlPoint2:CGPointMake(minX + 0.53674 * w, minY + 0.15802 * h))
        orangePath.addLineToPoint(CGPointMake(minX, minY + 0.38799 * h))
        orangePath.addCurveToPoint(CGPointMake(minX + 0.61366 * w, minY + h), controlPoint1:CGPointMake(minX + 0.27603 * w, minY + 0.50389 * h), controlPoint2:CGPointMake(minX + 0.49717 * w, minY + 0.72447 * h))
        orangePath.addLineToPoint(CGPointMake(minX + w, minY + 0.84023 * h))
        orangePath.closePath()
        orangePath.moveToPoint(CGPointMake(minX + w, minY + 0.84023 * h))
        
        return orangePath;
    }
    
    func yellowPathWithBounds(bound: CGRect) -> UIBezierPath{
        let yellowPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        yellowPath.moveToPoint(CGPointMake(minX + 0.76475 * w, minY + h))
        yellowPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.50146 * h), controlPoint1:CGPointMake(minX + 0.91634 * w, minY + 0.84643 * h), controlPoint2:CGPointMake(minX + w, minY + 0.67805 * h))
        yellowPath.addCurveToPoint(CGPointMake(minX + 0.76186 * w, minY), controlPoint1:CGPointMake(minX + w, minY + 0.32375 * h), controlPoint2:CGPointMake(minX + 0.91527 * w, minY + 0.15436 * h))
        yellowPath.addLineToPoint(CGPointMake(minX, minY + 0.1371 * h))
        yellowPath.addCurveToPoint(CGPointMake(minX + 0.17233 * w, minY + 0.50251 * h), controlPoint1:CGPointMake(minX + 0.11105 * w, minY + 0.24967 * h), controlPoint2:CGPointMake(minX + 0.17233 * w, minY + 0.37308 * h))
        yellowPath.addCurveToPoint(CGPointMake(minX + 0.01352 * w, minY + 0.85389 * h), controlPoint1:CGPointMake(minX + 0.17233 * w, minY + 0.62658 * h), controlPoint2:CGPointMake(minX + 0.11601 * w, minY + 0.74513 * h))
        yellowPath.addLineToPoint(CGPointMake(minX + 0.76475 * w, minY + h))
        yellowPath.closePath()
        yellowPath.moveToPoint(CGPointMake(minX + 0.76475 * w, minY + h))
        
        return yellowPath;
    }
    
    func greenyellowPathWithBounds(bound: CGRect) -> UIBezierPath{
        let greenyellowPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        greenyellowPath.moveToPoint(CGPointMake(minX + w, minY + 0.17104 * h))
        greenyellowPath.addCurveToPoint(CGPointMake(minX + 0.14534 * w, minY + h), controlPoint1:CGPointMake(minX + 0.84083 * w, minY + 0.54469 * h), controlPoint2:CGPointMake(minX + 0.53202 * w, minY + 0.84403 * h))
        greenyellowPath.addLineToPoint(CGPointMake(minX, minY + 0.6186 * h))
        greenyellowPath.addCurveToPoint(CGPointMake(minX + 0.61642 * w, minY), controlPoint1:CGPointMake(minX + 0.28137 * w, minY + 0.49972 * h), controlPoint2:CGPointMake(minX + 0.50443 * w, minY + 0.2766 * h))
        greenyellowPath.addLineToPoint(CGPointMake(minX + w, minY + 0.17104 * h))
        greenyellowPath.closePath()
        greenyellowPath.moveToPoint(CGPointMake(minX + w, minY + 0.17104 * h))
        
        return greenyellowPath;
    }
    
    func greenPathWithBounds(bound: CGRect) -> UIBezierPath{
        let greenPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        greenPath.moveToPoint(CGPointMake(minX, minY + 0.76802 * h))
        greenPath.addCurveToPoint(CGPointMake(minX + 0.4973 * w, minY + h), controlPoint1:CGPointMake(minX + 0.15316 * w, minY + 0.91749 * h), controlPoint2:CGPointMake(minX + 0.32113 * w, minY + h))
        greenPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.76271 * h), controlPoint1:CGPointMake(minX + 0.67554 * w, minY + h), controlPoint2:CGPointMake(minX + 0.84539 * w, minY + 0.91554 * h))
        greenPath.addLineToPoint(CGPointMake(minX + 0.88096 * w, minY))
        greenPath.addCurveToPoint(CGPointMake(minX + 0.4973 * w, minY + 0.18921 * h), controlPoint1:CGPointMake(minX + 0.7636 * w, minY + 0.12166 * h), controlPoint2:CGPointMake(minX + 0.6338 * w, minY + 0.18921 * h))
        greenPath.addCurveToPoint(CGPointMake(minX + 0.14524 * w, minY + 0.03117 * h), controlPoint1:CGPointMake(minX + 0.37293 * w, minY + 0.18921 * h), controlPoint2:CGPointMake(minX + 0.25414 * w, minY + 0.13314 * h))
        greenPath.addLineToPoint(CGPointMake(minX, minY + 0.76802 * h))
        greenPath.closePath()
        greenPath.moveToPoint(CGPointMake(minX, minY + 0.76802 * h))
        
        return greenPath;
    }
    
    func tealPathWithBounds(bound: CGRect) -> UIBezierPath{
        let tealPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        tealPath.moveToPoint(CGPointMake(minX, minY + 0.16091 * h))
        tealPath.addCurveToPoint(CGPointMake(minX + 0.82819 * w, minY + h), controlPoint1:CGPointMake(minX + 0.15461 * w, minY + 0.53985 * h), controlPoint2:CGPointMake(minX + 0.45386 * w, minY + 0.843 * h))
        tealPath.addLineToPoint(CGPointMake(minX + 0.82819 * w, minY + h))
        tealPath.addLineToPoint(CGPointMake(minX + w, minY + 0.62458 * h))
        tealPath.addCurveToPoint(CGPointMake(minX + 0.37477 * w, minY), controlPoint1:CGPointMake(minX + 0.72557 * w, minY + 0.50831 * h), controlPoint2:CGPointMake(minX + 0.48704 * w, minY + 0.27898 * h))
        tealPath.addLineToPoint(CGPointMake(minX, minY + 0.16091 * h))
        tealPath.closePath()
        tealPath.moveToPoint(CGPointMake(minX, minY + 0.16091 * h))
        
        return tealPath;
    }
    
    func bluePathWithBounds(bound: CGRect) -> UIBezierPath{
        let bluePath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        bluePath.moveToPoint(CGPointMake(minX + 0.23182 * w, minY + h))
        bluePath.addCurveToPoint(CGPointMake(minX, minY + 0.50402 * h), controlPoint1:CGPointMake(minX + 0.08243 * w, minY + 0.84718 * h), controlPoint2:CGPointMake(minX, minY + 0.67968 * h))
        bluePath.addCurveToPoint(CGPointMake(minX + 0.23976 * w, minY), controlPoint1:CGPointMake(minX, minY + 0.32528 * h), controlPoint2:CGPointMake(minX + 0.08536 * w, minY + 0.15498 * h))
        bluePath.addLineToPoint(CGPointMake(minX + 0.23976 * w, minY))
        bluePath.addLineToPoint(CGPointMake(minX + w, minY + 0.12994 * h))
        bluePath.addCurveToPoint(CGPointMake(minX + 0.81864 * w, minY + 0.50507 * h), controlPoint1:CGPointMake(minX + 0.88327 * w, minY + 0.24506 * h), controlPoint2:CGPointMake(minX + 0.81864 * w, minY + 0.37187 * h))
        bluePath.addCurveToPoint(CGPointMake(minX + 0.98476 * w, minY + 0.86479 * h), controlPoint1:CGPointMake(minX + 0.81864 * w, minY + 0.63235 * h), controlPoint2:CGPointMake(minX + 0.87766 * w, minY + 0.7538 * h))
        bluePath.addLineToPoint(CGPointMake(minX + 0.23182 * w, minY + h))
        bluePath.closePath()
        bluePath.moveToPoint(CGPointMake(minX + 0.23182 * w, minY + h))
        
        return bluePath;
    }
    
    func purplePathWithBounds(bound: CGRect) -> UIBezierPath{
        let purplePath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        purplePath.moveToPoint(CGPointMake(minX + 0.83872 * w, minY))
        purplePath.addCurveToPoint(CGPointMake(minX, minY + 0.84374 * h), controlPoint1:CGPointMake(minX + 0.46048 * w, minY + 0.15718 * h), controlPoint2:CGPointMake(minX + 0.15756 * w, minY + 0.46206 * h))
        purplePath.addLineToPoint(CGPointMake(minX, minY + 0.84374 * h))
        purplePath.addLineToPoint(CGPointMake(minX + 0.38209 * w, minY + h))
        purplePath.addCurveToPoint(CGPointMake(minX + w, minY + 0.3846 * h), controlPoint1:CGPointMake(minX + 0.49898 * w, minY + 0.72094 * h), controlPoint2:CGPointMake(minX + 0.72205 * w, minY + 0.4985 * h))
        purplePath.addLineToPoint(CGPointMake(minX + 0.83872 * w, minY))
        purplePath.closePath()
        purplePath.moveToPoint(CGPointMake(minX + 0.83872 * w, minY))
        
        return purplePath;
    }
    
    func rosePathWithBounds(bound: CGRect) -> UIBezierPath{
        let rosePath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        rosePath.moveToPoint(CGPointMake(minX + 0.98585 * w, minY + 0.53026 * h))
        rosePath.addLineToPoint(CGPointMake(minX + 0.99683 * w, minY + 0.53358 * h))
        rosePath.addLineToPoint(CGPointMake(minX + 0.99683 * w, minY + 0.53358 * h))
        rosePath.addLineToPoint(CGPointMake(minX + 0.99486 * w, minY + 0.53393 * h))
        rosePath.addLineToPoint(CGPointMake(minX, minY))
        rosePath.addLineToPoint(CGPointMake(minX + 0.21095 * w, minY + 0.66592 * h))
        rosePath.addLineToPoint(CGPointMake(minX + 0.2048 * w, minY + 0.66858 * h))
        rosePath.addLineToPoint(CGPointMake(minX + 0.20732 * w, minY + 0.66963 * h))
        rosePath.addLineToPoint(CGPointMake(minX + 0.20797 * w, minY + 0.67169 * h))
        rosePath.addLineToPoint(CGPointMake(minX + 0.20797 * w, minY + 0.67169 * h))
        rosePath.addLineToPoint(CGPointMake(minX + 0.21099 * w, minY + 0.67116 * h))
        rosePath.addLineToPoint(CGPointMake(minX + 0.99683 * w, minY + h))
        rosePath.addLineToPoint(CGPointMake(minX + 0.99683 * w, minY + 0.53725 * h))
        rosePath.addLineToPoint(CGPointMake(minX + w, minY + 0.53669 * h))
        rosePath.addLineToPoint(CGPointMake(minX + 0.99683 * w, minY + 0.53499 * h))
        rosePath.closePath()
        rosePath.moveToPoint(CGPointMake(minX + 0.98585 * w, minY + 0.53026 * h))
        
        return rosePath;
    }
    
    func rose2PathWithBounds(bound: CGRect) -> UIBezierPath{
        let rose2Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        rose2Path.moveToPoint(CGPointMake(minX + 0.79382 * w, minY + 0.67177 * h))
        rose2Path.addLineToPoint(CGPointMake(minX + 0.79625 * w, minY + 0.67076 * h))
        rose2Path.addLineToPoint(CGPointMake(minX + 0.79625 * w, minY + 0.67076 * h))
        rose2Path.addLineToPoint(CGPointMake(minX + 0.79424 * w, minY + 0.67043 * h))
        rose2Path.addLineToPoint(CGPointMake(minX + w, minY))
        rose2Path.addLineToPoint(CGPointMake(minX + 0.00212 * w, minY + 0.5381 * h))
        rose2Path.addLineToPoint(CGPointMake(minX + 0.00521 * w, minY + 0.58195 * h))
        rose2Path.addLineToPoint(CGPointMake(minX + 0.00521 * w, minY + 0.58345 * h))
        rose2Path.addLineToPoint(CGPointMake(minX + 0.00212 * w, minY + 0.58512 * h))
        rose2Path.addLineToPoint(CGPointMake(minX + 0.00212 * w, minY + 0.58512 * h))
        rose2Path.addLineToPoint(CGPointMake(minX + 0.00521 * w, minY + 0.58563 * h))
        rose2Path.addLineToPoint(CGPointMake(minX, minY + h))
        rose2Path.addLineToPoint(CGPointMake(minX + 0.78991 * w, minY + 0.67339 * h))
        rose2Path.addLineToPoint(CGPointMake(minX + 0.79316 * w, minY + 0.67393 * h))
        rose2Path.addLineToPoint(CGPointMake(minX + 0.79382 * w, minY + 0.67177 * h))
        rose2Path.closePath()
        rose2Path.moveToPoint(CGPointMake(minX + 0.79382 * w, minY + 0.67177 * h))
        
        return rose2Path;
    }
    
    func rose3PathWithBounds(bound: CGRect) -> UIBezierPath{
        let rose3Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        rose3Path.moveToPoint(CGPointMake(minX + 0.46603 * w, minY + 0.98142 * h))
        rose3Path.addLineToPoint(CGPointMake(minX + 0.46745 * w, minY + 0.98689 * h))
        rose3Path.addLineToPoint(CGPointMake(minX + 0.46745 * w, minY + 0.98689 * h))
        rose3Path.addLineToPoint(CGPointMake(minX + 0.4671 * w, minY + 0.98493 * h))
        rose3Path.addLineToPoint(CGPointMake(minX + w, minY))
        rose3Path.addLineToPoint(CGPointMake(minX + 0.32941 * w, minY + 0.21 * h))
        rose3Path.addLineToPoint(CGPointMake(minX + 0.32905 * w, minY + 0.20794 * h))
        rose3Path.addLineToPoint(CGPointMake(minX + 0.32799 * w, minY + 0.21044 * h))
        rose3Path.addLineToPoint(CGPointMake(minX + 0.32591 * w, minY + 0.21109 * h))
        rose3Path.addLineToPoint(CGPointMake(minX + 0.32591 * w, minY + 0.21109 * h))
        rose3Path.addLineToPoint(CGPointMake(minX + 0.32645 * w, minY + 0.2141 * h))
        rose3Path.addLineToPoint(CGPointMake(minX, minY + h))
        rose3Path.addLineToPoint(CGPointMake(minX + 0.46375 * w, minY + 0.98689 * h))
        rose3Path.addLineToPoint(CGPointMake(minX + 0.46431 * w, minY + 0.99005 * h))
        rose3Path.addLineToPoint(CGPointMake(minX + 0.46603 * w, minY + 0.98689 * h))
        rose3Path.closePath()
        rose3Path.moveToPoint(CGPointMake(minX + 0.46603 * w, minY + 0.98142 * h))
        
        return rose3Path;
    }
    
    func rose4PathWithBounds(bound: CGRect) -> UIBezierPath{
        let rose4Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        rose4Path.moveToPoint(CGPointMake(minX + 0.32823 * w, minY + 0.79446 * h))
        rose4Path.addLineToPoint(CGPointMake(minX + 0.32924 * w, minY + 0.79688 * h))
        rose4Path.addLineToPoint(CGPointMake(minX + 0.32924 * w, minY + 0.79688 * h))
        rose4Path.addLineToPoint(CGPointMake(minX + 0.32957 * w, minY + 0.79487 * h))
        rose4Path.addLineToPoint(CGPointMake(minX + w, minY + h))
        rose4Path.addLineToPoint(CGPointMake(minX + 0.4619 * w, minY + 0.0052 * h))
        rose4Path.addLineToPoint(CGPointMake(minX + 0.46225 * w, minY + 0.00308 * h))
        rose4Path.addLineToPoint(CGPointMake(minX + 0.46076 * w, minY + 0.00308 * h))
        rose4Path.addLineToPoint(CGPointMake(minX + 0.45909 * w, minY))
        rose4Path.addLineToPoint(CGPointMake(minX + 0.45909 * w, minY))
        rose4Path.addLineToPoint(CGPointMake(minX + 0.45857 * w, minY + 0.00308 * h))
        rose4Path.addLineToPoint(CGPointMake(minX, minY + 0.00308 * h))
        rose4Path.addLineToPoint(CGPointMake(minX + 0.32661 * w, minY + 0.79056 * h))
        rose4Path.addLineToPoint(CGPointMake(minX + 0.32607 * w, minY + 0.7938 * h))
        rose4Path.addLineToPoint(CGPointMake(minX + 0.32823 * w, minY + 0.79446 * h))
        rose4Path.closePath()
        rose4Path.moveToPoint(CGPointMake(minX + 0.32823 * w, minY + 0.79446 * h))
        
        return rose4Path;
    }
    
    func rose5PathWithBounds(bound: CGRect) -> UIBezierPath{
        let rose5Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        rose5Path.moveToPoint(CGPointMake(minX + 0.02001 * w, minY + 0.47046 * h))
        rose5Path.addLineToPoint(CGPointMake(minX + 0.02001 * w, minY + 0.47186 * h))
        rose5Path.addLineToPoint(CGPointMake(minX + 0.02001 * w, minY + 0.47186 * h))
        rose5Path.addLineToPoint(CGPointMake(minX + 0.02197 * w, minY + 0.47151 * h))
        rose5Path.addLineToPoint(CGPointMake(minX + w, minY + h))
        rose5Path.addLineToPoint(CGPointMake(minX + 0.79031 * w, minY + 0.33497 * h))
        rose5Path.addLineToPoint(CGPointMake(minX + 0.79237 * w, minY + 0.33461 * h))
        rose5Path.addLineToPoint(CGPointMake(minX + 0.78987 * w, minY + 0.33356 * h))
        rose5Path.addLineToPoint(CGPointMake(minX + 0.78922 * w, minY + 0.3315 * h))
        rose5Path.addLineToPoint(CGPointMake(minX + 0.78922 * w, minY + 0.3315 * h))
        rose5Path.addLineToPoint(CGPointMake(minX + 0.78622 * w, minY + 0.33203 * h))
        rose5Path.addLineToPoint(CGPointMake(minX, minY))
        rose5Path.addLineToPoint(CGPointMake(minX + 0.02001 * w, minY + 0.46819 * h))
        rose5Path.addLineToPoint(CGPointMake(minX + 0.01686 * w, minY + 0.46875 * h))
        rose5Path.addLineToPoint(CGPointMake(minX + 0.02001 * w, minY + 0.47046 * h))
        rose5Path.closePath()
        rose5Path.moveToPoint(CGPointMake(minX + 0.02001 * w, minY + 0.47046 * h))
        
        return rose5Path;
    }
    
    func rose6PathWithBounds(bound: CGRect) -> UIBezierPath{
        let rose6Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        rose6Path.moveToPoint(CGPointMake(minX + 0.20327 * w, minY + 0.32823 * h))
        rose6Path.addLineToPoint(CGPointMake(minX + 0.20088 * w, minY + 0.32924 * h))
        rose6Path.addLineToPoint(CGPointMake(minX + 0.20088 * w, minY + 0.32924 * h))
        rose6Path.addLineToPoint(CGPointMake(minX + 0.20287 * w, minY + 0.32957 * h))
        rose6Path.addLineToPoint(CGPointMake(minX, minY + h))
        rose6Path.addLineToPoint(CGPointMake(minX + 0.98384 * w, minY + 0.4619 * h))
        rose6Path.addLineToPoint(CGPointMake(minX + 0.99695 * w, minY + 0.46225 * h))
        rose6Path.addLineToPoint(CGPointMake(minX + 0.99695 * w, minY + 0.46076 * h))
        rose6Path.addLineToPoint(CGPointMake(minX + w, minY + 0.45909 * h))
        rose6Path.addLineToPoint(CGPointMake(minX + w, minY + 0.45909 * h))
        rose6Path.addLineToPoint(CGPointMake(minX + 0.99695 * w, minY + 0.45857 * h))
        rose6Path.addLineToPoint(CGPointMake(minX + 0.98593 * w, minY))
        rose6Path.addLineToPoint(CGPointMake(minX + 0.20713 * w, minY + 0.32661 * h))
        rose6Path.addLineToPoint(CGPointMake(minX + 0.20393 * w, minY + 0.32607 * h))
        rose6Path.addLineToPoint(CGPointMake(minX + 0.20327 * w, minY + 0.32823 * h))
        rose6Path.closePath()
        rose6Path.moveToPoint(CGPointMake(minX + 0.20327 * w, minY + 0.32823 * h))
        
        return rose6Path;
    }
    
    func rose7PathWithBounds(bound: CGRect) -> UIBezierPath{
        let rose7Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        rose7Path.moveToPoint(CGPointMake(minX + 0.53557 * w, minY + 0.00321 * h))
        rose7Path.addLineToPoint(CGPointMake(minX + 0.53415 * w, minY + 0.00321 * h))
        rose7Path.addLineToPoint(CGPointMake(minX + 0.53415 * w, minY + 0.00321 * h))
        rose7Path.addLineToPoint(CGPointMake(minX + 0.5345 * w, minY + 0.0052 * h))
        rose7Path.addLineToPoint(CGPointMake(minX, minY + h))
        rose7Path.addLineToPoint(CGPointMake(minX + 0.6726 * w, minY + 0.78672 * h))
        rose7Path.addLineToPoint(CGPointMake(minX + 0.67297 * w, minY + 0.78881 * h))
        rose7Path.addLineToPoint(CGPointMake(minX + 0.67403 * w, minY + 0.78626 * h))
        rose7Path.addLineToPoint(CGPointMake(minX + 0.67611 * w, minY + 0.7856 * h))
        rose7Path.addLineToPoint(CGPointMake(minX + 0.67611 * w, minY + 0.7856 * h))
        rose7Path.addLineToPoint(CGPointMake(minX + 0.67557 * w, minY + 0.78255 * h))
        rose7Path.addLineToPoint(CGPointMake(minX + w, minY + 0.00321 * h))
        rose7Path.addLineToPoint(CGPointMake(minX + 0.53786 * w, minY + 0.00321 * h))
        rose7Path.addLineToPoint(CGPointMake(minX + 0.53729 * w, minY))
        rose7Path.addLineToPoint(CGPointMake(minX + 0.53557 * w, minY + 0.00321 * h))
        rose7Path.closePath()
        rose7Path.moveToPoint(CGPointMake(minX + 0.53557 * w, minY + 0.00321 * h))
        
        return rose7Path;
    }
    
    func rose8PathWithBounds(bound: CGRect) -> UIBezierPath{
        let rose8Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        rose8Path.moveToPoint(CGPointMake(minX + 0.67177 * w, minY + 0.20554 * h))
        rose8Path.addLineToPoint(CGPointMake(minX + 0.67076 * w, minY + 0.20312 * h))
        rose8Path.addLineToPoint(CGPointMake(minX + 0.67076 * w, minY + 0.20312 * h))
        rose8Path.addLineToPoint(CGPointMake(minX + 0.67043 * w, minY + 0.20513 * h))
        rose8Path.addLineToPoint(CGPointMake(minX, minY))
        rose8Path.addLineToPoint(CGPointMake(minX + 0.5381 * w, minY + 0.9948 * h))
        rose8Path.addLineToPoint(CGPointMake(minX + 0.53775 * w, minY + 0.99692 * h))
        rose8Path.addLineToPoint(CGPointMake(minX + 0.53924 * w, minY + 0.99692 * h))
        rose8Path.addLineToPoint(CGPointMake(minX + 0.54091 * w, minY + h))
        rose8Path.addLineToPoint(CGPointMake(minX + 0.54091 * w, minY + h))
        rose8Path.addLineToPoint(CGPointMake(minX + 0.54143 * w, minY + 0.99692 * h))
        rose8Path.addLineToPoint(CGPointMake(minX + w, minY + 0.99692 * h))
        rose8Path.addLineToPoint(CGPointMake(minX + 0.67339 * w, minY + 0.20944 * h))
        rose8Path.addLineToPoint(CGPointMake(minX + 0.67393 * w, minY + 0.2062 * h))
        rose8Path.addLineToPoint(CGPointMake(minX + 0.67177 * w, minY + 0.20554 * h))
        rose8Path.closePath()
        rose8Path.moveToPoint(CGPointMake(minX + 0.67177 * w, minY + 0.20554 * h))
        
        return rose8Path;
    }
    
    func pathPathWithBounds(bound: CGRect) -> UIBezierPath{
        let pathPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        pathPath.moveToPoint(CGPointMake(minX + w, minY + h))
        pathPath.addLineToPoint(CGPointMake(minX + 0.51224 * w, minY))
        pathPath.addLineToPoint(CGPointMake(minX, minY + 0.9996 * h))
        pathPath.addCurveToPoint(CGPointMake(minX + 0.48395 * w, minY + 0.99671 * h), controlPoint1:CGPointMake(minX + 0.1604 * w, minY + 0.99768 * h), controlPoint2:CGPointMake(minX + 0.32175 * w, minY + 0.99672 * h))
        pathPath.addCurveToPoint(CGPointMake(minX + w, minY + h), controlPoint1:CGPointMake(minX + 0.65697 * w, minY + 0.99672 * h), controlPoint2:CGPointMake(minX + 0.82902 * w, minY + 0.99782 * h))
        pathPath.closePath()
        pathPath.moveToPoint(CGPointMake(minX + w, minY + h))
        
        return pathPath;
    }
    
    func path2PathWithBounds(bound: CGRect) -> UIBezierPath{
        let path2Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        path2Path.moveToPoint(CGPointMake(minX + w, minY))
        path2Path.addLineToPoint(CGPointMake(minX, minY + 0.48786 * h))
        path2Path.addLineToPoint(CGPointMake(minX + 0.99923 * w, minY + h))
        path2Path.addCurveToPoint(CGPointMake(minX + 0.99645 * w, minY + 0.53042 * h), controlPoint1:CGPointMake(minX + 0.99739 * w, minY + 0.84435 * h), controlPoint2:CGPointMake(minX + 0.99645 * w, minY + 0.6878 * h))
        path2Path.addCurveToPoint(CGPointMake(minX + w, minY), controlPoint1:CGPointMake(minX + 0.99645 * w, minY + 0.35252 * h), controlPoint2:CGPointMake(minX + 0.99764 * w, minY + 0.17568 * h))
        path2Path.closePath()
        path2Path.moveToPoint(CGPointMake(minX + w, minY))
        
        return path2Path;
    }
    
    func path3PathWithBounds(bound: CGRect) -> UIBezierPath{
        let path3Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        path3Path.moveToPoint(CGPointMake(minX + w, minY + 0.76717 * h))
        path3Path.addLineToPoint(CGPointMake(minX, minY))
        path3Path.addLineToPoint(CGPointMake(minX + 0.76642 * w, minY + h))
        path3Path.addCurveToPoint(CGPointMake(minX + w, minY + 0.76717 * h), controlPoint1:CGPointMake(minX + 0.84053 * w, minY + 0.91877 * h), controlPoint2:CGPointMake(minX + 0.91849 * w, minY + 0.84106 * h))
        path3Path.closePath()
        path3Path.moveToPoint(CGPointMake(minX + w, minY + 0.76717 * h))
        
        return path3Path;
    }
    
    func path4PathWithBounds(bound: CGRect) -> UIBezierPath{
        let path4Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        path4Path.moveToPoint(CGPointMake(minX + 0.76916 * w, minY))
        path4Path.addLineToPoint(CGPointMake(minX, minY + h))
        path4Path.addLineToPoint(CGPointMake(minX + w, minY + 0.23556 * h))
        path4Path.addCurveToPoint(CGPointMake(minX + 0.76916 * w, minY), controlPoint1:CGPointMake(minX + 0.91936 * w, minY + 0.16079 * h), controlPoint2:CGPointMake(minX + 0.84232 * w, minY + 0.08218 * h))
        path4Path.closePath()
        path4Path.moveToPoint(CGPointMake(minX + 0.76916 * w, minY))
        
        return path4Path;
    }
    
    func path5PathWithBounds(bound: CGRect) -> UIBezierPath{
        let path5Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        path5Path.moveToPoint(CGPointMake(minX, minY))
        path5Path.addLineToPoint(CGPointMake(minX + 0.48843 * w, minY + h))
        path5Path.addLineToPoint(CGPointMake(minX + w, minY + 0.00307 * h))
        path5Path.addCurveToPoint(CGPointMake(minX + 0.62423 * w, minY + 0.00482 * h), controlPoint1:CGPointMake(minX + 0.87529 * w, minY + 0.00423 * h), controlPoint2:CGPointMake(minX + 0.75002 * w, minY + 0.00481 * h))
        path5Path.addCurveToPoint(CGPointMake(minX, minY), controlPoint1:CGPointMake(minX + 0.41466 * w, minY + 0.00481 * h), controlPoint2:CGPointMake(minX + 0.20653 * w, minY + 0.00319 * h))
        path5Path.closePath()
        path5Path.moveToPoint(CGPointMake(minX, minY))
        
        return path5Path;
    }
    
    func path6PathWithBounds(bound: CGRect) -> UIBezierPath{
        let path6Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        path6Path.moveToPoint(CGPointMake(minX, minY + 0.23032 * h))
        path6Path.addLineToPoint(CGPointMake(minX + w, minY + h))
        path6Path.addLineToPoint(CGPointMake(minX + 0.23608 * w, minY))
        path6Path.addCurveToPoint(CGPointMake(minX, minY + 0.23032 * h), controlPoint1:CGPointMake(minX + 0.16102 * w, minY + 0.08036 * h), controlPoint2:CGPointMake(minX + 0.08223 * w, minY + 0.15723 * h))
        path6Path.closePath()
        path6Path.moveToPoint(CGPointMake(minX, minY + 0.23032 * h))
        
        return path6Path;
    }
    
    func path7PathWithBounds(bound: CGRect) -> UIBezierPath{
        let path7Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        path7Path.moveToPoint(CGPointMake(minX, minY + h))
        path7Path.addLineToPoint(CGPointMake(minX + w, minY + 0.51185 * h))
        path7Path.addLineToPoint(CGPointMake(minX + 0.00192 * w, minY))
        path7Path.addCurveToPoint(CGPointMake(minX + 0.0041 * w, minY + 0.42198 * h), controlPoint1:CGPointMake(minX + 0.00337 * w, minY + 0.13998 * h), controlPoint2:CGPointMake(minX + 0.0041 * w, minY + 0.28066 * h))
        path7Path.addCurveToPoint(CGPointMake(minX, minY + h), controlPoint1:CGPointMake(minX + 0.0041 * w, minY + 0.61592 * h), controlPoint2:CGPointMake(minX + 0.00272 * w, minY + 0.80864 * h))
        path7Path.closePath()
        path7Path.moveToPoint(CGPointMake(minX, minY + h))
        
        return path7Path;
    }
    
    func path8PathWithBounds(bound: CGRect) -> UIBezierPath{
        let path8Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        path8Path.moveToPoint(CGPointMake(minX + 0.23152 * w, minY + h))
        path8Path.addLineToPoint(CGPointMake(minX + w, minY))
        path8Path.addLineToPoint(CGPointMake(minX, minY + 0.76512 * h))
        path8Path.addCurveToPoint(CGPointMake(minX + 0.23152 * w, minY + h), controlPoint1:CGPointMake(minX + 0.08077 * w, minY + 0.83973 * h), controlPoint2:CGPointMake(minX + 0.15804 * w, minY + 0.91812 * h))
        path8Path.closePath()
        path8Path.moveToPoint(CGPointMake(minX + 0.23152 * w, minY + h))
        
        return path8Path;
    }
    
    func centerPathWithBounds(bound: CGRect) -> UIBezierPath{
        let centerPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        centerPath.moveToPoint(CGPointMake(minX + 0.5 * w, minY))
        centerPath.addCurveToPoint(CGPointMake(minX, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.22386 * w, minY), controlPoint2:CGPointMake(minX, minY + 0.22386 * h))
        centerPath.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY + h), controlPoint1:CGPointMake(minX, minY + 0.77614 * h), controlPoint2:CGPointMake(minX + 0.22386 * w, minY + h))
        centerPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.77614 * w, minY + h), controlPoint2:CGPointMake(minX + w, minY + 0.77614 * h))
        centerPath.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY), controlPoint1:CGPointMake(minX + w, minY + 0.22386 * h), controlPoint2:CGPointMake(minX + 0.77614 * w, minY))
        
        return centerPath;
    }
    
    func arrowPathWithBounds(bound: CGRect) -> UIBezierPath{
        let arrowPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        arrowPath.moveToPoint(CGPointMake(minX + 0.53118 * w, minY + 0.77088 * h))
        arrowPath.addLineToPoint(CGPointMake(minX + 0.53118 * w, minY + 0.18855 * h))
        arrowPath.addLineToPoint(CGPointMake(minX + 0.53118 * w, minY + 0.18855 * h))
        arrowPath.addLineToPoint(CGPointMake(minX + 0.98805 * w, minY + 0.25346 * h))
        arrowPath.addLineToPoint(CGPointMake(minX + w, minY + 0.25346 * h))
        arrowPath.addLineToPoint(CGPointMake(minX + 0.51244 * w, minY))
        arrowPath.addLineToPoint(CGPointMake(minX + 0.00275 * w, minY + 0.2533 * h))
        arrowPath.addLineToPoint(CGPointMake(minX, minY + 0.25346 * h))
        arrowPath.addLineToPoint(CGPointMake(minX, minY + 0.25346 * h))
        arrowPath.addLineToPoint(CGPointMake(minX + 0.00664 * w, minY + 0.25346 * h))
        arrowPath.addLineToPoint(CGPointMake(minX + 0.46882 * w, minY + 0.18779 * h))
        arrowPath.addLineToPoint(CGPointMake(minX + 0.46882 * w, minY + 0.77088 * h))
        arrowPath.addLineToPoint(CGPointMake(minX + 0.21729 * w, minY + 0.85681 * h))
        arrowPath.addLineToPoint(CGPointMake(minX + 0.21729 * w, minY + 0.99643 * h))
        arrowPath.addCurveToPoint(CGPointMake(minX + 0.49716 * w, minY + h), controlPoint1:CGPointMake(minX + 0.30908 * w, minY + 0.99879 * h), controlPoint2:CGPointMake(minX + 0.40247 * w, minY + h))
        arrowPath.addCurveToPoint(CGPointMake(minX + 0.78271 * w, minY + 0.99628 * h), controlPoint1:CGPointMake(minX + 0.5938 * w, minY + h), controlPoint2:CGPointMake(minX + 0.68909 * w, minY + 0.99874 * h))
        arrowPath.addLineToPoint(CGPointMake(minX + 0.78271 * w, minY + 0.99628 * h))
        arrowPath.addLineToPoint(CGPointMake(minX + 0.78271 * w, minY + 0.85681 * h))
        arrowPath.addLineToPoint(CGPointMake(minX + 0.78271 * w, minY + 0.85681 * h))
        arrowPath.addLineToPoint(CGPointMake(minX + 0.53118 * w, minY + 0.77088 * h))
        arrowPath.closePath()
        arrowPath.moveToPoint(CGPointMake(minX + 0.53118 * w, minY + 0.77088 * h))
        
        return arrowPath;
    }
    
    
}
