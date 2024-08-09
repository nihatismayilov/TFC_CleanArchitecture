//
//  StoryViewController.swift
//  presentation
//
//  Created by Nihad Ismayilov on 08.08.24.
//

import UIKit
import domain

public class StoryViewController: UIBaseViewController<StoryViewModel> {
    // MARK: - Variables
    var currentIndex = 0
    var isFirstLoading = true
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.bounces = false
        view.showsHorizontalScrollIndicator = false

        view.isPagingEnabled = true
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        view.addCell(type: StoryCollectionViewCell.self)

        return view
    }()
    
    // MARK: - Controller Delegates
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getStory()
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // MARK: - Initializations
    override func initViews() {
        view.addSubviews(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    override func setText() {
        
    }
    
    override func setBindings() {
        let storySubscription = viewModel.observeStory()
            .sink { [weak self] isSuccess in
                guard let self else { return }
                collectionView.reloadData()
                scrollToSelectedStatus()
            }
        addCancellable(storySubscription)
    }
    
    // MARK: - Functions
    @objc func appWillEnterForeground() {
        if let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? StoryCollectionViewCell {
            if cell.isImageLoaded {
                cell.resetOrSetPlayer()
            }
        }
    }
}

extension StoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getStories().count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.getCell(type: StoryCollectionViewCell.self, indexPath: indexPath)
        let data = viewModel.getStories()[indexPath.row]
        
        cell.setupCellWith(data: data)
        cell.delegate = self
        return cell
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
            if index != currentIndex {
                resetAndStartTimer(nextIndex: index, scrollView: scrollView)
            }
        }
    }
    
    func resetAndStartTimer(nextIndex: Int, scrollView: UIScrollView) {
        let previousCell = collectionView.getCertainCell(type: StoryCollectionViewCell.self, index: currentIndex)
        if nextIndex != currentIndex {
            self.currentIndex = nextIndex
            let nextCell = collectionView.getCertainCell(type: StoryCollectionViewCell.self, index: currentIndex)
            previousCell.stopAndRemove()
            if nextCell.isImageLoaded {
                nextCell.resetOrSetPlayer()
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension StoryViewController: StoryCollectionViewCellDelegate {
    func closeTapped() {
        dismiss(animated: true)
    }
    
    func moveTo(cell: StoryCollectionViewCell, index: Int) {
        view.isUserInteractionEnabled = false
        collectionView.isPagingEnabled = false
        var frame: CGRect = collectionView.frame
        frame.origin.x = frame.size.width * CGFloat(( currentIndex + index))
        collectionView.scrollRectToVisible(frame, animated: true)
        collectionView.isPagingEnabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.currentIndex += index
            if let nextCell = self.collectionView.cellForItem(at: IndexPath(row: self.currentIndex, section: 0)) as? StoryCollectionViewCell {
                cell.stopAndRemove()
                if nextCell.isImageLoaded {
                    nextCell.resetOrSetPlayer()
                }
                self.view.isUserInteractionEnabled = true
            } else {
                self.dismiss(animated: true)
            }
        })
    }
    
    func openLink(with urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:]) { success in
                if success {
                    print("The URL was successfully opened.")
                } else {
                    print("The URL could not be opened.")
                }
            }
        }
    }
}

extension StoryViewController {
    private func scrollToSelectedStatus() {
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            let cell = self.collectionView.getCertainCell(type: StoryCollectionViewCell.self, index: self.currentIndex)
            if cell.isImageLoaded {
                cell.resetOrSetPlayer()
            }
        })
    }
}
