//
//  JumpTransition.swift
//  LoginSignUpSwipe
//
//  Created by Alexej Nenastev on 03.05.17.
//  Copyright © 2017 Alexej Nenastev. All rights reserved.
//

import UIKit

class JumpAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.25
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //1) Set up transition
        print("animateTransition")
        
        guard let fromController = transitionContext.viewController(forKey: .from) as? TongueSwipeController
            else { return }
        
        guard let toController = transitionContext.viewController(forKey: .to) as? TongueSwipeController
            else { return }
       
        let toView = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!
        let tongueView = fromController.tongue
        let clockwise = tongueView.clockWiseOrientatation
        let tongueFrame = tongueView.frame
        
        
        let containerView = transitionContext.containerView
        
        let toViewLayer = toView.layer
        
        let bottomMargin = toView.frame.maxY - tongueView.layer.position.y

        
        
        let viewLayer = RotatedMovedContainerLayer(horizontalMargin: tongueFrame.width,
                                                   anchorBottomMargin: bottomMargin,
                                                   layerToRotate: toViewLayer,
                                                   clockwise : clockwise)
   
        let swipeLayer = SwipeMaskLayer(frame: toView.frame,
                                        horizontalMargin: tongueFrame.width,
                                        anchorBottomMargin: bottomMargin,
                                        clockwise : clockwise)

        
        let fromViewLayer = fromView.layer
        let fromViewSuperLauer = fromView.layer.superlayer
        fromViewLayer.mask = swipeLayer
        
        let tongueViewLayer = tongueView.layer
        let tongueSuperLavel = tongueView.layer.superlayer
        
        let presentationContainer = CALayer()
        presentationContainer.frame = containerView.layer.frame
        presentationContainer.addSublayer(viewLayer)
        presentationContainer.addSublayer(fromViewLayer)
        presentationContainer.addSublayer(tongueViewLayer)
        
        
        containerView.backgroundColor = toView.backgroundColor
        containerView.addSubview(toView)
        containerView.layer.addSublayer(presentationContainer)
        
        toController.tongue.isHidden = true
        toController.socialButtonsView.isHidden = true
        toController.nameLabel.isHidden = true
        
        /// label transformation  animation
        let window = UIApplication.shared.keyWindow!
        let labelFrom = fromController.tongue.label
        let labelTo = toController.nameLabel
        let animatedlabel  = UILabel(frame: labelFrom.frame)
        animatedlabel.bounds = labelTo.bounds
        animatedlabel.text = labelFrom.text
        animatedlabel.textAlignment = labelFrom.textAlignment
        animatedlabel.font = labelTo.font
        animatedlabel.textColor = labelTo.textColor
        animatedlabel.lineBreakMode = .byClipping
        animatedlabel.minimumScaleFactor = 0.3
        animatedlabel.layer.position = labelFrom.superview!.layer.convert(labelFrom.layer.position, to: window.layer)
        window.addSubview(animatedlabel)
        
        let destCenter = fromController.nameLabel.superview!.layer.convert(fromController.nameLabel.center,
                                                                           to: window.layer)
        labelFrom.isHidden = true
        
        let labelScale = labelFrom.font!.pointSize / labelTo.font.pointSize
        let oldTransform = animatedlabel.transform
        animatedlabel.transform = animatedlabel.transform.scaledBy(x: labelScale, y: labelScale)
 
        UIView.animate(withDuration: duration, animations: {
            animatedlabel.center = destCenter 
            animatedlabel.transform = oldTransform
            animatedlabel.layoutIfNeeded()
            
        }) { complete in
            if complete {
                animatedlabel.removeFromSuperview()
                labelFrom.isHidden = false
                toController.nameLabel.isHidden = false
            }
        }
        /// socialbutton layer animation 
        let socialButtonsSnapshot = fromController.socialButtonsView.snapshotView(afterScreenUpdates: true)!
       
        socialButtonsSnapshot.frame = fromController.socialButtonsView.frame
       // window.addSubview(socialButtonsSnapshot)
        socialButtonsSnapshot.setNeedsLayout()
        socialButtonsSnapshot.setNeedsDisplay()
        print("origiframe= \(fromController.socialButtonsView.frame)")
         print("frame= \(socialButtonsSnapshot.frame)")
        /// main animation
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            presentationContainer.removeFromSuperlayer()
            fromViewLayer.mask = nil
            fromViewSuperLauer?.addSublayer(fromViewLayer)
            tongueSuperLavel?.addSublayer(tongueViewLayer)
            transitionContext.completeTransition(true)
            toController.tongue.isHidden = false
            toController.tongue.setLabelToCenter()
            toController.socialButtonsView.isHidden = false
            toController.animateTongueSocialButtonsSpring()
        }
        
        swipeLayer.animate(duration: duration)
        tongueView.animate(duration: duration,
                           maxX: containerView.frame.width)
        viewLayer.animate(duration: duration)
        CATransaction.commit()
    }
    
 
}
