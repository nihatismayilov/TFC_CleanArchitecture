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

extension UIImageView {
    func loadImage(with url: URL) {
        if let cachedImage = ImageCache.shared.object(forKey: url as NSURL) {
            self.image = cachedImage
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let downloadedImage = UIImage(data: data),
                  error == nil else { return }
            
            ImageCache.shared.setObject(downloadedImage, forKey: url as NSURL)
            
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }.resume()
    }
}
