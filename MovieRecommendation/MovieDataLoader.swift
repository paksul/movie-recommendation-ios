//
//  MovieDataLoader.swift
//  MovieRecommendation
//
//  Created by Jelena Bajović on 27.02.21.
//

import Foundation

struct MovieDataLoader {
    
    func loadMovies() -> [Movie] {
        if let movieData = loadFile(from: "movies", withExtension: ".csv"),
           let linksData = loadFile(from: "links", withExtension: ".csv"){
            let movies = movieData.components(separatedBy: "\n")
            let links = linksData.components(separatedBy: "\n")
            
            return createMovies(from: movies, withLinks: links)
        }
        return [Movie]()
    }
    
    private func loadFile(from filePath: String, withExtension fileExtension: String) -> String? {
        if let fileUrl = Bundle.main.url(forResource: filePath, withExtension: fileExtension) {
            return try? String(contentsOf: fileUrl)
        }
        return nil
    }
    
    private func createMovies(from movies: [String], withLinks links: [String]) -> [Movie] {
        var movieList: [Movie] = []
        
        for (index, movieString) in movies.enumerated() {
            let movieAttributes = movieString.components(separatedBy: ",")
            let linkAttributes = links[index].components(separatedBy: ",")
             
            if let movieId = Int(movieAttributes[0]) {
                let year = extractYear(from: movieAttributes[1])
                let name = extractNameWithoutYear(movieName: movieAttributes[1])
                                                
                let movie = Movie(id: movieId,
                                  imdbId: linkAttributes[1],
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
