//
//  ContentView.swift
//  MovieRecommendation
//
//  Created by Jelena Bajović on 18.11.20.
//

import SwiftUI

struct MovieRecommendationView: View {
    //@ObservedObject var viewModel: Movies
    @ObservedObject var recommendationViewModel: RecommendationViewModel
    @State private var recommendedMovies: [Movie]?
    @State private var currentImage: UIImage?
    
    var body: some View {
        VStack {
            Image(uiImage: currentImage ?? UIImage())
            
            let movieName = recommendationViewModel.currentMovie?.name
            Text(movieName ?? "")
                .onAppear(perform: getMovieData)
                .onChange(of: movieName) { _ in
                    getMovieData()
                }
            HStack {
                Text("☆").onTapGesture{
                    recommendationViewModel.rateCurrentMovie(rating: 1)
                }
                Text("☆").onTapGesture{
                    recommendationViewModel.rateCurrentMovie(rating: 2)
                }
                Text("☆").onTapGesture{
                    recommendationViewModel.rateCurrentMovie(rating: 3)
                }
                Text("☆").onTapGesture{
                    recommendationViewModel.rateCurrentMovie(rating: 4)
                }
                Text("☆").onTapGesture{
                    recommendationViewModel.rateCurrentMovie(rating: 5)
                }
            }
            .padding()
            
            Button(action: {
                recommendationViewModel.nextMovie()
            }, label: {
                Text("Haven't watch this movie")
            })
            .padding()
            
            Button(action: {
                recommendedMovies = recommendationViewModel.recommendMovies()
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
        }
    }
    
    func getRecommendedMovieName() -> String {
        if let firstMovieId = recommendedMovies?.first {
            return firstMovieId.name
        }
        return ""
    }
    
    func getMovieData() {
        let session = URLSession.shared
        let movieName = recommendationViewModel.currentMovie?.name
        let urlEncodedName = movieName?.replacingOccurrences(of: " ", with: "%20") ?? ""
        
        print(urlEncodedName)
        let url = URL(string: "https://www.omdbapi.com/?apikey=60fdfa58&t=\(urlEncodedName)")!
        
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
    
    func regexTest() {
        let regexPattern = "\\(([0-9]){4}\\)"
        var testString = "Grand Budapepest Hotel (2014)"

        let range = testString.range(of: regexPattern, options: .regularExpression)

        print(testString[range!])
        
        testString.removeSubrange(range!)
        
        print(testString)
    }
    
}













struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MovieRecommendationView(recommendationViewModel: RecommendationViewModel())
    }
}
