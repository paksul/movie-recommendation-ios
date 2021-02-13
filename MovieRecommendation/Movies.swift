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
    init() {
        movies.append(Movie(id: 1, name: "The Grand Budapest Hotel", year: "(2014)", genre: "Adventure, Comedy, Crime"))
        movies.append(Movie(id: 2, name: "Moonrise Kingdom", year: "(2012)", genre: "Comedy, Drama, Romance"))
        movies.append(Movie(id: 3, name: "Isle Of Dogs", year: "(2018)", genre: "Animation, Adventure, Comedy"))
        movies.append(Movie(id: 4, name: "The Darjeeling Limited", year: "(2007)", genre: "Adventure, Comedy, Drama"))
        movies.append(Movie(id: 5, name: "The Royal Tenenbaums", year: "(2001)", genre: "Comedy, Drama"))
        movies.append(Movie(id: 6, name: "The Life Aquatic with Steve Zissou", year: "(2004)", genre: "Action, Adventure, Comedy"))
        movies.append(Movie(id: 7, name: "Rushmore", year: "(1998)", genre: "Comedy, Drama, Romance"))
        movies.append(Movie(id: 8, name: "Fantastic Mr. Fox", year: "(2009)", genre: "Animation, Adventure, Comedy"))
        movies.append(Movie(id: 9, name: "Bottle Rocket", year: "(1996)", genre: "Comedy, Crime, Drama"))
        movies.append(Movie(id: 10, name: "The French Dispatch", year: "(2021)", genre: "Comedy, Drama, Romance"))
        
        currentMovie = movies.randomElement()
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

