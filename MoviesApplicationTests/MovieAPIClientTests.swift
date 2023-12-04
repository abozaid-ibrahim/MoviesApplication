import Combine
@testable import MoviesApplication
import XCTest

final class MovieAPIClientTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        cancellables.removeAll()
    }

    func testFetchDataSuccessfully() throws {
        let client = MockMovieAPI(isSuccess: true, endPointPath: "list")
        let endpoint = EndPoint(path: "list", method: .get, parameters: ["page": 1])

        let expectation = XCTestExpectation(description: "Fetch data expectation")

        client.fetchData(for: endpoint)
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case let .failure(error):
                    XCTFail("Failed to fetch data: \(error)")
                }
            } receiveValue: { (movies: MovieResults) in
                XCTAssertFalse(movies.results.isEmpty, "Fetched movies should not be empty")
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }

    func testFetchMoviesResultFailed() {
        let expectation = XCTestExpectation(description: "Movies fetch result")
        var resultError: Error?
        let client = MockMovieAPI(isSuccess: false, endPointPath: "list")
        let endpoint = EndPoint(path: "list", method: .get, parameters: ["page": 1])
        client.fetchData(for: endpoint)
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
}
