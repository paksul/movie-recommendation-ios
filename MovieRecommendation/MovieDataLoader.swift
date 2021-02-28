//
//  MovieDataLoader.swift
//  MovieRecommendation
//
//  Created by Jelena Bajović on 27.02.21.
//

import Foundation

struct MovieDataLoader {
    
    func loadMovies() -> [Movie] {
        if let moviesURL = Bundle.main.url(forResource: "movies", withExtension: ".csv") {
            if let moviesString = try?
                String(contentsOf: moviesURL) {
                
                let movies = moviesString.components(separatedBy: "\n")
                
                return createMovies(from: movies)
            }
        }
        return [Movie]()
    }
    
    private func createMovies(from movies: [String]) -> [Movie] {
        var movieList: [Movie] = []
        
        for movieString in movies {
            let movieAttributes = movieString.components(separatedBy: ",")
            
            if let movieId = Int(movieAttributes[0]) {
                let year = extractYear(from: movieAttributes[1])
                let name = extractNameWithoutYear(movieName: movieAttributes[1])
                
                let movie = Movie(id: movieId,
                                  name: name,
                                  year: year,
                                  genres: [movieAttributes[2]])
                
                movieList.append(movie)
            }
        }
        return movieList
    }
    
    private func extractNameWithoutYear(movieName: String) -> String {
        let regexPattern = "\\s\\(([0-9]){4}\\)"
        
        return movieName.replacingOccurrences(of: regexPattern, with: "", options: .regularExpression)
    }
    
    private func extractYear(from movieName: String) -> Int {
        let regexPattern = "([0-9]){4}"
        
        if let yearSubstringRange = movieName.range(of: regexPattern, options: .regularExpression) {
            return Int(movieName[yearSubstringRange]) ?? 0
        }
        return 0
    }
    
    
    
}
