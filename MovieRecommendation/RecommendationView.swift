//
//  RecommendationView.swift
//  MovieRecommendation
//
//  Created by Jelena Bajović on 01.03.21.
//

import SwiftUI

struct RecommendationView: View {
    @ObservedObject var recommendationViewModel: RecommendationViewModel
    @State var recommendedMovies: [Movie]
    
    var body: some View {
        VStack{
            Image(uiImage: recommendationViewModel.backgroundImage ?? UIImage())
                .resizable()
            Text(recommendedMovies.first?.name ?? "").font(.title2)
            Button(action: {
                recommendedMovies.remove(at: 0)
                recommendationViewModel.currentMovie = recommendedMovies.first
            }, label: {
                Text("Next")
                    .font(.title2)
            })
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(Color(.sRGB, red: 150/225, green: 121/225, blue: 175/225))
            .cornerRadius(30)
            .aspectRatio(contentMode: .fit)
        }
        .padding()
        .scaledToFit()
        .onAppear {
            recommendedMovies = recommendationViewModel.recommendMovies()
            recommendationViewModel.currentMovie = recommendedMovies.first
        }
    }
}

struct RecommendationView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationView(recommendationViewModel: RecommendationViewModel(), recommendedMovies: [Movie]())
    }
}
