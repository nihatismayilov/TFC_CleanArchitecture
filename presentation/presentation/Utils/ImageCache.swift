//
//  ImageCache.swift
//  presentation
//
//  Created by Nihad Ismayilov on 09.08.24.
//

import UIKit

class ImageCache {
    static let shared = NSCache<NSURL, UIImage>()
}
