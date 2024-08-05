//
//  CustomCityTableViewCell.swift
//  presentation
//
//  Created by Rufat  on 31.07.24.
//

import UIKit

class CustomCityAndDistrictTableViewCell: UITableViewCell {
    let cityLabel = UILabel(text: "", textColor: .black, font: .systemFont(ofSize: 16,weight: .regular))
    let checkMark = UIImageView(image: nil, tintColor: .red)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(cityName : String,selectedCity : String?) {
        contentView.addSubview(cityLabel)
        contentView.addSubview(checkMark)
        cityLabel.text = cityName
        checkMark.image = (cityName == selectedCity) ? UIImage(systemName: "checkmark")! : nil
//        print("Checking >>>>\(cityName == selectedCity)")
//        checkMark.isHidden = true
        NSLayoutConstraint.activate([
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cityLabel.heightAnchor.constraint(equalToConstant: 20),
            cityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cityLabel.trailingAnchor.constraint(equalTo: checkMark.leadingAnchor,constant: -2),
//            cityLabel.widthAnchor.constraint(equalToConstant: cityName.getTextWidth(with: .systemFont(ofSize: 16, weight: .regular))),
            
            checkMark.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkMark.widthAnchor.constraint(equalToConstant: 20),
            checkMark.heightAnchor.constraint(equalToConstant: 20),
            checkMark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

}
