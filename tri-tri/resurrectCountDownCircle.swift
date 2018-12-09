//
//  resurrectCountDownCircle.swift
//  tri-tri
//
//  Created by mac on 2017-07-11.
//  Copyright © 2017 mac. All rights reserved.
//

import Foundation
import SpriteKit

class resurrectCountDownCircle: SKScene{
    
    func pause_screen_x_transform(_ x: Double) -> CGFloat {
        let const = x/Double(375)
        let new_x = (defaults.value(forKey: "screen_x") as! Double)*const
        return CGFloat(new_x)
        
    }
    func pause_screen_y_transform(_ y: Double) -> CGFloat {
        let const = y/Double(667)
        let new_y = (defaults.value(forKey: "screen_y") as! Double)*const
        return CGFloat(new_y)
    }
    
    override func didMove(to:SKView) {
        
        let circle = SKShapeNode(circleOfRadius: pause_screen_x_transform(125))
        if (defaults.value(forKey: "tritri_Theme") as! Int != 2){
            circle.fillColor = UIColor(red:CGFloat(0/255.0), green:CGFloat(0/255.0), blue:CGFloat(0/255.0), alpha:CGFloat(0.5))
        }
        else {
            circle.fillColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(0.1))
        }
        circle.strokeColor = SKColor.clear
        circle.zRotation = CGFloat.pi / 2
        addChild(circle)
        
        countdown(circle: circle, steps: 100, duration: 5) {
            print("done")
            /*let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GameOverViewController") as! GameOverViewController*/
        }
    }
    
    // Creates an animated countdown timer
    func countdown(circle:SKShapeNode, steps:Int, duration:TimeInterval, completion:@escaping ()->Void) {
        guard let path = circle.path else {
            return
        }
        let radius = path.boundingBox.width/2
        let timeInterval = duration/TimeInterval(steps)
        let incr = 1 / CGFloat(steps)
        var percent = CGFloat(1.0)
        
        let animate = SKAction.run {
            percent -= incr
            circle.path = self.circle(radius: radius, percent:percent)
        }
        let wait = SKAction.wait(forDuration:timeInterval)
        let action = SKAction.sequence([wait, animate])
        
        let completed = SKAction.run{
            circle.path = nil
            completion()
        }
        
        let countDown = SKAction.repeat(action,count:steps-1)
        let sequence = SKAction.sequence([countDown, SKAction.wait(forDuration: timeInterval),completed])
        
        run(sequence, withKey: "revive_continue_count_down")
    }
    
    // Creates a CGPath in the shape of a pie with slices missing
    func circle(radius:CGFloat, percent:CGFloat) -> CGPath {
        let start:CGFloat = 0
        let end = CGFloat.pi * 2 * percent
        let center = CGPoint(x: pause_screen_x_transform(125), y: pause_screen_y_transform(-125))
        let bezierPath = UIBezierPath()
        bezierPath.move(to:center)
        bezierPath.addArc(withCenter:center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        bezierPath.addLine(to:center)
        return bezierPath.cgPath
    }
    
    func send_stop_signal() -> Void{
        removeAction(forKey: "revive_continue_count_down")
    }
}
