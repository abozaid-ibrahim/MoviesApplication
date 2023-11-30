//
//  ContentView.swift
//  MoviesApplication
//
//  Created by abuzeid on 28.11.23.
//

import SwiftUI

struct MoviesListView: View {
    @ObservedObject private var viewModel = MoviesListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.movies) { movie in
                NavigationLink(destination: MovieDetailView(movieID: movie.id)) {
                    VStack{
                        listViewRow(for: movie)
                        if viewModel.movies.isLastItem(movie) {
                            lastRowView
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
    private func listViewRow(for movie: Movie)-> some View{
        HStack{
                
            DownloadableImage(url: viewModel.posterURL(for: movie.posterPath),  width: ThumbnailsDimentions.width, height: ThumbnailsDimentions.height)
                .cornerRadius(ThumbnailsDimentions.cornerRadius)
            
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                Text(movie.releaseDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
    private var lastRowView: some View {
        ZStack(alignment: .center) {
            switch viewModel.paginationState {
            case .isLoading:
                ProgressView()
            case .idle:
                EmptyView()
            case .error:
                //TODO implment proper error view according to the busniess needs.
                EmptyView()
            }
        }
        
        .onAppear {
            viewModel.fetchMovies()
        }
    }
}

#Preview {
    MoviesListView()
}
// images dimenstions
//Scrolling smoothly

struct ThumbnailsDimentions{
    static let width: CGFloat =  (UIScreen.main.bounds.width / 4) * 0.75
    static let height: CGFloat = (UIScreen.main.bounds.width / 3) * 0.75
    static let cornerRadius: CGFloat = 16
}

