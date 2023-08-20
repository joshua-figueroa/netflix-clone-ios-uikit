//
//  SearchResultsViewController.swift
//  Netflix Clone
//
//  Created by Joshua Figueroa on 8/18/23.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: MediaPreviewViewModel)
}

class SearchResultsViewController: UIViewController {
    
    public var mediaContent: [MediaContent] = [MediaContent]()
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    public let searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 8, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: ContentCollectionViewCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchResultCollectionView)
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }

}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaContent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCollectionViewCell.identifier, for: indexPath) as? ContentCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: mediaContent[indexPath.row].poster_path)
        cell.layer.borderColor = UIColor.clear.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let media = mediaContent[indexPath.row]
        
        guard let titleName = media.original_title ?? media.original_name else { return }
        
        APICaller.shared.getTrailer(with: "\(titleName) trailer") { result in
            switch result {
            case .success(let trailer) :
                self.delegate?.searchResultsViewControllerDidTapItem(MediaPreviewViewModel(title: titleName, overview: media.overview, youtubeVideo: trailer))
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
