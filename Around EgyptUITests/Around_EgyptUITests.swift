import XCTest

final class Around_EgyptUITests: XCTestCase {

    override func setUpWithError() throws {
        // Set up the initial state for UI tests
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Clean up after each test
    }

    // Test launching the app and navigating to a specific screen
    func testLaunchAndNavigate() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Verify the main screen loaded by checking a known element
        let titleLabel = app.staticTexts["Welcome"]  // Replace with actual identifier of the home screen title
        XCTAssertTrue(titleLabel.exists, "Home screen title should be displayed.")
        
    }

    // Test filling a text field and tapping a button to perform a search
    func testSearchFunctionality() throws {
        let app = XCUIApplication()
        app.launch()

        // Ensure the search field is present, but since it's not a tab, use textFields or other UI elements
        let searchField = app.textFields["SearchForExperiences"]  // Use the identifier you set
        XCTAssertTrue(searchField.exists, "Search field should be visible.")
        
        // Tap the search field to activate it
        searchField.tap()
        searchField.typeText("Abu Simbel Temples")
        
        // Verify that results are displayed after searching (ensure your UI shows something related to the search)
        let searchResult = app.staticTexts["Abu Simbel Temples"]  // This depends on what your app displays
        XCTAssertTrue(searchResult.exists, "Search results should display.")
    }

    
    // Test navigation from a list of experiences to an experience detail view
    func testNavigateToExperienceDetail() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Let's say you're targeting an experience with ID "1"
        let experienceImage = app.staticTexts["Experience_7f209d18-36a1-44d5-a0ed-b7eddfad48d6"]  // Unique identifier for the first experience
        XCTAssertTrue(experienceImage.waitForExistence(timeout: 5), "Experience image should exist.")
        
        // Tap the image to navigate to the experience detail screen
        experienceImage.tap()
        
        // Verify that the detail screen is displayed (e.g., check for a specific element on the detail screen)
        let detailScreenTitle = app.staticTexts["Experience_7f209d18-36a1-44d5-a0ed-b7eddfad48d6"]  // Adjust this to your actual detail screen element
        XCTAssertTrue(detailScreenTitle.waitForExistence(timeout: 5), "Detail screen should appear")
    }

}
