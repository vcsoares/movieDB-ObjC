//
//  MovieDetailView.swift
//  moviedb-swift
//
//  Created by Vinícius Chagas on 24/03/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

import SwiftUI

struct MovieDetailView: View {
    @State var movie : Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .bottom, spacing: 14) {
                PosterView(movie: movie)
                    .frame(width: 128, height: 194)
                VStack(alignment: .leading, spacing: 10) {
                    Text(movie.title)
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .lineLimit(2)
                    Text(movie.genres)
                        .font(.system(size: 17))
                        .foregroundColor(Color.gray)
                        .lineLimit(2)
                    HStack(alignment: .center, spacing: 5.0) {
                        Image(systemName: "star")
                            .foregroundColor(.gray)
                        Text("\(movie.vote_average)")
                            .font(.system(size: 12))
                            .foregroundColor(Color.gray)
                    }
                }
            }
            Text("Overview")
                .font(.system(size: 14))
                .fontWeight(.semibold)
            Text(movie.overview)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
            Spacer()
        }.navigationBarTitle("Movie", displayMode: .inline)
            .padding(.all, 24)
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: MovieStorage.testMovie)
    }
}
