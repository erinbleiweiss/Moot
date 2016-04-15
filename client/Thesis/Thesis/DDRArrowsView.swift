//
//  DDRArrowsView.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 4/15/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DDRArrowsView: UIView {
    
    var layers : Dictionary<String, AnyObject> = [:]
    var completionBlocks : Dictionary<CAAnimation, (Bool) -> Void> = [:]
    var updateLayerValueForCompletedAnimation : Bool = false
    
    let greenFillColor   = UIColor(red:0.435, green: 0.749, blue:0.0235, alpha:1).CGColor
    let greenStrokeColor = UIColor(red:0.243, green: 0.631, blue:0, alpha:1).CGColor

    
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperties()
        setupLayers()
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
    
    func setupProperties(){
        
    }
    
    func activateArrow(direction: String){
        let layer = self.layers["\(direction)Arrow"] as! CAShapeLayer
        layer.fillColor = greenFillColor
        layer.strokeColor = greenFillColor
        self.setNeedsDisplay()
    }
    
    func flashArrow(direction: String){
        let layer = self.layers["\(direction)Arrow"] as! CAShapeLayer
        let flashSpeed = 0.3
        self.delay(flashSpeed){
            layer.fillColor = self.greenFillColor
            layer.strokeColor = self.greenStrokeColor
            self.setNeedsDisplay()
            self.delay(flashSpeed){
                layer.fillColor = self.greenFillColor
                layer.strokeColor = self.greenFillColor
                self.setNeedsDisplay()
                self.delay(flashSpeed){
                    layer.fillColor = self.greenFillColor
                    layer.strokeColor = self.greenStrokeColor
                    self.setNeedsDisplay()
                    self.delay(flashSpeed){
                        layer.fillColor = self.greenFillColor
                        layer.strokeColor = self.greenFillColor
                        self.setNeedsDisplay()
                        self.delay(flashSpeed){
                            layer.fillColor = self.greenFillColor
                            layer.strokeColor = self.greenStrokeColor
                            self.setNeedsDisplay()
                        }
                    }
                }
            }
        }

    }
    
    func deactivateArrow(direction: String){
        let layer = self.layers["\(direction)Arrow"] as! CAShapeLayer
        layer.fillColor = mootGray.CGColor
        layer.strokeColor = mootGray.CGColor
        self.setNeedsDisplay()
    }
    
    func setupLayers(){
        let northArrow = CAShapeLayer()
        self.layer.addSublayer(northArrow)
        layers["northArrow"] = northArrow
        
        let southArrow = CAShapeLayer()
        self.layer.addSublayer(southArrow)
        layers["southArrow"] = southArrow
        
        let westArrow = CAShapeLayer()
        self.layer.addSublayer(westArrow)
        layers["westArrow"] = westArrow
        
        let eastArrow = CAShapeLayer()
        self.layer.addSublayer(eastArrow)
        layers["eastArrow"] = eastArrow
        
        resetLayerPropertiesForLayerIdentifiers(nil)
        setupLayerFrames()
    }
    
    func resetLayerPropertiesForLayerIdentifiers(layerIds: [String]!){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if layerIds == nil || layerIds.contains("northArrow"){
            let northArrow = layers["northArrow"] as! CAShapeLayer
            northArrow.lineCap     = kCALineCapRound
            northArrow.lineJoin    = kCALineJoinRound
            northArrow.fillColor   = mootGray.CGColor
            northArrow.strokeColor = mootGray.CGColor
            northArrow.lineWidth   = 8
        }
        if layerIds == nil || layerIds.contains("southArrow"){
            let southArrow = layers["southArrow"] as! CAShapeLayer
            southArrow.lineCap     = kCALineCapRound
            southArrow.lineJoin    = kCALineJoinRound
            southArrow.fillColor   = mootGray.CGColor
            southArrow.strokeColor = mootGray.CGColor
            southArrow.lineWidth   = 8
        }
        if layerIds == nil || layerIds.contains("westArrow"){
            let westArrow = layers["westArrow"] as! CAShapeLayer
            westArrow.lineCap     = kCALineCapRound
            westArrow.lineJoin    = kCALineJoinRound
            westArrow.fillColor   = mootGray.CGColor
            westArrow.strokeColor = mootGray.CGColor
            westArrow.lineWidth   = 8
        }
        if layerIds == nil || layerIds.contains("eastArrow"){
            let eastArrow = layers["eastArrow"] as! CAShapeLayer
            eastArrow.lineCap     = kCALineCapRound
            eastArrow.lineJoin    = kCALineJoinRound
            eastArrow.fillColor   = mootGray.CGColor
            eastArrow.strokeColor = mootGray.CGColor
            eastArrow.lineWidth   = 8
        }
        
        CATransaction.commit()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let northArrow : CAShapeLayer = layers["northArrow"] as? CAShapeLayer{
            northArrow.frame = CGRectMake(0.36624 * northArrow.superlayer!.bounds.width, 0.06034 * northArrow.superlayer!.bounds.height, 0.26734 * northArrow.superlayer!.bounds.width, 0.36855 * northArrow.superlayer!.bounds.height)
            northArrow.path  = northArrowPathWithBounds((layers["northArrow"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let southArrow : CAShapeLayer = layers["southArrow"] as? CAShapeLayer{
            southArrow.frame = CGRectMake(0.36624 * southArrow.superlayer!.bounds.width, 0.5711 * southArrow.superlayer!.bounds.height, 0.26734 * southArrow.superlayer!.bounds.width, 0.36855 * southArrow.superlayer!.bounds.height)
            southArrow.path  = southArrowPathWithBounds((layers["southArrow"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let westArrow : CAShapeLayer = layers["westArrow"] as? CAShapeLayer{
            westArrow.frame = CGRectMake(0.06076 * westArrow.superlayer!.bounds.width, 0.36658 * westArrow.superlayer!.bounds.height, 0.36855 * westArrow.superlayer!.bounds.width, 0.26734 * westArrow.superlayer!.bounds.height)
            westArrow.path  = westArrowPathWithBounds((layers["westArrow"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let eastArrow : CAShapeLayer = layers["eastArrow"] as? CAShapeLayer{
            eastArrow.frame = CGRectMake(0.57068 * eastArrow.superlayer!.bounds.width, 0.36658 * eastArrow.superlayer!.bounds.height, 0.36855 * eastArrow.superlayer!.bounds.width, 0.26734 * eastArrow.superlayer!.bounds.height)
            eastArrow.path  = eastArrowPathWithBounds((layers["eastArrow"] as! CAShapeLayer).bounds).CGPath;
        }
        
        CATransaction.commit()
    }
    
    //MARK: - Animation Setup
    
    func addOldAnimation(){
        addOldAnimationCompletionBlock(nil)
    }
    
    func addOldAnimationCompletionBlock(completionBlock: ((finished: Bool) -> Void)?){
        if completionBlock != nil{
            let completionAnim = CABasicAnimation(keyPath:"completionAnim")
            completionAnim.duration = 0
            completionAnim.delegate = self
            completionAnim.setValue("old", forKey:"animId")
            completionAnim.setValue(false, forKey:"needEndAnim")
            layer.addAnimation(completionAnim, forKey:"old")
            if let anim = layer.animationForKey("old"){
                completionBlocks[anim] = completionBlock
            }
        }
        
        let fillMode : String = kCAFillModeForwards
    }
    
    //MARK: - Animation Cleanup
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool){
        if let completionBlock = completionBlocks[anim]{
            completionBlocks.removeValueForKey(anim)
            if (flag && updateLayerValueForCompletedAnimation) || anim.valueForKey("needEndAnim") as! Bool{
                updateLayerValuesForAnimationId(anim.valueForKey("animId") as! String)
                removeAnimationsForAnimationId(anim.valueForKey("animId") as! String)
            }
            completionBlock(flag)
        }
    }
    
    func updateLayerValuesForAnimationId(identifier: String){
        if identifier == "old"{
            
        }
    }
    
    func removeAnimationsForAnimationId(identifier: String){
        if identifier == "old"{
            
        }
    }
    
    func removeAllAnimations(){
        for layer in layers.values{
            (layer as! CALayer).removeAllAnimations()
        }
    }
    
    //MARK: - Bezier Path
    
    func northArrowPathWithBounds(bound: CGRect) -> UIBezierPath{
        let northArrowPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        northArrowPath.moveToPoint(CGPointMake(minX + 0.67378 * w, minY + 0.86721 * h))
        northArrowPath.addLineToPoint(CGPointMake(minX + 0.67378 * w, minY + 0.45662 * h))
        northArrowPath.addLineToPoint(CGPointMake(minX + w, minY + 0.45662 * h))
        northArrowPath.addLineToPoint(CGPointMake(minX + 0.5 * w, minY))
        northArrowPath.addLineToPoint(CGPointMake(minX, minY + 0.45662 * h))
        northArrowPath.addLineToPoint(CGPointMake(minX + 0.32622 * w, minY + 0.45662 * h))
        northArrowPath.addLineToPoint(CGPointMake(minX + 0.32622 * w, minY + 0.45662 * h))
        northArrowPath.addLineToPoint(CGPointMake(minX + 0.32622 * w, minY + 0.86721 * h))
        northArrowPath.addCurveToPoint(CGPointMake(minX + 0.32599 * w, minY + 0.87378 * h), controlPoint1:CGPointMake(minX + 0.32607 * w, minY + 0.86939 * h), controlPoint2:CGPointMake(minX + 0.32599 * w, minY + 0.87158 * h))
        northArrowPath.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY + h), controlPoint1:CGPointMake(minX + 0.32599 * w, minY + 0.94349 * h), controlPoint2:CGPointMake(minX + 0.4039 * w, minY + h))
        northArrowPath.addCurveToPoint(CGPointMake(minX + 0.67401 * w, minY + 0.87378 * h), controlPoint1:CGPointMake(minX + 0.5961 * w, minY + h), controlPoint2:CGPointMake(minX + 0.67401 * w, minY + 0.94349 * h))
        northArrowPath.addCurveToPoint(CGPointMake(minX + 0.67378 * w, minY + 0.86721 * h), controlPoint1:CGPointMake(minX + 0.67401 * w, minY + 0.87158 * h), controlPoint2:CGPointMake(minX + 0.67393 * w, minY + 0.86939 * h))
        northArrowPath.closePath()
        northArrowPath.moveToPoint(CGPointMake(minX + 0.67378 * w, minY + 0.86721 * h))
        
        return northArrowPath;
    }
    
    func southArrowPathWithBounds(bound: CGRect) -> UIBezierPath{
        let southArrowPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        southArrowPath.moveToPoint(CGPointMake(minX + 0.32622 * w, minY + 0.13279 * h))
        southArrowPath.addLineToPoint(CGPointMake(minX + 0.32622 * w, minY + 0.54338 * h))
        southArrowPath.addLineToPoint(CGPointMake(minX, minY + 0.54338 * h))
        southArrowPath.addLineToPoint(CGPointMake(minX + 0.5 * w, minY + h))
        southArrowPath.addLineToPoint(CGPointMake(minX + w, minY + 0.54338 * h))
        southArrowPath.addLineToPoint(CGPointMake(minX + 0.67378 * w, minY + 0.54338 * h))
        southArrowPath.addLineToPoint(CGPointMake(minX + 0.67378 * w, minY + 0.54338 * h))
        southArrowPath.addLineToPoint(CGPointMake(minX + 0.67378 * w, minY + 0.13279 * h))
        southArrowPath.addCurveToPoint(CGPointMake(minX + 0.67401 * w, minY + 0.12622 * h), controlPoint1:CGPointMake(minX + 0.67393 * w, minY + 0.13061 * h), controlPoint2:CGPointMake(minX + 0.67401 * w, minY + 0.12842 * h))
        southArrowPath.addCurveToPoint(CGPointMake(minX + 0.5 * w, minY), controlPoint1:CGPointMake(minX + 0.67401 * w, minY + 0.05651 * h), controlPoint2:CGPointMake(minX + 0.5961 * w, minY))
        southArrowPath.addCurveToPoint(CGPointMake(minX + 0.32599 * w, minY + 0.12622 * h), controlPoint1:CGPointMake(minX + 0.4039 * w, minY), controlPoint2:CGPointMake(minX + 0.32599 * w, minY + 0.05651 * h))
        southArrowPath.addCurveToPoint(CGPointMake(minX + 0.32622 * w, minY + 0.13279 * h), controlPoint1:CGPointMake(minX + 0.32599 * w, minY + 0.12842 * h), controlPoint2:CGPointMake(minX + 0.32607 * w, minY + 0.13061 * h))
        southArrowPath.closePath()
        southArrowPath.moveToPoint(CGPointMake(minX + 0.32622 * w, minY + 0.13279 * h))
        
        return southArrowPath;
    }
    
    func westArrowPathWithBounds(bound: CGRect) -> UIBezierPath{
        let westArrowPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        westArrowPath.moveToPoint(CGPointMake(minX + 0.86721 * w, minY + 0.32622 * h))
        westArrowPath.addLineToPoint(CGPointMake(minX + 0.45662 * w, minY + 0.32622 * h))
        westArrowPath.addLineToPoint(CGPointMake(minX + 0.45662 * w, minY))
        westArrowPath.addLineToPoint(CGPointMake(minX, minY + 0.5 * h))
        westArrowPath.addLineToPoint(CGPointMake(minX + 0.45662 * w, minY + h))
        westArrowPath.addLineToPoint(CGPointMake(minX + 0.45662 * w, minY + 0.67378 * h))
        westArrowPath.addLineToPoint(CGPointMake(minX + 0.45662 * w, minY + 0.67378 * h))
        westArrowPath.addLineToPoint(CGPointMake(minX + 0.86721 * w, minY + 0.67378 * h))
        westArrowPath.addCurveToPoint(CGPointMake(minX + 0.87378 * w, minY + 0.67401 * h), controlPoint1:CGPointMake(minX + 0.86939 * w, minY + 0.67393 * h), controlPoint2:CGPointMake(minX + 0.87158 * w, minY + 0.67401 * h))
        westArrowPath.addCurveToPoint(CGPointMake(minX + w, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.94349 * w, minY + 0.67401 * h), controlPoint2:CGPointMake(minX + w, minY + 0.5961 * h))
        westArrowPath.addCurveToPoint(CGPointMake(minX + 0.87378 * w, minY + 0.32599 * h), controlPoint1:CGPointMake(minX + w, minY + 0.4039 * h), controlPoint2:CGPointMake(minX + 0.94349 * w, minY + 0.32599 * h))
        westArrowPath.addCurveToPoint(CGPointMake(minX + 0.86721 * w, minY + 0.32622 * h), controlPoint1:CGPointMake(minX + 0.87158 * w, minY + 0.32599 * h), controlPoint2:CGPointMake(minX + 0.86939 * w, minY + 0.32607 * h))
        westArrowPath.closePath()
        westArrowPath.moveToPoint(CGPointMake(minX + 0.86721 * w, minY + 0.32622 * h))
        
        return westArrowPath;
    }
    
    func eastArrowPathWithBounds(bound: CGRect) -> UIBezierPath{
        let eastArrowPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        eastArrowPath.moveToPoint(CGPointMake(minX + 0.13279 * w, minY + 0.67378 * h))
        eastArrowPath.addLineToPoint(CGPointMake(minX + 0.54338 * w, minY + 0.67378 * h))
        eastArrowPath.addLineToPoint(CGPointMake(minX + 0.54338 * w, minY + h))
        eastArrowPath.addLineToPoint(CGPointMake(minX + w, minY + 0.5 * h))
        eastArrowPath.addLineToPoint(CGPointMake(minX + 0.54338 * w, minY))
        eastArrowPath.addLineToPoint(CGPointMake(minX + 0.54338 * w, minY + 0.32622 * h))
        eastArrowPath.addLineToPoint(CGPointMake(minX + 0.54338 * w, minY + 0.32622 * h))
        eastArrowPath.addLineToPoint(CGPointMake(minX + 0.13279 * w, minY + 0.32622 * h))
        eastArrowPath.addCurveToPoint(CGPointMake(minX + 0.12622 * w, minY + 0.32599 * h), controlPoint1:CGPointMake(minX + 0.13061 * w, minY + 0.32607 * h), controlPoint2:CGPointMake(minX + 0.12842 * w, minY + 0.32599 * h))
        eastArrowPath.addCurveToPoint(CGPointMake(minX, minY + 0.5 * h), controlPoint1:CGPointMake(minX + 0.05651 * w, minY + 0.32599 * h), controlPoint2:CGPointMake(minX, minY + 0.4039 * h))
        eastArrowPath.addCurveToPoint(CGPointMake(minX + 0.12622 * w, minY + 0.67401 * h), controlPoint1:CGPointMake(minX, minY + 0.5961 * h), controlPoint2:CGPointMake(minX + 0.05651 * w, minY + 0.67401 * h))
        eastArrowPath.addCurveToPoint(CGPointMake(minX + 0.13279 * w, minY + 0.67378 * h), controlPoint1:CGPointMake(minX + 0.12842 * w, minY + 0.67401 * h), controlPoint2:CGPointMake(minX + 0.13061 * w, minY + 0.67393 * h))
        eastArrowPath.closePath()
        eastArrowPath.moveToPoint(CGPointMake(minX + 0.13279 * w, minY + 0.67378 * h))
        
        return eastArrowPath;
    }
    
    func delay(delay: Double, closure: ()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }
    
}

