//
//  YourlistCollectionViewCell.swift
//  filmnia
//
//  Created by UserTQI on 25/05/20.
//  Copyright © 2020 lucrodrigs. All rights reserved.
//

import UIKit

class YourlistCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var progressLoad: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cornerRadiusPoster()
        self.contentView.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        posterImage.image = nil
    }
    
    func urlShowImage(path: String) {
            if let url = URL(string: path) {
                posterImage.downloadImage(from: url, completion: {
                    [weak self] in
                    self?.progressLoad.stopAnimating()
                })
            }
        }
    
        func imageURl(from url: String) -> String {
            return Constants.urlBaseImage + "original" + url
        }
    
        func cellPosterPath(dataMovie: Item) {
            let imageUrl = imageURl(from: dataMovie.posterPath ?? "")
            urlShowImage(path: imageUrl)
        }
    
        func cornerRadiusPoster() {
            posterImage.layer.cornerRadius = posterImage.frame.size.width/12.5
        }

}
