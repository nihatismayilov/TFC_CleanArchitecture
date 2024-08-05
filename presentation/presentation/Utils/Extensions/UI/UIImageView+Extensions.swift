//
//  UIImageView+Extensiosn.swift
//  presentation
//
//  Created by Nihad Ismayilov on 23.07.24.
//

import UIKit

extension UIImageView {
    convenience init(image: UIImage?, backgroundColor: UIColor? = nil, tintColor: UIColor? = nil) {
        self.init()
        
        self.image = image
                
        self.backgroundColor = backgroundColor
        
        self.tintColor = tintColor
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}
