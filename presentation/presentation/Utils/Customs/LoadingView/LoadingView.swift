//
//  LoadingView.swift
//  presentation
//
//  Created by Nihad Ismayilov on 29.07.24.
//

import UIKit

class LoadingView: UIView {
    let _view = LoadingViewUI()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        embedSwiftUIView(_view)
    }
}
