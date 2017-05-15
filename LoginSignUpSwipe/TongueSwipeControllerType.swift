//
//  TongueSwipeController.swift
//  LoginSignUpSwipe
//
//  Created by Alexej Nenastev on 04.05.17.
//  Copyright © 2017 Alexej Nenastev. All rights reserved.
//

import Foundation
import UIKit

protocol TongueSwipeController{
    var tongue: TongueView {get}
    var nameLabel : UILabel {get}
    var socialButtonsView : UIStackView {get}
    
    func animateTongueSocialButtonsSpring()
}



extension TongueSwipeController where Self: UIViewController {
    func animateTongueSocialButtonsSpring() {
        let duration = 0.5
        let delay = 0.5
        
        let tongueCenter = tongue.center
        let tongueOffset = tongue.frame.width * (tongue.clockWiseOrientatation ?  -1 : 1 )
        
        let buttonsCenter = socialButtonsView.center
        
        tongue.center = CGPoint(x: tongueCenter.x + tongueOffset, y: tongueCenter.y)
        socialButtonsView.center = CGPoint(x: self.view.bounds.maxX - buttonsCenter.x, y: buttonsCenter.y)
            
            
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 20,
                       options: [], animations: {
                       self.tongue.center = tongueCenter
        })
        
        UIView.animate(withDuration: duration,
                       delay: delay + 0.05,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 20,
                       options: [], animations: {
                        self.socialButtonsView.center = buttonsCenter
        })
    }
}

