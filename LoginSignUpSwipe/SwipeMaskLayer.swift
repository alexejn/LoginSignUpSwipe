
import QuartzCore
import CoreImage
import Foundation
import UIKit

public final class SwipeMaskLayer : CAShapeLayer {

    let anchorBottomMargin: CGFloat
    let horizontalMargin: CGFloat
    let maskSwipeMaxY: CGFloat
    let maskSwipeMaxX: CGFloat
    let arcRadius: CGFloat
    let clockwise: Bool
    public init(frame:CGRect, horizontalMargin: CGFloat, anchorBottomMargin: CGFloat, clockwise: Bool = true ) {
        
        self.horizontalMargin = horizontalMargin
        self.anchorBottomMargin = anchorBottomMargin
        self.maskSwipeMaxY = frame.maxY
        self.maskSwipeMaxX = frame.maxX
        self.arcRadius = maskSwipeMaxY
        self.clockwise = clockwise
        
        super.init()
        
        self.lineWidth = arcRadius * 2
        self.frame = frame
        self.fillColor = UIColor.clear.cgColor
        self.strokeColor = UIColor.black.cgColor
        self.path = path1.cgPath
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate private(set) lazy var path1: UIBezierPath = {
        let pacPath = UIBezierPath()
        let xCenter = self.clockwise ? self.horizontalMargin : self.maskSwipeMaxX -  self.horizontalMargin
        let pacPathCirleCenter = CGPoint(x: xCenter,
                                         y: self.maskSwipeMaxY - self.anchorBottomMargin)
        let startAngl =  self.clockwise ? -180.degreesToRadians : 0
        let endAngle =  self.clockwise ? 180.degreesToRadians : 360.degreesToRadians
        pacPath.addArc(withCenter: pacPathCirleCenter,
                       radius: self.arcRadius,
                       startAngle: CGFloat(startAngl)  ,
                       endAngle: CGFloat(endAngle),
                       clockwise: true)
        return pacPath
        
    }()
    
    fileprivate private(set) lazy var path2: UIBezierPath = {
        let pacPath2 = UIBezierPath()
        let xCenter = self.clockwise ? self.maskSwipeMaxX : 0
        let pacPath2CirleCenter = CGPoint(x: xCenter,
                                          y: self.maskSwipeMaxY - self.anchorBottomMargin)
        
        let startAngl =  self.clockwise ? -180.degreesToRadians : 0
        let endAngle =  self.clockwise ? 180.degreesToRadians : 360.degreesToRadians
        pacPath2.addArc(withCenter: pacPath2CirleCenter,
                        radius: self.arcRadius,
                        startAngle: CGFloat(startAngl)  ,
                        endAngle: CGFloat(endAngle),
                        clockwise: true)
        return pacPath2
        
    }()
    
    public func animate(duration: CFTimeInterval){
        let pathAnim = CABasicAnimation(keyPath: "path")
        pathAnim.toValue = path2.cgPath
        pathAnim.fromValue = path1.cgPath
        
        let startStroke = CABasicAnimation(keyPath: "strokeStart")
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        
        startStroke.toValue = 0.25
        startStroke.fromValue = 0
        strokeEnd.toValue = 0.75
        strokeEnd.fromValue = 1
 
        
        let group = CAAnimationGroup()
        group.duration = duration
        group.animations = [startStroke,strokeEnd, pathAnim ]
        
        add(group, forKey: "move")
    }
}
