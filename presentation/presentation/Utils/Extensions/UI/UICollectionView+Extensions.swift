//
//  UICollectionView+Extensions.swift
//  presentation
//
//  Created by Nihad Ismayilov on 23.07.24.
//

import UIKit

extension UICollectionView{
    func addCell<Cell: UICollectionViewCell>(type: Cell.Type){
        register(type, forCellWithReuseIdentifier: String(describing: type))
    }
    func getCell<Cell: UICollectionViewCell>(type: Cell.Type, indexPath: IndexPath) -> Cell{
        return dequeueReusableCell(withReuseIdentifier: String(describing: type), for: indexPath) as! Cell
    }
}
