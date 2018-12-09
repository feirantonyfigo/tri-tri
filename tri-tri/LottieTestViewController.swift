//
//  LottieTestViewController.swift
//  tri-tri
//
//  Created by mac on 2017-05-26.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import Lottie


class LottieTestViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
            let animationView = LOTAnimationView(name: "crown")!
            animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            animationView.center = self.view.center
            animationView.contentMode = .scaleAspectFill
            animationView.loopAnimation = true
            view.addSubview(animationView)
            
            animationView.play()
            /**
            let square = UIView()
            square.frame = CGRect(x: 55, y: 300, width: 20, height: 20)
            square.backgroundColor = UIColor.red
            
            // add the square to the screen
            
            
            // now create a bezier path that defines our curve
            // the animation function needs the curve defined as a CGPath
            // but these are more difficult to work with, so instead
            // we'll create a UIBezierPath, and then create a
            // CGPath from the bezier when we need it
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 16,y: 239))
            path.addCurve(to: CGPoint(x: 301, y: 239), controlPoint1: CGPoint(x: 136, y: 373), controlPoint2: CGPoint(x: 178, y: 110))
            
            // create a new CAKeyframeAnimation that animates the objects position
            let anim = CAKeyframeAnimation(keyPath: "position")
            
            // set the animations path to our bezier curve
            anim.path = path.cgPath
            
            // set some more parameters for the animation
            // this rotation mode means that our object will rotate so that it's parallel to whatever point it is currently on the curve
            anim.rotationMode = kCAAnimationRotateAuto
            anim.repeatCount = Float.infinity
            anim.duration = 5.0
            
            // we add the animation to the squares 'layer' property
            square.layer.add(anim, forKey: "animate position along path")
            self.view.addSubview(square)
      **/
        }
        
        
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
