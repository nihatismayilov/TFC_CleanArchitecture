//
//  DistrictSelectionViewController.swift
//  presentation
//
//  Created by Rufat  on 01.08.24.
//

import UIKit
import domain

protocol UpdateDistrictTextField: AnyObject{
    func updateDistrictTextField(selectedRegion: RegionData)
}

class DistrictSelectionViewController: UIBaseViewController<DistrictSelectionViewModel> {
    // MARK: - Variables
    weak var delegate: UpdateDistrictTextField?
    
    // MARK: - UI Components
    private lazy var stackView  = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: 16
    )
    private let topView = UIView(backgroundColor: .clear)
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
    private lazy var districtsTableView : UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addCell(type: CityAndDistrictTableViewCell.self)
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: -12, bottom: 0, right: 0)
        
        return tableView
    }()
    
    // MARK: - Controller Delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getDistrict()
    }
    
    // MARK: - Initializations
    override func initViews() {
        view.addSubview(stackView)
        
        stackView.addArrangedSubviews(topView,searchField,districtsTableView)
        topView.addSubviews(sectionNameLabel, dismissButton)
        dismissButton.addTarget(self, action: #selector(didTapDismiss(_ :)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor,constant: 12),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 12),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -12),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            topView.heightAnchor.constraint(equalToConstant: 24),
            
            sectionNameLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            sectionNameLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            
            dismissButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            dismissButton.widthAnchor.constraint(equalToConstant: 24),
            dismissButton.heightAnchor.constraint(equalToConstant: 24),
            dismissButton.leadingAnchor.constraint(equalTo: sectionNameLabel.trailingAnchor, constant: 90)
        ])
    }
    
    override func initVars() {
    }
    
    override func setText() {
    }
    
    override func setBindings() {
        let districtSubscription = viewModel.observeDistrict()
            .sink { [weak self] cities in
                guard let self else { return }
                districtsTableView.reloadData()
            }
        addCancellable(districtSubscription)
    }
    
    // MARK: - Functions
    @objc private func didTapDismiss(_ sender : UIButton) {
        self.dismiss(animated: true)
    }
}

extension DistrictSelectionViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredRegions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getCell(type: CityAndDistrictTableViewCell.self)
        
        let data = viewModel.filteredRegions[indexPath.row]
        
        cell.setupCell(model: data, selectedID: viewModel.selectedID)        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CityAndDistrictTableViewCell
        cell.checkMark.image =  UIImage(systemName: "checkmark")!
        delegate?.updateDistrictTextField(selectedRegion: viewModel.filteredRegions[indexPath.row])
        self.dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
}

extension DistrictSelectionViewController : InputViewDelegate {
    func textFieldDidChangeSelection(_ textField: InputView, string: String) {
        viewModel.filterDistricts(text: string)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.districtsTableView.reloadData()
//        }
        
    }
}
