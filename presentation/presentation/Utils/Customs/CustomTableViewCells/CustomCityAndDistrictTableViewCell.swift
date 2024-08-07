//
//  CustomCityTableViewCell.swift
//  presentation
//
//  Created by Rufat  on 31.07.24.
//

import UIKit
import domain

class CityAndDistrictTableViewCell: UITableViewCell {
    let cityLabel = UILabel(
        textColor: .primaryText,
        font: .systemFont(ofSize: 16,weight: .regular)
    )
    let checkMark = UIImageView(
        image: nil,
        tintColor: .red
    )
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        setupView()
    }
    
    private func setupView() {
        contentView.addSubviews(cityLabel, checkMark)
        
        NSLayoutConstraint.activate([
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cityLabel.heightAnchor.constraint(equalToConstant: 20),
            cityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cityLabel.trailingAnchor.constraint(equalTo: checkMark.leadingAnchor,constant: -2),
            
            checkMark.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkMark.widthAnchor.constraint(equalToConstant: 20),
            checkMark.heightAnchor.constraint(equalToConstant: 20),
            checkMark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func setupCell(model: LocationData, selectedID: Int?) {
        cityLabel.text = model.name
        checkMark.image = (model.id == selectedID) ? UIImage(systemName: "checkmark")! : nil
    }
    
    func setupCell(model: RegionData, selectedID: Int?) {
        cityLabel.text = model.name
        checkMark.image = (model.id == selectedID) ? UIImage(systemName: "checkmark")! : nil
    }

}
