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
                    VStack(alignment: .leading) {
                        Text(movie.title)
                            .font(.headline)
                        Text(movie.overview)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationBarTitle("Movie List")
        }
        .onAppear {
            self.viewModel.fetchMovies()
        }
    }
}

#Preview {
    MoviesListView()
}
