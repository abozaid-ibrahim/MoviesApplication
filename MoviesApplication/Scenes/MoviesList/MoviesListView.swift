//
//  ContentView.swift
//  MoviesApplication
//
//  Created by abuzeid on 28.11.23.
//

import SwiftUI

struct MoviesListView: View {
    @ObservedObject var viewModel = MoviesListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.movies) { movie in
                NavigationLink(destination: MovieDetailView(movieID: movie.id)) {
                    HStack{
                        DownloadableImage(url: viewModel.posterURL(for: movie.posterPath))
                            .frame(width: 90, height: 90)
                        VStack(alignment: .leading) {
                            Text(movie.title)
                                .font(.headline)
                            Text(movie.releaseDate)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationBarTitle("Movies List")
        }
        .onAppear {
            self.viewModel.fetchMovies()
        }
    }
}

#Preview {
    MoviesListView()
}
