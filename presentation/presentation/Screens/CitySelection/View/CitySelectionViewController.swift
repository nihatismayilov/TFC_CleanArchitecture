//
//  CitySelectionViewController.swift
//  presentation
//
//  Created by Rufat Akbar  on 31.07.24.
//

import UIKit
import domain

protocol CitySelectionProtocol: AnyObject{
    func updateCityTextField(selectedCity: LocationData)
}

class CitySelectionViewController : UIBaseViewController<CitySelectionViewModel> {
    // MARK: - Variables
    weak var delegate : CitySelectionProtocol?
    
    // MARK: - UI Components
    private let stackView  = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: 16
    )
    private let topView = UIView(backgroundColor: .clear)
    private lazy var sectionNameLabel = UILabel(
        text: "Şəhər seçin",
        textColor: .primaryText,
        textAlignment: .center ,
        font: .systemFont(ofSize: 18,weight: .semibold)
    )
    private lazy var dismissButton = UIButton(
        image: UIImage(systemName: "xmark"),
        tintColor: .black
    )
    private lazy var searchField: InputView = {
        let view =  InputView()
        view.type = .search
        view.delegate = self
        view.placeHolder = "Axtar"
        return view
    }()
    private lazy var citiesTableView: UITableView = {
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
        viewModel.getCity()
    }
    
    // MARK: - Initializations
    override func initViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubviews(topView,searchField,citiesTableView)
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
            dismissButton.leadingAnchor.constraint(equalTo: sectionNameLabel.trailingAnchor, constant: 90),
            
//            searchField.heightAnchor.constraint(equalToConstant: 36),
        ])
        
    }
    override func initVars() {
    }
    
    override func setText() {
        
    }
    
    override func setBindings() {
        let citySubscription = viewModel.observeCity()
            .sink { [weak self] cities in
                guard let self else { return }
                citiesTableView.reloadData()
            }
        addCancellable(citySubscription)
    }
    
    // MARK: - Functions
    @objc private func didTapDismiss(_ sender : UIButton) {
        self.dismiss(animated: true)
    }
}

extension CitySelectionViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getCell(type: CityAndDistrictTableViewCell.self)
        
        let data = viewModel.filteredCities[indexPath.row]
        
        cell.setupCell(model: data, selectedID: viewModel.selectedID)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CityAndDistrictTableViewCell
        
        cell.checkMark.image = UIImage(systemName: "checkmark")!
        
        delegate?.updateCityTextField(selectedCity: viewModel.filteredCities[indexPath.row])
        self.dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
}

extension CitySelectionViewController : InputViewDelegate {
    func textFieldDidChangeSelection(_ textField: InputView, string: String) {
        viewModel.filterCities(text: string)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.citiesTableView.reloadData()
//        }
        
    }
}
