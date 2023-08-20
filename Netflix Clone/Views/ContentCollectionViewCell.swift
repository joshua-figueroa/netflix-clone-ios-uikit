//
//  ContentCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Joshua Figueroa on 8/14/23.
//

import UIKit
import SDWebImage

class ContentCollectionViewCell: UICollectionViewCell {
    static let identifier = "ContentCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    public func configure(with model: String?) {
        var tempUrl = ""
        
        if(model == nil) {
            tempUrl = "https://critics.io/img/movies/poster-placeholder.png"
        } else {
            tempUrl = model!
        }
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(tempUrl)") else {return}
        posterImageView.sd_setImage(with: url, completed: nil)
    }
}
