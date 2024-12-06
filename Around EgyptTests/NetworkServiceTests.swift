import XCTest
@testable import Around_Egypt

final class NetworkServiceIntegrationTests: XCTestCase {

    override func setUpWithError() throws {
        super.setUp()
        // If you need to configure your NetworkService to point to a test server, do it here
        // For example:
        // NetworkService.shared.baseURL = "https://test.api.com/"
    }

    override func tearDownWithError() throws {
        super.tearDown()
        // Cleanup or reset network configurations
    }

    func testFetchRecommendedExperiences() throws {
        let expectation = self.expectation(description: "Fetching recommended experiences from real API")

        // Call the real API endpoint
        NetworkService.shared.fetchRecommendedExperiences { result in
            switch result {
            case .success(let experiences):
                // Assert that the experiences array is not empty
                XCTAssertTrue(experiences.count > 0, "Expected at least one experience.")
                // You can add more validations here based on actual response data

            case .failure(let error):
                XCTFail("Expected success, but got failure: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil) // Wait for the real network request to complete
    }

    func testFetchMostRecentExperiences() throws {
        let expectation = self.expectation(description: "Fetching most recent experiences from real API")

        // Call the real API endpoint
        NetworkService.shared.fetchMostRecentExperiences { result in
            switch result {
            case .success(let experiences):
                // Assert that the experiences array is not empty
                XCTAssertTrue(experiences.count > 0, "Expected at least one recent experience.")
                // You can add more validations here based on actual response data

            case .failure(let error):
                XCTFail("Expected success, but got failure: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil) // Wait for the real network request to complete
    }

    func testLikeExperience() throws {
        let expectation = self.expectation(description: "Liking an experience through real API")

        // Assuming experience ID 1 is valid and the endpoint accepts likes
        NetworkService.shared.likeExperience(experienceID: "7f209d18-36a1-44d5-a0ed-b7eddfad48d6") { result in
            switch result {
            case .success(let likeCount):
                // Assert the like count has increased
                XCTAssertGreaterThan(likeCount, 0, "Expected like count to be greater than 0.")

            case .failure(let error):
                XCTFail("Expected success, but got failure: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil) // Wait for the real network request to complete
    }

    // Other tests for different methods...
}
