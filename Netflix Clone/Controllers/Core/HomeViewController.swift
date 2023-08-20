//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Joshua Figueroa on 8/12/23.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTVSeries = 1
    case Popular = 2
    case UpcomingMovies = 3
    case TopRatedMovies = 4
}

class HomeViewController: UIViewController {
    
    private var randomMoview: MediaContent?
    private var headerView: HeroHeaderUIView?
    
    let sectionTitles: [String] = ["Trending Movies", "Trending TV Series", "Popular", "Upcoming Movies", "Top Rated"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        return table
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavbar()
    
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeFeedTable.tableHeaderView = headerView
    }
    
    private func configureNavbar() {
        
        let logoImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(named: "netflixLogo")
            return imageView
        }()

        // Add the logo image view to the navigation bar
        navigationController?.navigationBar.addSubview(logoImageView)
        navigationController?.navigationBar.tintColor = .label
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]

        // Set Auto Layout constraints to position the logo on the left side of the navigation bar
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: navigationController!.navigationBar.leadingAnchor, constant: 16),
            logoImageView.centerYAnchor.constraint(equalTo: navigationController!.navigationBar.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 30),
            logoImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.x, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .label
        header.textLabel?.text = self.tableView(tableView, titleForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
            case Sections.TrendingMovies.rawValue:
                APICaller.shared.getTrendingMovies() { result in
                    switch result {
                    case .success(let movies) :
                        cell.configure(with: movies)
                        
                        let element = movies.randomElement()
                        self.headerView?.configure(with: MediaContentViewModel(poster: element?.poster_path ?? "", title: element?.original_title ?? element?.original_name ?? ""))
                    case .failure(let error):
                        print("Error:\(error.localizedDescription)")
                    }
                    
                }
            case Sections.TrendingTVSeries.rawValue:
                APICaller.shared.getTrendingTVSeries() { result in
                    switch result {
                    case .success(let series) :
                        cell.configure(with: series)
                    case .failure(let error):
                        print("Error:\(error.localizedDescription)")
                    }
                    
                }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopularMovies() { result in
                switch result {
                case .success(let movies) :
                    cell.configure(with: movies)
                case .failure(let error):
                    print("Error:\(error.localizedDescription)")
                }
                
            }
        case Sections.UpcomingMovies.rawValue:
            APICaller.shared.getUpcomingMovies() { result in
                switch result {
                case .success(let movies) :
                    cell.configure(with: movies)
                case .failure(let error):
                    print("Error:\(error.localizedDescription)")
                }
                
            }
            
        case Sections.TopRatedMovies.rawValue:
            APICaller.shared.getTopRatedMovies() { result in
                switch result {
                case .success(let movies) :
                    cell.configure(with: movies)
                case .failure(let error):
                    print("Error:\(error.localizedDescription)")
                }
                
            }

        default:
            print(indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController: CollectionTableViewCellDelegate {
    func collectionTableViewCellDidTapCell(_ cell: CollectionTableViewCell, viewModel: MediaPreviewViewModel) {
        DispatchQueue.main.async { [weak self] in 
            let preview = ContentPreviewViewController()
            preview.configure(with: viewModel)
            
            self?.navigationController?.pushViewController(preview, animated: true)
        }
    }
}
