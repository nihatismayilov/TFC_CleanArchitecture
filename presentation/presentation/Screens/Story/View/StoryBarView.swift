//
//  StoryBarView.swift
//  presentation
//
//  Created by Nihad Ismayilov on 08.08.24.
//

import UIKit

//protocol StoryBarViewDelegate: NSObject {
//    func storyComplete()
//}

//class StoryBarView: UIView {
//    // MARK: - Variables
//    weak var delegate: StoryBarViewDelegate?
//    private var timer = Timer()
//    private var fps = 30.0
//    private var duration: Double = 3.0
//    var goalWidth: CGFloat = 50.0 {
//        didSet {
//            barBackView.cornerRadius = frame.height / 2
//            barView.cornerRadius = frame.height / 2
//            stepWidth = goalWidth / CGFloat(fps * duration)
//        }
//    }
//    var stepWidth: CGFloat = 0.0
//    @IBInspectable
//    var barBackColor: UIColor? {
//        get {
//            barBackView.backgroundColor
//        } set {
//            barBackView.backgroundColor = newValue
//        }
//    }
//    @IBInspectable
//    var barColor: UIColor? {
//        get {
//            barView.backgroundColor
//        } set {
//            barView.backgroundColor = newValue
//        }
//    }
//    var barWidthConstraint: NSLayoutConstraint!
//
//    // MARK: - UI Components
//    private lazy var barBackView = UIView(backgroundColor: .clear)
//    private lazy var barView = UIView(backgroundColor: .blue)
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setup()
//    }
//
//    convenience init(barColor: UIColor?, barBackColor: UIColor?, duration: Double) {
//        self.init(frame: .zero)
//        self.barColor = barColor
//        self.barBackColor = barBackColor
//        self.duration = duration
////        self.stepWidth = frame.width / CGFloat(fps * duration)
//        setup()
//    }
//
//    private func setup() {
//        translatesAutoresizingMaskIntoConstraints = false
//        setupConstraints()
//    }
//
//    private func setupConstraints() {
//        addSubviews(barBackView)
//        barBackView.addSubviews(barView)
//        barWidthConstraint = barView.widthAnchor.constraint(equalToConstant: 0)
//        barWidthConstraint.isActive = true
//        NSLayoutConstraint.activate([
//            barBackView.topAnchor.constraint(equalTo: topAnchor),
//            barBackView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            barBackView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            barBackView.bottomAnchor.constraint(equalTo: bottomAnchor),
//
//            barView.topAnchor.constraint(equalTo: barBackView.topAnchor),
//            barView.leadingAnchor.constraint(equalTo: barBackView.leadingAnchor),
//            barView.bottomAnchor.constraint(equalTo: barBackView.bottomAnchor),
//        ])
//    }
//
//    func start() {
//        timer = Timer.scheduledTimer(timeInterval: 1/fps, target: self, selector: #selector(fillBar), userInfo: nil, repeats: true)
//    }
//
//    func stop() {
//        if timer.isValid {
//            timer.invalidate()
//        }
//    }
//
//    func pause() {
//        if timer.isValid {
//            timer.invalidate()
//        }
//    }
//
//    func reset() {
//        if timer.isValid {
//            timer.invalidate()
//        }
//        barWidthConstraint.constant = 0
//        start()
//    }
//
//    @objc func fillBar() {
//        if barWidthConstraint.constant >= goalWidth {
//            timer.invalidate()
//            delegate?.storyComplete()
//        } else {
//            barWidthConstraint.constant += stepWidth
//            UIView.animate(withDuration: 1/fps) { // Small animation for smooth transition
//                self.layoutIfNeeded()
//            }
//        }
//    }
//}

protocol StoryBarViewDelegate: NSObject {
    //  func storyEndAction(currentStoryIndex: Int)
    func doneAction()
    //  func showUIAction()
    //  func hideUIAction()
}
@IBDesignable
class StoryBarView: UIView {
    weak var delegate: StoryBarViewDelegate?
    ///
    @IBInspectable public var isAnimating: Bool = false
    /// Color of the single story bar’s background.
    @IBInspectable public var emptyColor: UIColor = .gray
    /// Color of the single story bar’s foreground.
    @IBInspectable public var fullColor: UIColor = .black
    /// Spacing among bars.
    @IBInspectable public var interItemSpacing: CGFloat = 8
    /// Distance from leftmost bar to the left side and from rightmost bar to the right side of the view.
    @IBInspectable public var horizontalMargins: CGFloat = 16
    /// Height of a single bar.
    @IBInspectable public var barHeight: CGFloat = 4
    /// Number of bars.
    @IBInspectable public var numberOfStories: Int = 3
    /// Index of a bar that should start animate.
    @IBInspectable public var currentStoryIndex: Int = 0
    /// Time that it takes a bar to fill.
    @IBInspectable public var storyDuration: Double = 10
    /// Assign `true` if you want to hide the bars when user holds the story and `false` if you don’t.
    @IBInspectable public var hidesOnHold: Bool = true
    private var widthConstraints: [NSLayoutConstraint] = []
    private var timer: Timer!
    private var fps: Double = 30
    private var goalWidth: CGFloat!
    private var stepWidth: CGFloat!
    private var backgroundView: UIView!
    private var stackView: UIStackView!
    public override func draw(_ rect: CGRect) {
        if !self.subviews.isEmpty {
            for subview in self.subviews {
                subview.removeFromSuperview()
            }
        } else {
            let stackViewWidth = self.frame.size.width - horizontalMargins * 2
            let totalSpacing = interItemSpacing * CGFloat(numberOfStories - 1)
            goalWidth = (stackViewWidth - totalSpacing) / CGFloat(numberOfStories)
            stepWidth = goalWidth / CGFloat(fps * storyDuration)
            createBackgroundView()
            createStackView()
            createBars()
        }
        super.draw(rect)
    }
    
