//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Joshua Figueroa on 8/12/23.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    var upcomingMovies: [MediaContent] = []
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(UpcomingMediaTableViewCell.self, forCellReuseIdentifier: UpcomingMediaTableViewCell.identifier)
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        getUpcomingMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func getUpcomingMovies() {
        APICaller.shared.getUpcomingMovies() { [weak self] result in
            switch result {
                case .success(let movies) :
                self?.upcomingMovies = movies
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
                case .failure(let error):
                    print("Error:\(error.localizedDescription)")
            }
            
        }
    }

}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingMediaTableViewCell.identifier, for: indexPath) as? UpcomingMediaTableViewCell
        else {
            print("nice")
            return UITableViewCell()
        }
        
        let movie: MediaContent = upcomingMovies[indexPath.row]
        cell.configure(with: MediaContentViewModel(poster: movie.poster_path!, title: movie.title!))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let media = upcomingMovies[indexPath.row]
        
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
