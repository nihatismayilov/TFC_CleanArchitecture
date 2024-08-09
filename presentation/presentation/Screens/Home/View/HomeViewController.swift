//
//  HomeViewController.swift
//  presentation
//
//  Created by Nihad Ismayilov on 06.08.24.
//

import UIKit

public class HomeViewController: UIBaseViewController<HomeViewModel> {
    // MARK: - Variables
    
    // MARK: - UI Components
    private lazy var storyCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.bounces = false
        view.showsHorizontalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        view.isPagingEnabled = true
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        view.addCell(type: StoryCell.self)

        return view
    }()
    
    // MARK: - Controller Delegates
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getStory()
    }
    
    // MARK: - Initializations
    override func initViews() {
        view.addSubviews(storyCollectionView)
        NSLayoutConstraint.activate([
            storyCollectionView.heightAnchor.constraint(equalToConstant: 68),
            storyCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            storyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            storyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    override func setBindings() {
        let storySubscription = viewModel.observeStory()
            .sink { [weak self] isSuccess in
                guard let self else { return }
                storyCollectionView.reloadData()
            }
        addCancellable(storySubscription)
    }
    
    // MARK: - Functions
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getStories().count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.getCell(type: StoryCell.self, indexPath: indexPath)
        
        let data = viewModel.getStories()[indexPath.row]
        cell.setupCellWith(imageString: data.fileURL, isRead: data.isRead)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = Router.getStoryViewController(currentIndex: indexPath.item)
        present(vc, animated: true)
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if scrollView == cardCollectionView {
//            let index = Int(cardCollectionView.contentOffset.x / cardCollectionView.frame.width)
//            vm.fetTransactions(by: vm.cards[index].id)
//            pageController.currentPage = index
//        }
//    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 68, height: 68)
    }
}
