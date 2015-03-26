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
        
        let minX = CGRectGetMinX(rect)+offSetX
        let midY = CGRectGetMidY(rect)+offSetY
        let maxX = CGRectGetMaxX(rect)
        let a = offSetX/maxX
        let sideLen = CGFloat(200.0)
        
        path.lineWidth = 5.0
        
        let origin = CGPoint(x: minX, y: midY)
        let upX = cos(3.14/4*(1+2*a))*sideLen+offSetX
        let upY = midY - sin(3.14/4*(1+2*a))*sideLen-offSetY
        let downX = cos(3.14/4*(1+3*a))*sideLen+offSetX
        let downY = midY + sin(3.14/4*(1+3*a))*sideLen-offSetY
        
        let len = sideLen+a*(maxX-sideLen)
        let deltaLen = maxX-a*maxX+len*a
        let radian = a*3*3.14/4
        let mmX = deltaLen*cos(radian)+offSetX
        let mmY = deltaLen*sin(radian)+midY-offSetY
        
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        helpView.hidden = true
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
            
            self.helpConstraint.constant = CGRectGetWidth(self.arrowView.frame)
            UIView.animateWithDuration(0.8, animations: {self.helpView.layoutIfNeeded()}, completion: { if $0 {self.displayLink?.invalidate()}})
        }
    }
    
    func animate(dis: CADisplayLink)
    {
        let helpLayer = self.helpView.layer.presentationLayer() as CALayer
        let helpFrame = helpLayer.valueForKey("frame")?.CGRectValue()
        arrowView.offSetX = CGRectGetMinX(helpFrame!)
        arrowView.setNeedsDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

