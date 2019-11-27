//
//  ShadowView.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/27/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowView: UIView {
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 3, height: 3) {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 15.0 {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.updateView()
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.updateView()
        }
    }

    @IBInspectable var borderColor: UIColor? = nil {
        didSet {
            self.updateView()
        }
    }

    //Apply params
    func updateView() {
        layer.shadowColor   = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset  = shadowOffset
        layer.shadowRadius  = shadowRadius
        layer.cornerRadius  = cornerRadius
        layer.borderWidth   = borderWidth
        layer.borderColor   = borderColor?.cgColor
        
        layer.masksToBounds = cornerRadius > 0
    }
}
