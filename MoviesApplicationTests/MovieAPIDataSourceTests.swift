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
        setupDataSource(isSuccess: true, endPointPath: "movies")
        let expectation = XCTestExpectation(description: "Movies fetch result")
        var resultError: Error?
        for _ in 0 ... 9 {
            dataSource.fetchMovies()
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
        setupDataSource(isSuccess: true, endPointPath: "movies")
        assertFetchMoviesResult(expectedError: nil)
    }

    func testFetchMoviesFailure() {
        setupDataSource(isSuccess: false, endPointPath: "movies")
        assertFetchMoviesResult(expectedError: NetworkError.invalidURL)
    }

    private func setupDataSource(isSuccess: Bool, endPointPath: String) {
        dataSource = MovieAPIDataSource(apiClient: MockMovieAPI(isSuccess: isSuccess, endPointPath: endPointPath))
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

        wait(for: [expectation], timeout: 0.001)

        if let expectedError = expectedError {
            XCTAssertEqual(resultError as? NetworkError, expectedError)
        } else {
            XCTAssertNil(resultError)
        }
    }
}

struct MockMovieAPI: APIClient {
    var baseUrl: String = ""
    let isSuccess: Bool
    let endPointPath: String

    func fetchData<T>(for _: MoviesApplication.EndPoint) -> AnyPublisher<T, Error> where T: Decodable {
        guard isSuccess else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        if endPointPath == "details" {
            let details = MovieDetails(title: "Sample Movie", overview: "Sample Overview", posterPath: nil, releaseDate: Date())
            return Just(details as! T)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            let results = MovieResults(results: [Movie(id: 1, title: "Sample Movie", overview: "Sample Overview", posterPath: nil, releaseDate: Date())])
            return Just(results as! T)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
