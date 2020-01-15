//
//  UITextView.swift
//  ContactMe
//
//  Created by Javier Portaluppi on 15/01/2020.
//  Copyright © 2020 IPL-Master. All rights reserved.
//

import UIKit

extension UITextView {

    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset + 5 //Only to work with icon images
    }

}
