//
//  RecommendationModel.swift
//  MovieRecommendation
//
//  Created by Jelena Bajović on 27.02.21.
//

import Foundation
import CoreML

struct RecommendationModel {
    var ratings: [Int64: Double]
    var movies: [Movie]
    var recommenderEngine: MovieRecommenderModel
    
    init(ratings: [Int64: Double], movies: [Movie]) {
        self.ratings = ratings
        self.movies = movies
        self.recommenderEngine = try! MovieRecommenderModel(configuration: MLModelConfiguration())
    }
    
    mutating func rate(movie: Movie, rating: Double) {
        ratings[Int64(movie.id)] = rating
    }
    
    func ratingFor(movie: Movie) -> Double? {
        ratings[Int64(movie.id)]
    }
    
    func recommendMovies(numberOfItems: Int) -> [Movie] {
        let recommenderInput = MovieRecommenderModelInput(items: ratings, k: Int64(numberOfItems))
        
        let output = try? recommenderEngine.prediction(input: recommenderInput)
        
        return output?.recommendations.map { movieId in
            movies.first { $0.id == movieId }
        } as! [Movie]
    }
    
}

struct Movie: Identifiable, Hashable, Codable {
    var id: Int
    var imdbId: String
    var name: String
    var year: Int
    var genres: [String]
}
