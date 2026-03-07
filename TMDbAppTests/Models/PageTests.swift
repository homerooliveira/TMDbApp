import Testing
@testable import TMDbApp

@Suite("Page")
struct PageTests {

    @Test("hasNextPage returns false when on last page")
    func hasNextPageFalseOnLastPage() {
        let page = Page<Movie>(results: [], page: 3, totalResults: 60, totalPages: 3)
        #expect(page.hasNextPage == false)
    }

    @Test("hasNextPage returns true when more pages remain")
    func hasNextPageTrueWhenMorePagesRemain() {
        let page = Page<Movie>(results: [], page: 1, totalResults: 60, totalPages: 3)
        #expect(page.hasNextPage == true)
    }

    @Test("hasNextPage regression: equal page and totalPages should be false")
    func hasNextPageRegressionEqualValues() {
        // Regression: old code used <= which incorrectly returned true when page == totalPages
        let page = Page<Movie>(results: [], page: 5, totalResults: 100, totalPages: 5)
        #expect(page.hasNextPage == false, "Should not have a next page when current equals total")
    }

    @Test("hasNextPage returns false for single page result")
    func hasNextPageFalseForSinglePage() {
        let page = Page<Movie>(results: [], page: 1, totalResults: 5, totalPages: 1)
        #expect(page.hasNextPage == false)
    }
}
