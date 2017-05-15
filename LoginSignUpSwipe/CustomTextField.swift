//
//  CustomTextField.swift
//  LoginSignUpSwipe
//
//  Created by Alexej Nenastev on 05.05.17.
//  Copyright © 2017 Alexej Nenastev. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomTextField: UITextField {

    @IBInspectable
    override var placeholder: String? {
        didSet {
            let plcaeholderColor = UIColor.white.withAlphaComponent(0.3)
            attributedPlaceholder = NSAttributedString(string:placeholder ?? "", attributes: [NSForegroundColorAttributeName: plcaeholderColor])
        }
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: 15, dy: 2)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: 15, dy: 2)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: 15, dy: 2)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initPhase2()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initPhase2()
    }
    
    private func initPhase2() {
        
        textColor = UIColor.white
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 0
        backgroundColor = UIColor.white.withAlphaComponent(0.5)
        layer.cornerRadius = frame.height / 2.0
        layer.masksToBounds = true
        clipsToBounds = true
            
        self.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        
    }
    
    func editingDidEnd() {
    
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.fromValue = layer.cornerRadius
        animation.toValue = frame.height / 2.0
        animation.duration = 0.15
        self.layer.borderWidth = 0
        self.layer.cornerRadius = frame.height / 2.0
        self.layer.add(animation, forKey: "cornerRadius")
    }
    
    
    func editingDidBegin() {
        let rad:CGFloat = 8.0
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.fromValue = layer.cornerRadius
        animation.toValue = rad
        animation.duration = 0.15
        self.layer.borderWidth = 2
        self.layer.cornerRadius = rad
       self.layer.add(animation, forKey: "cornerRadius")
        
        
    }
}
