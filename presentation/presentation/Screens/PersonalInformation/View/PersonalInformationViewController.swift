//
//  PersonalInformationVC.swift
//  presentation
//
//  Created by Nihad Ismayilov on 26.07.24.
//

import UIKit
import domain

public class PersonalInformationViewController: UIBaseViewController<PersonalInformationViewModel>, CitySelectionProtocol, UpdateDistrictTextField {
    // MARK: - Variables
    private let bottomSheetTransitioningDelegate = BottomSheetTransitioningDelegate(sheetHeight: .automatic)
    
    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    private lazy var scrollStackView = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .equalSpacing,
        spacing: 32
    )
    private lazy var labelStackView = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .equalCentering,
        spacing: 8
    )
    private lazy var titleLabel = UILabel(
        text: "Şəxsi məlumat",
        textColor: .primaryText,
        font: .systemFont(ofSize: 24, weight: .semibold)
    )
    private lazy var descriptionLabel = UILabel(
        text: "Şəxsi profil məlumatlarını dolduraraq qeydiyyatı tamamlayın.",
        textColor: .secondaryText,
        font: .systemFont(ofSize: 14)
    )
    private lazy var fieldStackView = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .equalSpacing,
        spacing: 24
    )
    private lazy var nameInputView: InputView = {
        let view = InputView()
        view.type = .name
        view.delegate = self
        view.placeHolder = "Ad"
        
        return view
    }()
    private lazy var surnameInputView: InputView = {
        let view = InputView()
        view.type = .name
        view.delegate = self
        view.placeHolder = "Soyad"
        
        return view
    }()
    private lazy var nicknameInputView: InputView = {
        let view = InputView()
        view.type = .nickname
        view.delegate = self
        view.placeHolder = "Ləqəb"
        
        return view
    }()
    private lazy var cityInputView: InputView = {
        let view = InputView()
        view.type = .dropdown
        view.delegate = self
        view.placeHolder = "Şəhər"
        
        return view
    }()
    private lazy var districtInputView: InputView = {
        let view = InputView()
        view.type = .dropdown
        view.delegate = self
        view.placeHolder = "Rayon"
        
        return view
    }()
    private lazy var dobInputView: InputView = {
        let view = InputView()
        view.rightImage = .icInfo
        
        var dateComponent = DateComponents()
        dateComponent.year = -18
        view.type = .birthday(minDate: nil, maxDate: Calendar.current.date(byAdding: dateComponent, to: Date()))
        view.delegate = self
        view.placeHolder = "GG/AA/İİİİ"
        
        return view
    }()
    private lazy var attentionLabel = UILabel(
        text: "Diqqət: Daxil etdiyiniz məlumatlar sonradan yalnız Müştəri Xidmətləri ilə əlaqə saxlanılaraq dəyişdirilə bilər",
        textColor: .secondaryText,
        font: .systemFont(ofSize: 14)
    )
    private lazy var confirmButton = BaseButton(
        title: "Tamamla",
        tintColor: .neutral1,
        backgroundColor: .red600,
        cornerRadius: 8,
        isEnabled: false
    )
    
    // MARK: - Controller Delegates
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Initializations
    override func initViews() {
        setNavigationButton()
        view.addSubviews(scrollView, attentionLabel, confirmButton)
        scrollView.addSubview(scrollStackView)
        scrollStackView.addArrangedSubviews(labelStackView, fieldStackView)
        labelStackView.addArrangedSubviews(titleLabel, descriptionLabel)
        fieldStackView.addArrangedSubviews(nameInputView, surnameInputView, nicknameInputView, cityInputView, districtInputView, dobInputView)
        confirmButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            scrollView.bottomAnchor.constraint(equalTo: attentionLabel.topAnchor, constant: -12),
            
            scrollStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollStackView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor),
            
            attentionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            attentionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            attentionLabel.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -24),
            
            confirmButton.heightAnchor.constraint(equalToConstant: 48),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    override func setText() {
        attentionLabel.attributedText = "Diqqət: Daxil etdiyiniz məlumatlar sonradan yalnız Müştəri Xidmətləri ilə əlaqə saxlanılaraq dəyişdirilə bilər".colorAttributedString(strings: ["Diqqət:"], color: .red600)
    }
    
    private func setNavigationButton() {
        navigationController?.navigationBar.isHidden = true
        let button = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left")!,
            style: .plain,
            target: self,
            action: nil
        )
        button.tintColor = .primaryText
        navigationItem.leftBarButtonItems = [button]
    }
    
    override func setBindings() {
        let profileSubscription = viewModel.observeProfile()
            .sink { [weak self] profileData in
                guard let self else { return }
                if profileData.isSuccess == true {
                    let vc = Router.getTabbarController()
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .fullScreen
                    present(vc, animated: true)
                    clearStack()
                } else {
                    
                }
            }
        addCancellable(profileSubscription)
    }
    
    // MARK: - Functions
    func updateCityTextField(selectedCity: LocationData) {
        viewModel.model.cityId = selectedCity.id
        viewModel.model.cityName = selectedCity.name
        viewModel.model.regionId = nil
        viewModel.model.regionName = nil
        cityInputView.text = viewModel.model.cityName ?? ""
        districtInputView.text = ""
        confirmButton.isEnabled = viewModel.isButtonActive()
    }
    
    func updateDistrictTextField(selectedRegion: RegionData) {
        viewModel.model.regionId = selectedRegion.id
        viewModel.model.regionName = selectedRegion.name
        districtInputView.text = viewModel.model.regionName ?? ""
        confirmButton.isEnabled = viewModel.isButtonActive()
    }
    
    @objc func didTap(_ sender: UIButton) {
        viewModel.updateProfile()
    }
}

