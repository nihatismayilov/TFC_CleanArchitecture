//
//  UIView+Extensions.swift
//  presentation
//
//  Created by Nihad Ismayilov on 23.07.24.
//

import UIKit
import SwiftUI

extension UIView {
    
    convenience init(backgroundColor: UIColor = .clear, cornerRadius: CGFloat = 0) {
        self.init()
        
        self.backgroundColor = backgroundColor
        
        self.cornerRadius = cornerRadius
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
        }
    }
    
    var borderWidth: CGFloat {
        get {
            layer.borderWidth
        } set {
            layer.borderWidth = newValue
        }
    }
    
    var borderColor: UIColor {
        get {
            UIColor(cgColor: layer.borderColor ?? UIColor.black.cgColor)
        } set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            addSubview(view)
        }
    }
    
    func dropShadow(scale: Bool = true, shadowColor: UIColor) {
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func embedSwiftUIView(_ swiftUIView: some View, padding: UIEdgeInsets = .zero){
        guard let view = UIHostingController(rootView: swiftUIView).view else {return}
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.right),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom),
            view.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
        ])
    }
    
    func getSwiftUIView(_ swiftUIView: some View, padding: UIEdgeInsets = .zero) -> UIView? {
        guard let view = UIHostingController(rootView: swiftUIView).view else {return nil}
        return view
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .clear
//        addSubview(view)
//        NSLayoutConstraint.activate([
//            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left),
//            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.right),
//            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom),
//            view.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
//        ])
    }
}
