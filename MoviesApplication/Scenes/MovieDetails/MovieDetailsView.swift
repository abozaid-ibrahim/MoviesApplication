//
//  MovieDetailsView.swift
//  MoviesApplication
//
//  Created by abuzeid on 29.11.23.
//

import Foundation
import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var viewModel = MoviesListViewModel()
    let movieID: Int

    var body: some View {
        VStack(alignment: .leading) {
            if let movieDetail = viewModel.movies.first(where: { $0.id == movieID }) {
                DownloadableImage(url:viewModel.posterURL(for: movieDetail.posterPath))
                .frame(height: 200)

                Text(movieDetail.title)
                    .font(.title)
                    .padding()

                Text("Year: \(String(movieDetail.releaseDate.prefix(4)))")
                    .font(.headline)
                    .padding()

                Text(movieDetail.overview)
                    .padding()
            } else {
                Text("Movie not found")
            }
        }
        .onAppear {
            self.viewModel.fetchMovieDetail(movieID: movieID) { _ in }
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListView()
    }
}
