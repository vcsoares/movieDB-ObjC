//
//  MovieListView.swift
//  moviedb-swift
//
//  Created by Vinícius Chagas on 23/03/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

import SwiftUI

struct MovieListView: View {
    @ObservedObject var storage = MovieStorage()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Popular").font(.system(size: 17)).fontWeight(.semibold)) {
                    ForEach(storage.movies[.popular]!.prefix(2), id: \.self) { movie in
                        MovieView(movie: movie)
                    }
                }
                Section(header: Text("Now playing").font(.system(size: 17)).fontWeight(.semibold)) {
                    ForEach(storage.movies[.nowPlaying]!, id: \.self) { movie in
                        MovieView(movie: movie)
                    }
                }
            }.listStyle(GroupedListStyle())
        .navigationBarTitle("Movies")
        }.accentColor(.black)
    }
    
    init() {
        UITableView.appearance().separatorStyle = .none
        
        let c = Communicator()
        c.delegate = storage
        c.fetchMovieList(.popular)
        c.fetchMovieList(.nowPlaying)
    }
}

struct MovieView: View {
    @State var movie : Movie
    
    var body: some View {
        HStack {
            PosterView(movie: movie)
                .frame(width: 79.0, height: 118.0)
            VStack(alignment: .leading, spacing: 10) {
                Text(movie.title)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .lineLimit(2)
                Text(movie.overview)
                    .font(.system(size: 13))
                    .foregroundColor(Color.gray)
                    .lineLimit(3)
                HStack(alignment: .center, spacing: 5.0) {
                    Image(systemName: "star")
                        .foregroundColor(.gray)
                    Text("\(movie.vote_average)")
                        .font(.system(size: 12))
                        .foregroundColor(Color.gray)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}
