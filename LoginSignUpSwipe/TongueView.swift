
import QuartzCore
import CoreImage
import Foundation
import UIKit


@IBDesignable
public final class TongueView : UIView {
    
    var shapeLayer: CAShapeLayer {
        return layer as! CAShapeLayer
    }
    
   public var tapAction:(()->())? = nil
    
   @IBInspectable var labelText: String = "OR SING UP" {
        didSet{
            label.text = labelText
        }
    }
    
    @IBInspectable var labelColor: UIColor = UIColor.white {
        didSet{
            label.textColor = labelColor
        }
    }
    
    @IBInspectable var clockWiseOrientatation: Bool = true {
        didSet{
            setNeedsLayout()
        }
    }
    
    @IBInspectable var viewColor: UIColor = UIColor.green {
        didSet{
            shapeLayer.fillColor = viewColor.cgColor
        }
    }
    
    override public static var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override public func prepareForInterfaceBuilder() {
        shapeLayer.setNeedsDisplay()
    }
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)!
        initPhase2()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initPhase2()
        
    }
    
    internal private(set) lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: self.frame.size))
        label.text = self.labelText
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    internal private(set) lazy var widthAddinglayer: CALayer = {
        let la = CALayer()
        return la
    }()
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let size = frame.size
        let pacPath = UIBezierPath()
        let arcRadius = size.height / 2.0
        
        if clockWiseOrientatation {
            let arcCenter = CGPoint(x: size.width - arcRadius, y: arcRadius )
            pacPath.addArc(withCenter: arcCenter,
                           radius: arcRadius,
                           startAngle: CGFloat(-90.degreesToRadians)  ,
                           endAngle: CGFloat(90.degreesToRadians),
                           clockwise: true)
            pacPath.addLine(to: CGPoint(x: 0, y: size.height))
            pacPath.addLine(to: CGPoint(x: 0, y: 0))
        
        } else
        {
            let arcCenter = CGPoint(x: arcRadius, y: arcRadius )
            pacPath.addArc(withCenter: arcCenter,
                           radius: arcRadius,
                           startAngle: CGFloat(-90.degreesToRadians)  ,
                           endAngle: CGFloat(90.degreesToRadians),
                           clockwise: false)
            pacPath.addLine(to: CGPoint(x: size.width, y: size.height))
            pacPath.addLine(to: CGPoint(x: size.width, y: 0))
        
        }
        
        pacPath.close()
        shapeLayer.path = pacPath.cgPath
        label.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
        backgroundColor = UIColor.clear
        
        let offset = frame.width * (clockWiseOrientatation ?  -1 : 1 )
        widthAddinglayer.backgroundColor = viewColor.cgColor
        widthAddinglayer.frame = bounds.offsetBy(dx: offset, dy: 0)
        
    }
    
    private func initPhase2() {
        shapeLayer.fillColor = viewColor.cgColor
        self.layer.addSublayer(widthAddinglayer)
        self.addSubview(label)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tap)
        
        
    }
    
    public func tapped() { 
        tapAction?()
    }

    
    
    public func animate(duration: CFTimeInterval, maxX: CGFloat){
        let anim = CABasicAnimation(keyPath: "position")
        
        let toXposition = clockWiseOrientatation ?
                            maxX - layer.position.x :
                            layer.frame.size.width / 2.0
        anim.toValue = CGPoint(x: toXposition,
                               y: layer.position.y)
        anim.fromValue = layer.position
        anim.duration = duration 
        layer.add(anim, forKey: nil)
    }
    
 
    public func setLabelToCenter() {
        label.center = CGPoint(x:  bounds.midX, y: bounds.midY)
    }
 
}
