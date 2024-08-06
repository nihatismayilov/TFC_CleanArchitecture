//
//  DistrictSelectionViewController.swift
//  presentation
//
//  Created by Rufat  on 01.08.24.
//

import UIKit

protocol UpdateDistrictTextField: AnyObject{
    func updateDistrictTextField(selectedDistrict : String)
}

class DistrictSelectionViewController: UIBaseViewController<BaseViewModel> {
    private var dummyDataCopy : [String] = []
    private var dummyData : [String] = ["Yasamal","Sabuncu","Sebail","Buzovna","Goygol"]
    var selectedCity : String?
    weak var delegate : UpdateDistrictTextField?
    private var isCitySelected : Bool = false
    
    private lazy var stackView  = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: 16
    )
    
    private let topView : UIView = {
        let view = UIView(backgroundColor: .clear)
        return view
    }()
    
    private lazy var sectionNameLabel  = UILabel(
        text: "Şəhər seçin",
        textColor: .primaryText,
        textAlignment: .center ,
        font: .systemFont(ofSize: 18,weight: .semibold)
    )
    
    private lazy var dismissButton = UIButton(
        image: UIImage(systemName: "xmark"),
        tintColor: .black
    )
    private lazy var searchField : InputView = {
        let view =  InputView()
        view.type = .search
        view.delegate = self
        return view
    }()
    
    private lazy var citiesTableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: -12, bottom: 0, right: 0)
        tableView.addCell(type: CustomCityAndDistrictTableViewCell.self)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initViews() {
        view.addSubview(stackView)
        
        stackView.addArrangedSubviews(topView,searchField,citiesTableView)
        addSubviews()
        citiesTableView.delegate = self
        citiesTableView.dataSource = self
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor,constant: 12),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 12),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -12),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
            topView.heightAnchor.constraint(equalToConstant: 24),
            
            searchField.heightAnchor.constraint(equalToConstant: 36),
            
            sectionNameLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            sectionNameLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor),

            dismissButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            dismissButton.widthAnchor.constraint(equalToConstant: 24),
            dismissButton.heightAnchor.constraint(equalToConstant: 24),
            dismissButton.leadingAnchor.constraint(equalTo: sectionNameLabel.trailingAnchor, constant: 90)
        ])
        
    }
    override func initVars() {
        dummyDataCopy = dummyData
    }
    private func addSubviews() {
        topView.addSubview(sectionNameLabel)
        topView.addSubview(dismissButton)
        dismissButton.addTarget(self, action: #selector(didTapDismiss(_ :)), for: .touchUpInside)
    }
    @objc private func didTapDismiss(_ sender : UIButton) {
        self.dismiss(animated: true)
    }
}

extension DistrictSelectionViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getCell(type: CustomCityAndDistrictTableViewCell.self)
        cell.setupCell(cityName: dummyData[indexPath.row],selectedCity: selectedCity!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CustomCityAndDistrictTableViewCell
        cell.checkMark.image =  UIImage(systemName: "checkmark")!
        delegate?.updateDistrictTextField(selectedDistrict: cell.cityLabel.text!)
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
}

extension DistrictSelectionViewController : InputViewDelegate {
    func textFieldDidChangeSelection(_ textField: InputView, string: String) {
        print("i did")
        if string != ""{
            dummyData = dummyDataCopy.filter { $0.lowercased().contains(string.lowercased()) }
        }else{
            dummyData = dummyDataCopy
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.citiesTableView.reloadData()
        }
    }
}
