//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Joshua Figueroa on 8/14/23.
//

import Foundation

struct Constants {
    static let API_KEY = ProcessInfo.processInfo.environment["TMDB_APIKEY"]
    static let BASE_URL = "https://api.themoviedb.org"
    static let IMG_BASE_URL = "https://image.tmdb.org/t/p/w500/"
    static let YOUTUBE_API_KEY = ProcessInfo.processInfo.environment["YOUTUBE_APIKEY"]
    static let YOUTUBE_BASE_URL = "https://www.googleapis.com/youtube/v3/search"
}

enum APIError: Error {
    
}

class APICaller {
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[MediaContent], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3/trending/movie/day?api_key=\(Constants.API_KEY!)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){ data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let response = try JSONDecoder().decode(MediaContentResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getTrendingTVSeries(completion: @escaping (Result<[MediaContent], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3/trending/tv/day?api_key=\(Constants.API_KEY!)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){ data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let response = try JSONDecoder().decode(MediaContentResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[MediaContent], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/upcoming?api_key=\(Constants.API_KEY!)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){ data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let response = try JSONDecoder().decode(MediaContentResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping (Result<[MediaContent], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/popular?api_key=\(Constants.API_KEY!)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){ data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let response = try JSONDecoder().decode(MediaContentResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[MediaContent], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/top_rated?api_key=\(Constants.API_KEY!)&language=en-US&page=1") else {return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){ data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let response = try JSONDecoder().decode(MediaContentResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getDiscoveredMovies(completion: @escaping (Result<[MediaContent], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3/discover/movie?api_key=\(Constants.API_KEY!)&language=en-US&sort_by=popularity.desc&include_adult=true&include_video=false&with_watch_monetization_types=flatrate") else {return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(MediaContentResponse.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(error))
            }

        }
        task.resume()
    }
    
    func searchContent(with query: String, completion: @escaping (Result<[MediaContent], Error>)-> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.BASE_URL)/3/search/movie?query=\(query)&api_key=\(Constants.API_KEY!)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(MediaContentResponse.self, from: data)
                completion(.success(results.results))

            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }

        }
        task.resume()
    }
    
    func getTrailer(with query: String, completion: @escaping (Result<VideoItem, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.YOUTUBE_BASE_URL)?q=\(query)&key=\(Constants.YOUTUBE_API_KEY!)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(YoutubeResponse.self, from: data)
                completion(.success(results.items[0]))
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }

        }
        task.resume()
    }
    
}
