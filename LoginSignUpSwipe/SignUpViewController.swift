//
//  SignUpViewController.swift
//  LoginSignUpSwipe
//
//  Created by Alexej Nenastev on 03.05.17.
//  Copyright © 2017 Alexej Nenastev. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIViewControllerTransitioningDelegate, UITextFieldDelegate {

    @IBOutlet weak var sbs_height_constr: NSLayoutConstraint!
    @IBOutlet weak var sbs_horizontal_space_to_tongue: NSLayoutConstraint!
    @IBOutlet weak var sbs_y_center_constr: NSLayoutConstraint!
    @IBOutlet weak var socialButtonsStack: UIStackView!
    @IBOutlet weak var spaceView: UIView!
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTongueConstraint: NSLayoutConstraint!
    @IBOutlet var textFields: [CustomTextField]!
    
    @IBOutlet weak var tongueView: TongueView!
    @IBOutlet weak var labelSignUp: UILabel!
    
    private var bottomTongueConstraintInitValue: CGFloat!
    private var logoWidthConstraintInitValue: CGFloat!
    private var sbs_horizontal_space_to_tongue_init_val: CGFloat!
    private var sbs_y_center_constr_init_val: CGFloat!
    private var sbs_height_constr_init_val: CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tongueView.tapAction = {  self.presentingViewController?.dismiss(animated: true, completion: nil) }
        
        textFields.forEach { $0.delegate = self }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissmisKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        
        logoWidthConstraint.constant = view.frame.size.width / 4.0
        sbs_height_constr.constant = tongueView.bounds.size.height / 1.7
        
        bottomTongueConstraintInitValue = bottomTongueConstraint.constant
        logoWidthConstraintInitValue = logoWidthConstraint.constant
        sbs_horizontal_space_to_tongue_init_val = sbs_horizontal_space_to_tongue.constant
        sbs_y_center_constr_init_val = sbs_y_center_constr.constant
        sbs_height_constr_init_val = sbs_height_constr.constant
    }
  
 
    private lazy var tongueLabelOffset: CGFloat = { return self.tongueView.frame.height / 4.0}()
    
    func keyboardWillShow(notification: NSNotification) {
        
        print("keyboardWillShow")
        let newConst = notification.getKeyboardHeight()  - tongueView.bounds.midY
        guard bottomTongueConstraint.constant != newConst else {  return }
        
        let newLabelCenter = CGPoint(x: tongueView.label.center.x, y: tongueView.label.center.y - tongueLabelOffset)
        
        self.bottomTongueConstraint.constant = newConst
        self.logoWidthConstraint.constant = logoWidthConstraintInitValue / 2.3
        sbs_horizontal_space_to_tongue.constant = sbs_horizontal_space_to_tongue_init_val * 6
        sbs_y_center_constr.constant = sbs_y_center_constr.constant - tongueLabelOffset - 3
        sbs_height_constr.constant = tongueView.bounds.size.height / 2.5
        
        spaceView.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0 ,  options: [], animations: {
            
            self.view.layoutIfNeeded()
            self.tongueView.label.center = newLabelCenter
        })
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        print("keyboardWillHide")
        guard bottomTongueConstraint.constant != bottomTongueConstraintInitValue else {  return }
        
        let newLabelCenter = CGPoint(x: tongueView.label.center.x, y: tongueView.label.center.y + tongueLabelOffset)
        
        
        self.bottomTongueConstraint.constant = bottomTongueConstraintInitValue
        self.logoWidthConstraint.constant = logoWidthConstraintInitValue
        spaceView.isHidden = false
        sbs_horizontal_space_to_tongue.constant = sbs_horizontal_space_to_tongue_init_val
        sbs_y_center_constr.constant = sbs_y_center_constr_init_val
        sbs_height_constr.constant = sbs_height_constr_init_val
        UIView.animate(withDuration: 0.5, delay: 0 ,  options: [], animations: {
            
            self.view.layoutIfNeeded()
            self.tongueView.label.center = newLabelCenter
        })
    }
    
    
    func dissmisKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }

}

extension SignUpViewController: TongueSwipeController {
    
    var tongue: TongueView { return self.tongueView }
    var nameLabel : UILabel { return self.labelSignUp }
    var socialButtonsView : UIStackView { return self.socialButtonsStack }
 
}
