//
//  MovieStorage.swift
//  moviedb-swift
//
//  Created by Vinícius Chagas on 24/03/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

import Foundation

class MovieStorage : NSObject, ObservableObject, CommunicatorDelegate {
    @Published var movies : [FetchOption : [Movie]] = [
        FetchOption.nowPlaying : [],
        FetchOption.popular : []
    ]
    
    static var testMovie : Movie {
        get {
            let movie = Movie()
            movie.id = 420818
            movie.title = "The Lion King"
            movie.genres = "Adventure, Animation, Family, Drama, Action"
            movie.overview = "Simba idolizes his father, King Mufasa, and takes to heart his own royal destiny. But not everyone in the kingdom celebrates the new cub's arrival. Scar, Mufasa's brother—and former heir to the throne—has plans of his own. The battle for Pride Rock is ravaged with betrayal, tragedy and drama, ultimately resulting in Simba's exile. With help from a curious pair of newfound friends, Simba will have to figure out how to grow up and take back what is rightfully his."
            movie.poster_path = URL(string: "https://image.tmdb.org/t/p/w500/2bXbqYdUdNVa8VIWXVfclP2ICtT.jpg")!
            movie.vote_average = 7.1
            return movie
        }
    }
    
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
}
