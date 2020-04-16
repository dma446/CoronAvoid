//
//  circleButton.swift
//  CoronAvoid
//
//  Created by Joshua Zhong on 15/04/20.
//  Copyright © 2020 NYU. All rights reserved.
//

import UIKit

class circleButton: UIButton {

/*
// Only override draw() if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
override func draw(_ rect: CGRect) {
// Drawing code
}
*/

    @IBInspectable var cornerRadius: CGFloat {
        didSet{
        self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }


}
