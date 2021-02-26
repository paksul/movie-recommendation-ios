//
//  Movies.swift
//  MovieRecommendation
//
//  Created by Jelena Bajović on 18.11.20.
//

import Foundation
import CoreML

class Movies : ObservableObject {
    var ratings : [Movie: Int] = [:]
    var movies = [Movie]()
    @Published var currentMovie : Movie?

    
    struct Movie: Identifiable, Hashable {
        var id: Int
        var name: String
        var year: String
        var genre: String
    }
    
    func addMovies(_ movies: [Movie]) {
        self.movies = movies
    }
    
    func rateCurrentMovie(rating: Int) {
        if let movieToBeRated = currentMovie {
            ratings[movieToBeRated] = rating
            currentMovie = movies.randomElement()
        }
    }
    
    func getMovieName(movieId: Int) -> String {
        if let movie = movies.first(where: { $0.id == movieId }) {
            return movie.name
        }
        return ""
    }
    
    func getRatingsDescription() -> String {
        var description = ""
        for (movie, rating) in ratings {
            description += movie.name + " - " + rating.description + "\n"
        }
        
        return description
    }
    
    func getRecommendation() -> [Int64]? {
        let recommendationModel = try? MovieRecommenderModel(configuration: MLModelConfiguration())
        let recommendationInput = MovieRecommenderModelInput(items: createRecommendationInputFrom(ratings), k: 10)
        
        let output = try? recommendationModel?.prediction(input: recommendationInput)
        
        print(output?.recommendations ?? [])
        
        return output?.recommendations;
    }
    
    func createRecommendationInputFrom(_ ratings: [Movie: Int]) -> [Int64: Double] {
        var input: [Int64: Double] = [:]
        
        ratings.forEach { (movie, rating) in
            input[Int64(movie.id)] = Double(rating)
        }
        
        return input
    }
}

