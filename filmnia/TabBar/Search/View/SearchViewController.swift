//
//  HomeViewController.swift
//  filmnia
//
//  Created by Lucas Rodrigues Dias on 18/02/20.
//  Copyright © 2020 lucrodrigs. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel = SearchViewModel()
    var delegate: DetailsSelectDelegate?
    var resultsRequest: ResultsMovies?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        setupSearchCollectionCell()
        hideKeyboardWhenTappedAround()
        viewModelReload()
        viewModel.resultInitializerPopularMovies()
        viewModel.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundOriginal.jpeg")!)
        self.collectionView.backgroundColor = .clear
    }
    
        func setupSearchCollectionCell() {
        collectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchCollectionViewCell")
    }
    
    func viewModelReload() {
        collectionView.reloadData()
        collectionView.backgroundView = nil
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchQuery = searchBar.text ?? ""
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.searchTextField.textColor = .white
        if searchText.isEmpty {
            viewModel.searchQuery = searchText
            resultsRequest?.results.removeAll()
            collectionView.reloadData()
        } else {
            viewModel.resultSearch(query: searchText)
        }
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 123, height: 187)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultsRequest?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell
        
        if let result = resultsRequest {
            cell?.cellPosterPath(dataMovie: result.results[indexPath.row])
        }
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movies = resultsRequest?.results[indexPath.row] else { return }
        delegate?.movieSelected(movie: movies, flux: .search)
    }
    
}

extension SearchViewController: SearchViewDelegate {
    
    func showImagePosters(resultPoster: ResultsMovies) {
        resultsRequest = resultPoster
        collectionView.reloadData()
    }
    
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
