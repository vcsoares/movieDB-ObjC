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
        
        if error?.pointee != nil || movies.isEmpty {
            print("-X-X- MOVIE LIST ERROR")
            print(error!.pointee!.localizedDescription)
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.movies[option] = movies as? [Movie]
        }
    }
    
    func receivedMovieDetails(_ json: Data, for movie: Movie) {
        print("a")
    }
    
    func fetchFailedWithError(_ error: Error) {
        print("-XXX- FETCH FAILED")
        print(error.localizedDescription)
    }
    
    @Published var movies : [FetchOption : [Movie]] = [
        FetchOption.nowPlaying : [],
        FetchOption.popular : []
    ]
}

struct ContentView: View {
    @ObservedObject var storage = MovieStorage()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Popular").font(.system(size: 17))
                .fontWeight(.semibold)) {
                    ForEach(storage.movies[.popular]!.prefix(2), id: \.self) { movie in
                        MovieView(movie: movie)
                    }
                }
                Section(header: Text("Now playing").font(.system(size: 17))
                .fontWeight(.semibold)) {
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

struct PosterView: View {
    @ObservedObject private var poster : RemoteImage
    
    var body: some View {
        Image(uiImage: UIImage(data: poster.imageData) ?? UIImage())
            .resizable()
            .cornerRadius(10)
    }
    
    init(movie: Movie) {
        poster = RemoteImage(movie: movie)
    }
}

class RemoteImage : ObservableObject {
    @Published var imageData = Data()
    
    init(movie: Movie) {
        if movie.poster.isEmpty {
            URLSession.shared.dataTask(with: movie.poster_path) { [weak self] (data, response, error) in
                guard let data = data else {
                    print("-X-X- ERROR DOWNLOADING POSTER")
                    
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    self?.imageData = data
                }
            }.resume()
        } else {
            imageData = movie.poster
        }
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
        ContentView()
    }
}
