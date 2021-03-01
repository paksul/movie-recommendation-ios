//
//  RateView.swift
//  MovieRecommendation
//
//  Created by Jelena Bajović on 28.02.21.
//

import SwiftUI

struct RatingView: View {
    @ObservedObject var recommendationViewModel: RecommendationViewModel
    @State var rating: CGFloat
    var maxRating: Int
    
    var body: some View {
        VStack {
            Image(uiImage: recommendationViewModel.backgroundImage ?? UIImage())
            Text(recommendationViewModel.currentMovie?.name ?? "")
            Button(action: {
                recommendationViewModel.nextMovie()
            }, label: {
                Text("Haven't watch this movie")
            })
            .padding()
        }
        
        let stars = HStack(spacing: 0) {
            ForEach(0..<maxRating) { index in
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(7)
                    .onTapGesture {
                        rating = CGFloat(index + 1)
                    }
            }
        }
        
        stars.overlay(
            GeometryReader { g in
                let width = rating / CGFloat(maxRating) * g.size.width
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .foregroundColor(Color(.sRGB, red: 150/225, green: 121/225, blue: 175/225))
                }
            }
            .mask(stars)
        )
        .foregroundColor(.gray)
        .padding()
    }
}
   













struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(recommendationViewModel: RecommendationViewModel(), rating: 2.5, maxRating: 5)
    }
}
