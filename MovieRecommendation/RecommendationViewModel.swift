//
//  RecommendationViewModel.swift
//  MovieRecommendation
//
//  Created by Jelena Bajović on 27.02.21.
//

import Foundation

class RecommendationViewModel: ObservableObject {
    var recommendationModel: RecommendationModel
    @Published var currentMovie: Movie?
    
    init() {
        self.recommendationModel = RecommendationModel(ratings: [:], movies: MovieDataLoader().loadMovies())
        
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
        recommendationModel.recommendMovies(numberOfItems: 10)
    }
    
}
