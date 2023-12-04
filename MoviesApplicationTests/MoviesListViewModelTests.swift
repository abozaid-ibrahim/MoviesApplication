import Combine
@testable import MoviesApplication
import XCTest

final class MoviesListViewModelTests: XCTestCase {
    var viewModel: MoviesListViewModel!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        viewModel = MoviesListViewModel(dataSource: StubSuccessAPIDataSource())
    }

    override func tearDown() {
        viewModel = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testFetchMoviesSuccessfullyAndReturnListOfMovies() {
        let expectation = XCTestExpectation(description: "Movies fetched successfully")
        var moviesList: [Movie]?
        viewModel.$movies
            .sink { movies in
                moviesList = movies
                if !movies.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.fetchMovies()
        wait(for: [expectation], timeout: 0.01)
        XCTAssertNotNil(moviesList)
    }

    func testDisplayDateAsYearOnly() {
        // Given
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: "2020-01-02")!
        // When
        let formattedDate = viewModel.display(date: date)
        // Then
        XCTAssertEqual(formattedDate, "2020")
    }

    func testPosterURLBuildCorrectly() {
        let path = "examplePath"
        let url = viewModel.posterURL(for: path)
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "https://image.tmdb.org/t/p/w200/\(path)")
    }
}

struct StubSuccessAPIDataSource: MovieDataSource {
    var fetchMoviesState: PaginationState = .idle

    func fetchMovies() -> AnyPublisher<MovieResults, Error> {
        let results = MovieResults(results: [Movie(id: 1, title: "Sample Movie", overview: "Sample Overview", posterPath: nil, releaseDate: Date())])
        return Just(results)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func fetchMovieDetail(movieID _: Int) -> AnyPublisher<MovieDetails, Error> {
        let details = MovieDetails(title: "Sample Movie", overview: "Sample Overview", posterPath: nil, releaseDate: Date())
        return Just(details)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
