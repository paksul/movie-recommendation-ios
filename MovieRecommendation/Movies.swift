//
//  Movies.swift
//  MovieRecommendation
//
//  Created by Jelena Bajović on 18.11.20.
//

import Foundation
import CoreML

class Movies : ObservableObject{
    var ratings : [Movie: Int] = [:]
    var movies = [Movie]()
    @Published var currentMovie : Movie?
    
    struct Movie: Identifiable, Hashable {
        var id: Int
        var name: String
        var year: String
        var genre: String
        
        init(id: Int, name: String, year: String, genre: String) {
         self.id = id
         self.name = name
         self.year = year
         self.genre = genre
         }
    }
    
    func rateCurrentMovie(rating: Int) {
        if let movieToBeRated = currentMovie {
            ratings[movieToBeRated] = rating
            currentMovie = movies.randomElement()
            
            
        }
    }
    
    func getRatingsDescription() -> String {
        var description = ""
        for (movie, rating) in ratings {
            description += movie.name + " - " + rating.description + "\n"
        }
        
        
        return description
    }
    
    func getRecommendation() throws -> MovieRecommenderModelOutput {
        let model = try MovieRecommenderModel(configuration: MLModelConfiguration())
        let input = MovieRecommenderModelInput(items: [109374 : 5, 94959 : 5, 103042 : 1, 102903 : 3], k: 5)
        let recommendation = try model.prediction(input: input)
        
        print(recommendation.recommendations)
        
        return recommendation
    }
}

