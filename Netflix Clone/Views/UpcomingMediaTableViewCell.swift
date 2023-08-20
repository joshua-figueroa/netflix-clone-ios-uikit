//
//  UpcomingMediaTableViewCell.swift
//  Netflix Clone
//
//  Created by Joshua Figueroa on 8/16/23.
//

import UIKit
import SDWebImage

class UpcomingMediaTableViewCell: UITableViewCell {

    static let identifier = "UpcomingMediaTableViewCell"
    
    private let playMediaButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let mediaTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mediaPosterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(mediaPosterImage)
        contentView.addSubview(playMediaButton)
        contentView.addSubview(mediaTitleLabel)
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        let mediaPosterImageConstraints = [
            mediaPosterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            mediaPosterImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mediaPosterImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            mediaPosterImage.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let playMediaButtonConstraints = [
            playMediaButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playMediaButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let mediaTitleLabelConstraints = [
            mediaTitleLabel.leadingAnchor.constraint(equalTo: mediaPosterImage.trailingAnchor, constant: 20),
            mediaTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mediaTitleLabel.trailingAnchor.constraint(equalTo: playMediaButton.leadingAnchor, constant: -20),
        ]
        
        NSLayoutConstraint.activate(mediaPosterImageConstraints)
        NSLayoutConstraint.activate(playMediaButtonConstraints)
        NSLayoutConstraint.activate(mediaTitleLabelConstraints)
    }
    
    public func configure(with model: MediaContentViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.poster)") else {return}
        mediaPosterImage.sd_setImage(with: url, completed: nil)
        mediaTitleLabel.text = model.title
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
