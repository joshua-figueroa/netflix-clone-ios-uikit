//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Joshua Figueroa on 8/12/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    var discoveredMovies: [MediaContent] = []
    
    private let discoveredTable: UITableView = {
        let table = UITableView()
        table.register(UpcomingMediaTableViewCell.self, forCellReuseIdentifier: UpcomingMediaTableViewCell.identifier)
        
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a Movie or TV show"
        controller.searchBar.searchBarStyle = .minimal
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(discoveredTable)
        discoveredTable.delegate = self
        discoveredTable.dataSource = self
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .label
        
        getDiscoveredMovies()
        
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoveredTable.frame = view.bounds
    }
    
    private func getDiscoveredMovies() {
        APICaller.shared.getDiscoveredMovies() { [weak self] result in
            switch result {
                case .success(let movies) :
                self?.discoveredMovies = movies
                DispatchQueue.main.async {
                    self?.discoveredTable.reloadData()
                }
                case .failure(let error):
                    print("Error:\(error.localizedDescription)")
            }
            
        }
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoveredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingMediaTableViewCell.identifier, for: indexPath) as? UpcomingMediaTableViewCell
        else {
            return UITableViewCell()
        }
        
        let movie: MediaContent = discoveredMovies[indexPath.row]
        cell.configure(with: MediaContentViewModel(poster: movie.poster_path!, title: movie.title!))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let media = discoveredMovies[indexPath.row]
        
        guard let titleName = media.original_title ?? media.original_name else { return }
        
        APICaller.shared.getTrailer(with: "\(titleName) trailer") { [weak self] result in
            switch result {
            case .success(let trailer) :
                DispatchQueue.main.async { [weak self] in
                    let preview = ContentPreviewViewController()
                    preview.configure(with: MediaPreviewViewModel(title: titleName, overview: media.overview, youtubeVideo: trailer))
                    
                    self?.navigationController?.pushViewController(preview, animated: true)
                    self?.navigationController?.navigationBar.tintColor = .label
                }
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
            }
        }
    }
    
}

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidTapItem(_ viewModel: MediaPreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let preview = ContentPreviewViewController()
            preview.configure(with: viewModel)
            
            self?.navigationController?.pushViewController(preview, animated: true)
            self?.navigationController?.navigationBar.tintColor = .label
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty, query.trimmingCharacters(in: .whitespaces).count >= 3, let resultsController = searchController.searchResultsController as? SearchResultsViewController else {return}
        
        resultsController.delegate = self
        
        APICaller.shared.searchContent(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let movies) :
                    resultsController.mediaContent = movies
                    resultsController.searchResultCollectionView.reloadData()
                    case .failure(let error):
                        print("Error:\(error.localizedDescription)")
                }
            }
        }
    }
}
