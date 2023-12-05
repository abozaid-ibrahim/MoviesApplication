import Combine
@testable import MoviesApplication
import XCTest

final class MovieAPIDataSourceTests: XCTestCase {
    var dataSource: MovieAPIDataSource!
    var cancellables: Set<AnyCancellable> = []

    override func tearDown() {
        dataSource = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testFetchMoviesPaginationNotExceedingTotalPages() async {
        // Given
        setupDataSource(isSuccess: true, endPointPath: .movies)
        // When: calls fetch more than total pages time
        for _ in 0 ... 9 {
            do {
                let movies = try await dataSource.fetchMovies()
                XCTAssertNotNil(movies)
            } catch {
                XCTFail("Error fetching movies: \(error)")
            }
        }
        // Then
        do {
            let movies = try await dataSource.fetchMovies()
            // we exceed the total pages, movies should be nil
            XCTAssertNil(movies)
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testFetchMoviesSuccess() async {
        // Given
        setupDataSource(isSuccess: true, endPointPath: .movies)
        do {
            // When
            let movies = try await dataSource.fetchMovies()
            // Then
            XCTAssertNotNil(movies)
        } catch {
            XCTAssertNil(error)
        }
    }

    func testFetchMoviesFailure() async {
        setupDataSource(isSuccess: false, endPointPath: .movies)
        do {
            let movies = try await dataSource.fetchMovies()
            XCTAssertNil(movies)
        } catch {
            XCTAssertNotNil(error)
        }
    }

    private func setupDataSource(isSuccess: Bool, endPointPath: MockMovieAPI.EndPointPath) {
        dataSource = MovieAPIDataSource(apiClient: MockMovieAPI(isSuccess: isSuccess, endPointPath: endPointPath.rawValue))
    }
}
