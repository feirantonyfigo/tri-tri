//
//  waveAnimator.swift
//  tri-tri
//
//  Created by Feiran Hu on 2017-07-08.
//  Copyright © 2017 mac. All rights reserved.
//

import Foundation
import UIKit

class waveAnimator: UIView {
    
    var originX = 0.0//origin x of wave
    static fileprivate let amplitude_min = 16.0//minimum amplitude
    static fileprivate let amplitude_span = 26.0//minimum amplitude span
    
    fileprivate let cycle = 1.0//num of circulation
    fileprivate var term = 60.0// recalculate in layoutSubviews
    fileprivate var phasePosition = 0.0//phase Must be 0
    fileprivate var amplitude = 16.0//wave amplitude
    fileprivate var wave_position = 40.0//where the x axis of wave position
    
    fileprivate let waveMoveSpan = 5.0//the span wave move in a unit time
    fileprivate let animationUnitTime = 0.08//redraw unit time
    
    fileprivate let heavyColor = UIColor(red: 189/255.0, green: 128/255.0, blue: 162/255.0, alpha: 1.0)
    fileprivate let lightColor = UIColor(red: 189/255.0, green: 128/255.0, blue: 162/255.0, alpha: 0.5)
    fileprivate let clipCircleColor = UIColor(red: 189/255.0, green: 128/255.0, blue: 162/255.0, alpha: 1.0)
    
    fileprivate var clipCircleLineWidth: CGFloat = 1
    
    fileprivate var waving: Bool = true
    
    
    class var amplitudeMin: Double {
        get { return amplitude_min }
    }
    class var amplitudeSpan: Double {
        get { return amplitude_span }
    }
    
    var progress: Double = 0.5 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var waveAmplitude: Double {
        get { return amplitude }
        set {
            amplitude = newValue
            self.setNeedsDisplay()
        }
    }
    
    var waveborderWidth: CGFloat {
        get { return clipCircleLineWidth }
        set {
            clipCircleLineWidth = newValue
            self.setNeedsDisplay()
        }
    }
    
    
    
    
    //if use not in xib, create an func init
    override func awakeFromNib() {
        animationWave()
        self.backgroundColor = UIColor.clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        animationWave()
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
    }
    
    override func draw(_ rect: CGRect) {
        wave_position =  (1 - progress) * Double(rect.height)
        
        //circle clip
        clipWithCircle()
        
        //draw wave
        drawWaveWater(originX - term / 5, fillColor: lightColor)
        drawWaveWater(originX, fillColor: heavyColor)
        
        //Let clipCircle above the waves
        clipWithCircle()
        
}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //calculate the term
        term =  Double(self.bounds.size.width) / cycle
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        waving = false
    }
    
    func clipWithCircle() {
        let circleRectWidth = min(self.bounds.size.width, self.bounds.size.height) - 2 * clipCircleLineWidth
        let circleRectOriginX = (self.bounds.size.width - circleRectWidth) / 2
        let circleRectOriginY = (self.bounds.size.height - circleRectWidth) / 2
        let circleRect = CGRect(x: circleRectOriginX, y: circleRectOriginY, width: circleRectWidth, height: circleRectWidth)
        
        var clipPath: UIBezierPath!
        clipPath = UIBezierPath(ovalIn: circleRect)
        clipCircleColor.setStroke()
        clipPath.lineWidth = clipCircleLineWidth
        clipPath.stroke()
        clipPath.addClip()
    }
    
    
    func drawWaveWater(_ originX: Double, fillColor: UIColor) {
        let curvePath = UIBezierPath()
        curvePath.move(to: CGPoint(x: originX, y: wave_position))
        
        //wave path
        var tempPoint = originX
        for _ in 1...rounding(4 * cycle) {//(2 * cycle)
            curvePath.addQuadCurve(to: keyPoint(tempPoint + term / 2, originX: originX), controlPoint: keyPoint(tempPoint + term / 4, originX: originX))
            tempPoint += term / 2
        }
        
        //close the water path
        curvePath.addLine(to: CGPoint(x: curvePath.currentPoint.x, y: self.bounds.size.height))
        curvePath.addLine(to: CGPoint(x: CGFloat(originX), y: self.bounds.size.height))
        curvePath.close()
        
        fillColor.setFill()
        curvePath.lineWidth = 10
        curvePath.fill()
    }
    
    
    
    
    func animationWave() {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async { [weak self]() -> Void in
            if self != nil {
                let tempOriginX = self!.originX
                while self != nil && self!.waving {
                    if self!.originX <= tempOriginX - self!.term {
                        self!.originX = tempOriginX - self!.waveMoveSpan
                    } else {
                        self!.originX -= self!.waveMoveSpan
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        self!.setNeedsDisplay()
                    })
                    Thread.sleep(forTimeInterval: self!.animationUnitTime)
                }
            }
        }
    }
    
    
    //determine the key point of curve
    func keyPoint(_ x: Double, originX: Double) -> CGPoint {
        return CGPoint(x: x, y: columnYPoint(x - originX))
    }
    
    
    func columnYPoint(_ x: Double) -> Double {
        //sine function
        let result = amplitude * sin((2 * M_PI / term) * x + phasePosition)
        return result + wave_position
    }
    
    //round
    func rounding(_ value: Double) -> Int {
        let tempInt = Int(value)
        let tempDouble = Double(tempInt) + 0.5
        if value > tempDouble {
            return tempInt + 1
        } else {
            return tempInt
        }
    }
    
    
}

