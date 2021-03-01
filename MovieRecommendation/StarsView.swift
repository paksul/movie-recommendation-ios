//
//  RateView.swift
//  MovieRecommendation
//
//  Created by Jelena Bajović on 18.02.21.
//

import SwiftUI

struct StarsView: View {
    @State var rating: CGFloat
    var maxRating: Int
    
    
    var body: some View {
        
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







struct RateView_Previews: PreviewProvider {
    static var previews: some View {
        StarsView(rating: 2.5, maxRating: 5)
    }
}
