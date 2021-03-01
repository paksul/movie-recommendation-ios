//
//  RateView.swift
//  MovieRecommendation
//
//  Created by Jelena Bajović on 28.02.21.
//

import SwiftUI

struct RatingView: View {
    @ObservedObject var recommendationViewModel: RecommendationViewModel
    @State var rating: Int?
    var maxRating: Int
    
    var body: some View {
        VStack {
            Text(recommendationViewModel.currentMovie?.name ?? "").font(.title2)
            Image(uiImage: recommendationViewModel.backgroundImage ?? UIImage())
                .resizable()
                .onChange(of: recommendationViewModel.backgroundImage) { newImage in
                    self.rating = 0
                }
            StarsView(recommendationViewModel: recommendationViewModel, rating: $rating, max: 5)
            Button(action: {
                recommendationViewModel.nextMovie()
                self.rating = 0
            }, label: {
                Text("Didn't watch this movie")
                    .font(.title2)
            })
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(Color(.sRGB, red: 150/225, green: 121/225, blue: 175/225))
            .cornerRadius(30)
            .aspectRatio(contentMode: .fit)
        }
        .scaledToFit()
        .padding()
        
    }
}














struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(recommendationViewModel: RecommendationViewModel(), rating: 0, maxRating: 5)
    }
}

