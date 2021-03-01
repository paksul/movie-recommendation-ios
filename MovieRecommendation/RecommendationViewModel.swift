//
//  RecommendationViewModel.swift
//  MovieRecommendation
//
//  Created by Jelena Bajović on 27.02.21.
//

import SwiftUI
import Combine

class RecommendationViewModel: ObservableObject {
    var recommendationModel: RecommendationModel
    
    @Published private(set) var currentMovie: Movie? {
        didSet {
            if currentMovie?.imdbId != nil {
                getMovieData()
            }
        }
    }
    
    @Published private(set) var backgroundImage: UIImage?
    
    init() {
        recommendationModel = RecommendationModel(ratings: [:], movies: MovieDataLoader().loadMovies())
        
        currentMovie = recommendationModel.movies.randomElement()
    }
    
    func nextMovie() {
        currentMovie = recommendationModel.movies.randomElement()
        
    }
    
    func rateCurrentMovie(rating: Int) {
        if let movieToRate = currentMovie {
            recommendationModel.rate(movie: movieToRate, rating: Double(rating))
            currentMovie = recommendationModel.movies.randomElement()
        }
    }
    
    func recommendMovies() -> [Movie] {
        let movies = recommendationModel.recommendMovies(numberOfItems: 10)
        print(movies)
        return movies
    }
    
    func getMovieData() {
        let session = URLSession.shared
        let imdbId = currentMovie?.imdbId
        
        print(imdbId)
        let url = URL(string: "https://www.omdbapi.com/?apikey=60fdfa58&i=tt\(imdbId!)")!
        print(url.description)
        
        let task = session.dataTask(with: url) {data, response, error in
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                if let movieData = json as? [String: Any],
                   let posterLink = movieData["Poster"] as? String {
                    let posterUrl = URL(string: posterLink)
                    self.getMoviePoster(with: posterUrl!)
                }
                print(json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func getMoviePoster(with url: URL) {
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) {data, response, error in
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            self.backgroundImage = UIImage(data: data!)
            
        }
        
        task.resume()
    }
    
    private var fetchMovieCancellable: AnyCancellable?
    
    private func fetchMovieData() {
        let urlPrefix = "https://www.omdbapi.com/?apikey=60fdfa58&i=tt"
        
        backgroundImage = nil
        if let imdbId = currentMovie?.imdbId, let url = URL(string: urlPrefix + imdbId) {
            fetchMovieCancellable?.cancel()
            fetchMovieCancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map { data, urlResponse in UIImage(data: data) }
                .receive(on: DispatchQueue.main)
                .replaceError(with: nil)
                .assign(to: \.backgroundImage, on: self)
        }
    }
    
    private var fetchPosterCancellable: AnyCancellable?
    
    private func fetchMoviePosterData(url: URL) {
        fetchPosterCancellable?.cancel()
        fetchPosterCancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { data, urlResponse in UIImage(data: data) }
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .assign(to: \.backgroundImage, on: self)
    }
}