extension PersonalInformationViewController: InputViewDelegate {
    func didTapTextField(textField: InputView) {
        if textField == cityInputView {
            let vc = Router.getCitySelectionVC(selectedID: viewModel.model.cityId)
            vc.delegate = self
            self.present(vc, animated: true)
        }
        
        else if textField == districtInputView, !viewModel.model.cityId.isNilOrZero {
            let vc = Router.getDistrictSelectionVC(
                selectedID: viewModel.model.regionId,
                cityID: viewModel.model.cityId
            )
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func textFieldDidChangeSelection(_ textField: InputView, string: String) {
        switch textField {
        case nameInputView:
            viewModel.model.name = textField.text.count > 2 ? textField.text : nil
            if textField.text.containsNumber(){
                textField.showError(text: "Yalnız hərf daxil edilməlidir")
            }
            else if textField.text.count < 3 {
                textField.showError(text: "Bu xana minimum 3 hərfdən ibarət olmalıdır")
            }
            else{
                textField.hideError()
            }
        case surnameInputView:
            viewModel.model.lastName = textField.text.count > 2 ? textField.text : nil
            if textField.text.containsNumber(){
                textField.showError(text: "Yalnız hərf daxil edilməlidir")
            }
            else if textField.text.count < 3 {
                textField.showError(text: "Bu xana minimum 3 hərfdən ibarət olmalıdır")
            }
            else{
                textField.hideError()
            }
        case nicknameInputView:
            viewModel.model.nickName = textField.text.count >= 2 ? textField.text : nil
            if textField.text.count < 2 {
                textField.showError(text: "Bu xana minimum 2 hərf və ya rəqəmdən ibarət olmalıdır")
            }
            else{
                textField.hideError()
            }
        case dobInputView:
            if let birthDate = dobInputView.text.convertToDate(), isOlderThan18(birthDate: birthDate) {
                viewModel.model.birthday = textField.text.convertDate(to: "yyyy-MM-dd")
                dobInputView.hideError()
            } else {
                viewModel.model.birthday = nil
                dobInputView.showError(text: "18 yaşından kiçik ola bilməz")
            }
        default: break
        }
        confirmButton.isEnabled = viewModel.isButtonActive()
    }
    
    func didTapRightIcon() {
        let bottomSheetVC = Router.getBottomSheetVC()
        bottomSheetVC.modalPresentationStyle = .custom
        bottomSheetVC.transitioningDelegate = bottomSheetTransitioningDelegate
        present(bottomSheetVC, animated: true)
    }
}
