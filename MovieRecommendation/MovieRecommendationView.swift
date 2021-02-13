//
//  ContentView.swift
//  MovieRecommendation
//
//  Created by Jelena Bajović on 18.11.20.
//

import SwiftUI

struct MovieRecommendationView: View {
    @ObservedObject var viewModel: Movies
    
    
    var body: some View {
        VStack {
            let movieName = viewModel.currentMovie?.name
            Text(movieName!)
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
            let recommendations = try? viewModel.getRecommendation()
            Text("" + recommendations!.recommendations.description)
            
        }
        
    }
}














struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MovieRecommendationView(viewModel: Movies())
    }
}
