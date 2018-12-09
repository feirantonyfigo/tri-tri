//
//  UIButtonExtension.swift
//  tri-tri
//
//  Created by Feiran Hu on 2017-07-16.
//  Copyright © 2017 mac. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    
    func pulseAnimation(){
        
    let pulse = CASpringAnimation(keyPath: "transform.scale")
    pulse.duration = 0.6
    pulse.fromValue = 0.95
    pulse.toValue = 1.0
    pulse.autoreverses = true
    pulse.repeatCount = 2.0
    pulse.initialVelocity = 0.5
    pulse.damping = 1.0
    layer.add(pulse, forKey: nil)
    }
    
    
    
    
    
    
    
    
}
