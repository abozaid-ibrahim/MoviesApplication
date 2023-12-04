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

    func testFetchMoviesPaginationNotExceedingTotalPages() {
        setupDataSource(isSuccess: true, endPointPath: .movies)
        let expectation = XCTestExpectation(description: "Movies fetch result")
        var resultError: Error?
        for _ in 0 ... 9 {
            let _ = dataSource.fetchMovies()
        }
        dataSource.fetchMovies()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    resultError = error
                }
                expectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.01)

        XCTAssertNotNil(resultError)
    }

    func testFetchMoviesSuccess() {
        setupDataSource(isSuccess: true, endPointPath: .movies)
        assertFetchMoviesResult(expectedError: nil)
    }

    func testFetchMoviesFailure() {
        setupDataSource(isSuccess: false, endPointPath: .movies)
        assertFetchMoviesResult(expectedError: NetworkError.invalidURL)
    }

    private func setupDataSource(isSuccess: Bool, endPointPath: MockMovieAPI.EndPointPath) {
        dataSource = MovieAPIDataSource(apiClient: MockMovieAPI(isSuccess: isSuccess, endPointPath: endPointPath.rawValue))
    }

    private func assertFetchMoviesResult(expectedError: NetworkError?) {
        let expectation = XCTestExpectation(description: "Movies fetch result")
        var resultError: Error?

        dataSource.fetchMovies()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    resultError = error
                }
                expectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.01)

        if let expectedError = expectedError {
            XCTAssertEqual(resultError as? NetworkError, expectedError)
        } else {
            XCTAssertNil(resultError)
        }
    }
}
