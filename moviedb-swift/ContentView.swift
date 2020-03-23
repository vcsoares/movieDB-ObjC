//
//  ContentView.swift
//  moviedb-swift
//
//  Created by Vinícius Chagas on 23/03/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

import SwiftUI

class MovieStorage : NSObject, ObservableObject, CommunicatorDelegate {
    func receivedMovieList(_ json: Data, from option: FetchOption) {
        let error = NSErrorPointer(nilLiteral: ())
        let movies = Parser.movieList(fromJSON: json, error: error)
        if error?.pointee != nil {
            print("-X-X- MOVIE LIST ERROR")
            return
        }
        if !movies.isEmpty {
            DispatchQueue.main.async { [weak self] in
                self?.nowPlaying = movies as! [Movie]
            }
        }
    }
    
    func receivedMovieDetails(_ json: Data, for movie: Movie) {
        print("a")
    }
    
    func fetchFailedWithError(_ error: Error) {
        print("-XXX- FETCH FAILED")
        print(error.localizedDescription)
    }
    
    @Published var nowPlaying : [Movie] = []
    @Published var popular : [Movie] = []
}

struct ContentView: View {
    @ObservedObject var storage = MovieStorage()
    
    var body: some View {
        List(storage.nowPlaying, id: \.self) { movie in
            MovieView(movie: movie)
        }
    }
    
    init() {
        UITableView.appearance().separatorStyle = .none
        
        let c = Communicator()
        c.delegate = storage
        c.fetchMovieList(.nowPlaying)
    }
}

struct MovieView: View {
    @State var movie : Movie
    
    var body: some View {
        HStack {
            Image(systemName: "star")
                .frame(width: 79.0, height: 118.0)
                .border(Color.black, width: 1)
                .cornerRadius(10)
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
        ContentView()
    }
}
