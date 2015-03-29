//
//  ViewController.swift
//  ArrowAnimation
//
//  Created by Aaron on 3/23/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

import UIKit
import QuartzCore

class ArrowView: UIView
{
    var offSetX = CGFloat(0)
    var offSetY = CGFloat(0)
    
    override func drawRect(rect: CGRect)
    {
        let path = UIBezierPath()
        path.lineWidth = 5.0
        
        let staticOrigin = CGPoint(x: CGRectGetMinX(rect), y: CGRectGetMidY(rect))
        let origin = CGPoint(x: staticOrigin.x+offSetX, y: staticOrigin.y+offSetY)
        
        let a = offSetX/CGRectGetMaxX(rect)
        
        let lShort = CGRectGetWidth(rect)*2/3
        let lLong = CGRectGetWidth(rect)
        
        let upX = staticOrigin.x + cos(CGFloat(M_PI_4)*(1+2*a))*lShort + offSetX
        let upY = staticOrigin.y - sin(CGFloat(M_PI_4)*(1+2*a))*lShort + offSetY
        
        let lenDown = (lLong-lShort)*a+lShort
        let downX = staticOrigin.x + cos(CGFloat(M_PI_4)*(1+3*a))*lenDown + offSetX
        let downY = staticOrigin.y + sin(CGFloat(M_PI_4)*(1+3*a))*lenDown + offSetY
        
        let lenMiddle = lLong-(lLong-lShort)*a
        let mmX = staticOrigin.x + cos(CGFloat(M_PI_4)*3*a)*lenMiddle + offSetX
        let mmY = staticOrigin.y + sin(CGFloat(M_PI_4)*3*a)*lenMiddle + offSetY
        
        path.moveToPoint(origin)
        path.addLineToPoint(CGPoint(x: upX, y: upY))
        path.moveToPoint(origin)
        path.addLineToPoint(CGPoint(x: downX, y: downY))
        path.moveToPoint(origin)
        path.addLineToPoint(CGPoint(x: mmX, y: mmY))
        
        UIColor.blueColor().setStroke()
        path.stroke()
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var helpConstraint: NSLayoutConstraint!
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var arrowView: ArrowView!
    
    var displayLink: CADisplayLink?
    let path = UIBezierPath()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        helpView.hidden = true
        
        let pathLayer = CAShapeLayer()
        pathLayer.frame = arrowView.bounds
        pathLayer.backgroundColor = UIColor.clearColor().CGColor
        
        let startPoint = CGPoint(x: 0, y: CGRectGetHeight(arrowView.bounds)/2)
        let endPoint = CGPoint(x: CGRectGetWidth(arrowView.bounds), y: CGRectGetHeight(arrowView.bounds)/2)
        path.moveToPoint(CGPoint(x: 0, y: CGRectGetHeight(arrowView.bounds)/2))
        path.addQuadCurveToPoint(endPoint, controlPoint: CGPoint(x: 75, y: 225))
        pathLayer.path = path.CGPath
        pathLayer.fillColor = UIColor.clearColor().CGColor
        pathLayer.strokeColor = UIColor.whiteColor().CGColor
        pathLayer.lineWidth = 3.0
        arrowView.layer.addSublayer(pathLayer)
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func hitMe(sender: UIButton)
    {
        if self.helpConstraint.constant == CGRectGetWidth(self.arrowView.frame)
        {
            arrowView.offSetX = 0
            arrowView.setNeedsDisplay()
            self.helpConstraint.constant = 0
            helpView.layoutIfNeeded()
        }
        else
        {
            displayLink = CADisplayLink(target: self, selector: "animate:")
            displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
            
//            self.helpConstraint.constant = CGRectGetWidth(self.arrowView.frame)
//            UIView.animateWithDuration(0.8, animations: {self.helpView.layoutIfNeeded()}, completion: { if $0 {self.displayLink?.invalidate()}})
            let keyFrameAnimation = CAKeyframeAnimation()
            keyFrameAnimation.keyPath = "position"
            keyFrameAnimation.path = path.CGPath
            keyFrameAnimation.duration = 0.5
            
            helpView.layer.position = CGPoint(x: CGRectGetWidth(arrowView.bounds), y: CGRectGetHeight(arrowView.bounds)/2)
            helpView.layer.addAnimation(keyFrameAnimation, forKey: nil)
        }
    }
    
    func animate(dis: CADisplayLink)
    {
        let helpLayer = self.helpView.layer.presentationLayer() as CALayer
        let helpCenter = helpLayer.valueForKey("position")?.CGPointValue()
        arrowView.offSetX = helpCenter!.x
        arrowView.offSetY = helpCenter!.y-CGRectGetHeight(arrowView.bounds)/2
        arrowView.setNeedsDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

