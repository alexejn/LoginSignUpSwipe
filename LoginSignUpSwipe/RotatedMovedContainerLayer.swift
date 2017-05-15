
import QuartzCore
import CoreImage
import Foundation
import UIKit

public final class RotatedMovedContainerLayer : CAShapeLayer {
    
    let anchorBottomMargin: CGFloat
    let layerToRotate: CALayer
    let clockwise: Bool
    let horizontalMargin: CGFloat
    
    public init(horizontalMargin: CGFloat,
                anchorBottomMargin: CGFloat,
                layerToRotate: CALayer,
                clockwise: Bool = true) {
        
        self.horizontalMargin = horizontalMargin
        self.anchorBottomMargin = anchorBottomMargin
        self.layerToRotate = layerToRotate
        self.clockwise = clockwise
        
        super.init()
         
        self.frame = layerToRotate.frame
        layerToRotate.anchorPoint = CGPoint(x: clockwise ? 1 : 0,
                                     y:1.0 - (self.anchorBottomMargin/layerToRotate.bounds.maxY))
        layerToRotate.position = CGPoint(x: layerToRotate.anchorPoint.x * layerToRotate.bounds.maxX ,
                                  y: layerToRotate.anchorPoint.y * layerToRotate.bounds.maxY )
        
        self.backgroundColor = UIColor.clear.cgColor
        self.masksToBounds = true
        self.addSublayer(layerToRotate)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    public func animate(duration: CFTimeInterval){
        let rotateAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnim.duration = duration
        
        let position = CABasicAnimation(keyPath: "position")
        position.toValue = self.position
        position.duration = duration
        
        if clockwise {
            rotateAnim.toValue =  0
            rotateAnim.fromValue = -30.degreesToRadians
            position.fromValue = CGPoint(x: horizontalMargin-frame.midX, y:  self.position.y)
            
        } else {
            rotateAnim.toValue =  0
            rotateAnim.fromValue = 30.degreesToRadians
            let fromX = 2 * self.position.x + (self.position.x - horizontalMargin)
            position.fromValue = CGPoint(x: fromX, y:  self.position.y)
        
        }
        
        
        layerToRotate.add(rotateAnim, forKey: nil)
        add(position, forKey: nil)
    }
}
