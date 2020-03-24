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
