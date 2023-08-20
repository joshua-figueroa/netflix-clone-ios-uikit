//
//  CollectionTableViewCell.swift
//  Netflix Clone
//
//  Created by Joshua Figueroa on 8/13/23.
//

import UIKit

protocol CollectionTableViewCellDelegate: AnyObject {
    func collectionTableViewCellDidTapCell(_ cell: CollectionTableViewCell, viewModel: MediaPreviewViewModel)
}

class CollectionTableViewCell: UITableViewCell {

    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionTableViewCellDelegate?
    
    private var mediaContents: [MediaContent] = [MediaContent]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.layer.borderColor = UIColor.clear.cgColor
        collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: ContentCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with contents: [MediaContent]) {
        self.mediaContents = contents
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension CollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCollectionViewCell.identifier, for: indexPath) as? ContentCollectionViewCell else {return UICollectionViewCell()}
        
        cell.layer.borderColor = UIColor.clear.cgColor

        
        cell.configure(with: mediaContents[indexPath.row].poster_path)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaContents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let media = mediaContents[indexPath.row]
        guard let titleName = media.original_title ?? media.original_name else { return }
        
        APICaller.shared.getTrailer(with: "\(titleName) trailer") { result in
            switch result {
            case .success(let trailer) :
                self.delegate?.collectionTableViewCellDidTapCell(self, viewModel: MediaPreviewViewModel(title: titleName, overview: media.overview, youtubeVideo: trailer))
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
            }
        }
    }
}
