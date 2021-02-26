//
//  ContentView.swift
//  MovieRecommendation
//
//  Created by Jelena Bajović on 18.11.20.
//

import SwiftUI

struct MovieRecommendationView: View {
    @ObservedObject var viewModel: Movies
    @State private var recommendedMovies: [Int64]?
    @State private var currentImage: UIImage?
    
    var body: some View {
        VStack {
            Image(uiImage: currentImage ?? UIImage())
            
            let movieName = viewModel.currentMovie?.name
            Text(movieName ?? "")
            HStack {
                Text("☆").onTapGesture{
                    viewModel.rateCurrentMovie(rating: 1)
                    
                }
                Text("☆").onTapGesture{
                    viewModel.rateCurrentMovie(rating: 2)
                }
                Text("☆").onTapGesture{
                    viewModel.rateCurrentMovie(rating: 3)
                }
                Text("☆").onTapGesture{
                    viewModel.rateCurrentMovie(rating: 4)
                }
                Text("☆").onTapGesture{
                    viewModel.rateCurrentMovie(rating: 5)
                }
            }
            .padding()
            
            Button(action: {
                viewModel.currentMovie = viewModel.movies.randomElement()
            }, label: {
                Text("Haven't watch this movie")
            })
            .padding()
            
            Button(action: {
                recommendedMovies = viewModel.getRecommendation()
            }, label: {
                Text("Recommend")
            })
            .padding()
            
            Text(getRecommendedMovieName())
            
            Button(action: {
                getMovieData()
            }, label: {
                Text("Movie data")
            })
            .padding()
        }.onAppear(perform: {
            loadMovieData()
        })
    }
    
    func getRecommendedMovieName() -> String {
        if let firstMovieId = recommendedMovies?.first {
            return viewModel.getMovieName(movieId: Int(firstMovieId))
        }
        return ""
    }
    
    func loadMovieData() {
        if let moviesURL = Bundle.main.url(forResource: "movies", withExtension: ".csv") {
            if let moviesString = try?
                String(contentsOf: moviesURL) {
                let movies = moviesString.components(separatedBy: "\n")
                
                let movieList = createMovieList(movies: movies)
                
                viewModel.addMovies(movieList)
            }
        }
    }
    
    func createMovieList(movies: [String]) -> [Movies.Movie] {
        var movieList: [Movies.Movie] = []
        
        for movieString in movies {
            let movieAttributes = movieString.components(separatedBy: ",")
            if let movieId = Int(movieAttributes[0]) {
                let movie = Movies.Movie(id: movieId,
                                         name: movieAttributes[1],
                                         year: "",
                                         genre: movieAttributes[2])
                
                movieList.append(movie)
            }
        }
        return movieList
    }
    
    func getMovieData() {
        let session = URLSession.shared
        //let title = viewModel.currentMovie?.name
        let url = URL(string: "https://www.omdbapi.com/?apikey=60fdfa58&s=Titanic")!
        
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
                    getMoviePoster(with: posterUrl!)
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
            
            currentImage = UIImage(data: data!)
            
        }
        
        task.resume()
    }
    
}













struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MovieRecommendationView(viewModel: Movies())
    }
}
