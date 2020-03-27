//
//  PosterView.swift
//  moviedb-swift
//
//  Created by Vinícius Chagas on 24/03/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

import SwiftUI

class RemoteImage : ObservableObject {
    @Published var imageData = Data()
    
    init(movie: Movie) {
        if movie.poster.isEmpty || self.imageData.isEmpty {
            URLSession.shared.dataTask(with: movie.poster_path) { [weak self] (data, response, error) in
                guard let data = data else {
                    print("-X-X- ERROR DOWNLOADING POSTER")
                    
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    movie.poster = data
                    self?.imageData = data
                }
            }.resume()
        } else {
            imageData = movie.poster
        }
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

//struct PosterView_Previews: PreviewProvider {
//    static var previews: some View {
//        PosterView()
//    }
//}
