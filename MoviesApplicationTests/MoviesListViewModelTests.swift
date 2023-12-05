import Combine
@testable import MoviesApplication
import XCTest

final class MoviesListViewModelTests: XCTestCase {
    var viewModel: MoviesListViewModel!

    override func setUp() {
        super.setUp()
        viewModel = MoviesListViewModel(dataSource: StubSuccessAPIDataSource())
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
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

    func fetchMovies() async throws -> MovieResults {
        MovieResults(results: [Movie(id: 1, title: "Sample Movie", overview: "Sample Overview", posterPath: nil, releaseDate: Date())])
    }

    func fetchMovieDetail(movieID _: Int) async throws -> MovieDetails {
        MovieDetails(title: "Sample Movie", overview: "Sample Overview", posterPath: nil, releaseDate: Date())
    }
}
