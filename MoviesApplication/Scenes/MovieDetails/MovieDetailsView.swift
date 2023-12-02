//
//  MovieDetailsView.swift
//  MoviesApplication
//
//  Created by abuzeid on 29.11.23.
//

import Foundation
import SwiftUI
struct MovieDetailsView: View {
    @ObservedObject private var viewModel = MovieDetailsViewModel()
    let movieID: Int

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let movieDetail = viewModel.movieDetails {
                    ZStack(alignment: .bottomLeading) {
                        DownloadableImage(url: viewModel.posterURL(for: movieDetail.posterPath),
                                          width: ThumbnailsDimentions.width,
                                          height: ThumbnailsDimentions.height)
                        VStack(alignment: .leading) {
                            Text(movieDetail.title)
                                .font(.title)
                                .foregroundColor(.white)

                            Text("Year: \(viewModel.dateDisplay)")
                                .font(.headline)
                                .foregroundColor(.white)
                        }.padding()
                    }
                    .frame(height: ThumbnailsDimentions.height)
                    Spacer()
                    Text(movieDetail.overview)
                        .padding()
                } else {
                    Text("Movie not found")
                }
            }
        }
        .onAppear {
            self.viewModel.fetchMovieDetail(movieID: movieID) { _ in }
        }
        .navigationBarHidden(false)
        .edgesIgnoringSafeArea(.top)
    }

    private enum ThumbnailsDimentions {
        static let height = UIScreen.main.bounds.height * 0.6
        static let width = UIScreen.main.bounds.width
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListView()
    }
}