    func setupDuration(duration: Double) {
        storyDuration = duration
        stepWidth = goalWidth / CGFloat(fps * storyDuration)
    }
    
    func start() {
        if hidesOnHold {
            if alpha == 0 {
                //        delegate?.showUIAction()
            }
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                [weak self] in
                guard let self else { return }
                self.alpha = 1
            }
        }
        timer = Timer.scheduledTimer(timeInterval: 1/fps, target: self, selector: #selector(fillBar), userInfo: nil, repeats: true)
        isAnimating = true
    }
    @objc func fillBar() {
        if self.widthConstraints[self.currentStoryIndex].constant >= self.goalWidth {
            if self.currentStoryIndex < self.numberOfStories - 1 {
                self.currentStoryIndex = self.currentStoryIndex + 1
                //        delegate?.storyEndAction(currentStoryIndex: self.currentStoryIndex)
            } else {
                delegate?.doneAction()
                timer.invalidate()
            }
        } else {
            self.widthConstraints[self.currentStoryIndex].constant = self.widthConstraints[self.currentStoryIndex].constant + self.stepWidth
        }
    }
    func stop() {
        if hidesOnHold {
            //      delegate?.hideUIAction()
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) { [weak self] in
                guard let self else { return }
                self.alpha = 0
            }
        }
        timer.invalidate()
        isAnimating = false
    }
    
    func pause() {
        if let timer, self.timer.isValid {
            timer.invalidate()
        }
        isAnimating = false
    }
    func reset() {
        if let timer, timer.isValid {
            timer.invalidate()
        }
        start()
        
        currentStoryIndex = 0
        for widthConstraint in widthConstraints {
            widthConstraint.constant = 0
        }
    }
    
    func resetAndStop() {
        if let timer {
            timer.invalidate()
        }
        //      self.stop()
        
        currentStoryIndex = 0
        for widthConstraint in widthConstraints {
            widthConstraint.constant = 0
        }
    }
    public func previous() {
        if let timer, !timer.isValid {
            self.start()
        }
        if currentStoryIndex > 0 {
            widthConstraints[currentStoryIndex].constant = 0
            widthConstraints[currentStoryIndex - 1].constant = 0
            currentStoryIndex = currentStoryIndex - 1
            //      delegate?.storyEndAction(currentStoryIndex: self.currentStoryIndex)
        } else {
            widthConstraints[currentStoryIndex].constant = 0
        }
    }
    public func next() {
        if currentStoryIndex < numberOfStories - 1 {
            widthConstraints[currentStoryIndex].constant = goalWidth
            currentStoryIndex = currentStoryIndex + 1
            //      delegate?.storyEndAction(currentStoryIndex: self.currentStoryIndex)
        } else {
            widthConstraints[currentStoryIndex].constant = goalWidth
        }
    }
    private func createBackgroundView() {
        backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        if let backgroundView = backgroundView {
            NSLayoutConstraint.activate([
                backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                backgroundView.widthAnchor.constraint(equalTo: self.widthAnchor),
                backgroundView.heightAnchor.constraint(equalTo: self.widthAnchor)
            ])
        }
    }
    private func createStackView() {
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = interItemSpacing
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.backgroundColor = .clear
        backgroundView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        if let stackView = stackView {
            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
                stackView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, constant: -2 * horizontalMargins),
                stackView.heightAnchor.constraint(equalToConstant: barHeight)
            ])
        }
    }
    private func createBars() {
        for i in 0 ..< numberOfStories {
            let bar = UIView()
            bar.layer.cornerRadius = barHeight / 2
            bar.clipsToBounds = true
            bar.backgroundColor = self.emptyColor
            stackView.addArrangedSubview(bar)
            let barFill = UIView()
            barFill.backgroundColor = self.fullColor
            bar.addSubview(barFill)
            barFill.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                barFill.topAnchor.constraint(equalTo: bar.topAnchor),
                barFill.leadingAnchor.constraint(equalTo: bar.leadingAnchor),
                barFill.bottomAnchor.constraint(equalTo: bar.bottomAnchor)
            ])
            var width: CGFloat = 0
            if i < currentStoryIndex {
                width = goalWidth
            } else {
                width = 0
            }
            let barFillWidth = barFill.widthAnchor.constraint(equalToConstant: width)
            barFillWidth.isActive = true
            widthConstraints.append(barFillWidth)
        }
    }
}
