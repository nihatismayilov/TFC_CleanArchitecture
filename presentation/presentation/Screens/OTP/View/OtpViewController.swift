//
//  OtpVC.swift
//  presentation
//
//  Created by Nihad Ismayilov on 24.07.24.
//

import UIKit

public class OtpViewController: UIBaseViewController<OtpViewModel> {
    // MARK: - Contraint to be handled
    private var bottomConstraintToHandle : NSLayoutConstraint?
    // MARK: - Variables
    let seconds: Double = 120
    lazy var secondsLeft: Double = seconds
    var timer = Timer()
    
    // MARK: - UI Components
    private lazy var labelStackView = UIStackView(
        axis: .vertical,
        spacing: 8
    )
    private lazy var titleLabel = UILabel(
        text: "SMS kod",
        textColor: .primaryText,
        font: .systemFont(ofSize: 24, weight: .semibold)
    )
    private lazy var descriptionLabel = UILabel(
        text: "+994 XX XXX XX XX nömrəsinə SMS vasitəsilə göndərilmiş kodu daxil edin.",
        textColor: .secondaryText,
        font: .systemFont(ofSize: 14)
    )
    private lazy var resendStack = UIStackView(
        axis: .horizontal,
        alignment: .fill,
        distribution: .equalSpacing,
        spacing: 8
    )
    
    private lazy var resendLabel = UILabel(
        text: "Kodu əldə etmək alınmadı?",
        textColor: .secondaryText,
        font: .systemFont(ofSize: 14)
    )
    private lazy var resendButton = BaseButton(
        title: "2:00",
        tintColor: .primaryText,
        font: .systemFont(ofSize: 14, weight: .semibold)
    )
    
    private lazy var otpView: OTPView = {
        let view = OTPView()
        view.delegate = self
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var termsConditionsLabel = UILabel(
        text: "Qeydiyyatdan keçdikdə siz Şərtlər və Qaydaları və Gizlilik Siyasətini qəbul edirsiniz.",
        textColor: .secondaryText,
        textAlignment: .center,
        numberOfLines: 0,
        font: .systemFont(ofSize: 12)
    )
    
    private lazy var confirmButton = BaseButton(
        title: "SMS göndər",
        tintColor: .white,
        backgroundColor: .red600,
        cornerRadius: 8,
        isEnabled: false
    )
    
    // MARK: - Controller Delegates
    public override func viewDidLoad() {
        super.viewDidLoad()
        keyboardShift(bottomConstraintToHandle!)
        startTimer()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Initializations
    override func initViews() {
        setNavigationButton()
        
        view.addSubviews(
            labelStackView,
            resendStack,
            otpView,
            termsConditionsLabel,
            confirmButton
        )
        labelStackView.addArrangedSubviews(titleLabel, descriptionLabel)
        resendStack.addArrangedSubviews(resendLabel, resendButton)
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            labelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            resendStack.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 16),
            resendStack.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor),
            resendStack.trailingAnchor.constraint(lessThanOrEqualTo: labelStackView.trailingAnchor),
            
            otpView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            otpView.topAnchor.constraint(equalTo: resendStack.bottomAnchor, constant: 48),
            otpView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            otpView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            
            termsConditionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            termsConditionsLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            termsConditionsLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),
            termsConditionsLabel.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -24),
            
            confirmButton.heightAnchor.constraint(equalToConstant: 48),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
        ])
        bottomConstraintToHandle = confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        bottomConstraintToHandle?.isActive = true
        
        resendButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    override func setText() {
        descriptionLabel.text = "+\(viewModel.phoneNumber.format(with: "XXX XX XXX XX XX")) nömrəsinə SMS vasitəsilə göndərilmiş kodu daxil edin."
        termsConditionsLabel.attributedText = "Qeydiyyatdan keçdikdə siz Şərtlər və Qaydaları və Gizlilik Siyasətini qəbul edirsiniz.".colorAttributedString(strings: ["Şərtlər və Qaydaları", "Gizlilik Siyasətini"], color: .red600)
    }
    
    override func setBindings() {
        let tokenSubscription = viewModel.observeToken()
            .sink { [weak self] isSuccess in
                guard let self else { return }
                if isSuccess {
                    viewModel.getProfile()
//                    pushNavigation(Router.getPersonalInformationVC())
                } else {
                    otpView.wrongOtp = true
                }
            }
        addCancellable(tokenSubscription)
        
        let registerSubscription = viewModel.observeRegister()
            .sink { [weak self] isSuccess in
                guard let self else { return }
                if isSuccess {
                    startTimer()
                }
            }
        addCancellable(registerSubscription)
        
        let profileSubscription = viewModel.observeProfile()
            .sink { [weak self] profileData in
                guard let self else { return }
                if profileData.name == nil {
                let vc = Router.getPersonalInformationViewController()
                vc.viewModel.model.id = profileData.id
                    pushNavigation(vc)
                } else {
                    let vc = Router.getTabbarController()
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .fullScreen
                    present(vc, animated: true)
                    clearStack()
                }
            }
        addCancellable(profileSubscription)
    }
    
    private func setNavigationButton() {
        navigationController?.navigationBar.isHidden = false
        let button = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left")!,
            style: .plain,
            target: self,
            action: #selector(didTap)
        )
        button.tintColor = .primaryText
        navigationItem.leftBarButtonItems = [button]
    }
    
    // MARK: - Functions
    private func startTimer() {
        secondsLeft = seconds
        resendButton.setTitle(seconds.toMinuteSecondsString(), for: .normal)
        resendButton.setTitleColor(.primaryText, for: .normal)
        resendButton.isUserInteractionEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCountdown), userInfo: nil, repeats: true)
    }
    
    @objc func timerCountdown(_ sender: Timer){
        secondsLeft -= 1
        if secondsLeft == 0{
            resendButton.setTitle("Yenidən göndər", for: .normal)
            timer.invalidate()
            resendButton.isUserInteractionEnabled = true
            resendButton.setTitleColor(.red600, for: .normal)
        }else{
            resendButton.setTitle(secondsLeft.toMinuteSecondsString(), for: .normal)
        }
        
    }
    
    @objc func didTap(_ sender: UIButton) {
        switch sender {
        case navigationItem.leftBarButtonItem:
            navigationController?.popViewController(animated: true)
        case resendButton:
            viewModel.register()
        case confirmButton:
            viewModel.token(otp: otpView.getOTPCode())
        default: break
        }
    }
}

extension OtpViewController: CheckOtp {
    func checkOtp(countOfOtp: Int) {
        confirmButton.isEnabled = (countOfOtp == 6)
        confirmButton.alpha = (countOfOtp == 6) ? 1 : 0.5
//        if countOfOtp == 6 { keyboardWillHide() }
        view.endEditing(true)
    }
}
