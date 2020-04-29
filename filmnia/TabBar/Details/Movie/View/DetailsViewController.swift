//
//  DetailsViewController.swift
//  filmnia
//
//  Created by UserTQI on 06/03/20.
//  Copyright © 2020 lucrodrigs. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var posterMovie: UIImageView?
    @IBOutlet weak var titleMovie: UILabel?
    @IBOutlet weak var recommendationMovie: UILabel?
    @IBOutlet weak var runTime: UILabel?
    @IBOutlet weak var releaseAge: UILabel?
    @IBOutlet weak var overviewLabel: UILabel?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rateAverage: UIView!
    @IBOutlet weak var rateLabel: UILabel?
    
    var delegate: DetailsMovieDelegate?
    var resultsRequest: ResultsMovies?
    var viewModel: DetailsViewModel!
    
    init(viewModel: DetailsViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecomendationCollectionView()
        viewModel.recomendationMovies()
        viewModel.detailsMovie()
        viewModel.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupRecomendationCollectionView() {
        collectionView.register(UINib(nibName: "RecomendationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecomendationCollectionViewCell")
    }
    
    func detailsImage() {
        let urlString = Constants.urlBaseImage + "original" + (viewModel.movies.posterPath ?? "")
        if let url = URL(string: urlString) {
            posterMovie?.downloadImage(from: url)
            posterMovie?.layer.cornerRadius = ((posterMovie?.frame.size.width)!/12)
        }
    }
    
    func voteAverage() {
        let voteAverage = viewModel.movies.voteAverage
        let voteString = String(voteAverage)
        let shapeColor: CGColor
        let transparentColor: CGColor
        
        if voteAverage < 4.0 {
            shapeColor = UIColor.red.cgColor
            transparentColor = UIColor.systemRed.cgColor
            rateLabel?.text = voteString.replacingOccurrences(of: ".", with: "") + "%"
        } else if voteAverage < 7.0 {
            shapeColor = UIColor.yellow.cgColor
            transparentColor = UIColor.systemYellow.cgColor
            rateLabel?.text = voteString.replacingOccurrences(of: ".", with: "") + "%"
        } else {
            shapeColor = UIColor.green.cgColor
            transparentColor = UIColor.systemGreen.cgColor
            rateLabel?.text = voteString.replacingOccurrences(of: ".", with: "") + "%"
        }

        let rateFinal = CGFloat(voteAverage / 10) * 0.8
        createRateAverage(rate: rateFinal, transparentColor: transparentColor, shapeColor: shapeColor)
    }
    
    func createRateAverage(rate: CGFloat, transparentColor: CGColor, shapeColor: CGColor){
        let shapeLayer = CAShapeLayer()
        let trackLayer = CAShapeLayer()
        let transparentLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: rateAverage.frame.size.width/2, y: rateAverage.frame.size.height/2), radius: 30, startAngle: -.pi / 2, endAngle: 2 * .pi, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 15
        trackLayer.fillColor = UIColor.lightGray.cgColor
        trackLayer.strokeEnd = 0.8
        rateAverage.layer.addSublayer(trackLayer)
        
        transparentLayer.path = circularPath.cgPath
        transparentLayer.strokeColor = transparentColor
        transparentLayer.lineWidth = 5
        transparentLayer.fillColor = UIColor.clear.cgColor
        transparentLayer.strokeEnd = 0.8
        rateAverage.layer.addSublayer(transparentLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = shapeColor
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        rateAverage.layer.addSublayer(shapeLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 2
        animation.fromValue = 0
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.strokeEnd = rate
        shapeLayer.add(animation, forKey: "animateProgress")
    }
    
    func timeMovie() {
        if let releaseTime = viewModel.details?.runtime {
            runTime?.text = String(releaseTime / 60) + " hours " + String(releaseTime % 60) + " minutes"
        }
    }
    
    func releaseMovie() {
        let releaseData = viewModel.details?.releaseDate
        releaseAge?.text = String(releaseData ?? "N/A")
    }
    
    func overviewMovie() {
        let overview = viewModel.movies.overview
        overviewLabel?.text = overview
    }
    
    func titleMovies() {
        let title = viewModel.details?.originalTitle
        titleMovie?.text = title
    }
    
    func recommendationTitle() {
        let titleRecommendation = viewModel.details?.originalTitle
        recommendationMovie?.text = String("Recommendation for " + (titleRecommendation ?? "untitle"))
    }
    
}

extension DetailsViewController: DetailsMovieDelegate {
    
    func showImagePosters(resultMovies: ResultsMovies) {
        resultsRequest = resultMovies
        collectionView.reloadData()
    }
    
    func detailsMovie() {
        detailsImage()
        timeMovie()
        releaseMovie()
        overviewMovie()
        voteAverage()
        titleMovies()
        recommendationTitle()
    }
    
}

extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 168*3/4, height: 187)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultsRequest?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecomendationCollectionViewCell", for: indexPath) as? RecomendationCollectionViewCell
        if let result = resultsRequest {
            cell?.cellPosterPathMovie(dataMovie: result.results[indexPath.row])
        }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movies = resultsRequest?.results[indexPath.row] else { return }
        viewModel.movies = movies
        viewModel.detailsMovie()
        viewModel.recomendationMovies()
        collectionView.reloadData()
    }
    
}

