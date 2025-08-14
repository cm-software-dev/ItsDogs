//
//  BreedListViewModelTests.swift
//  ChipDogsTests
//
//  Created by Calum Maclellan on 07/08/2025.
//
@testable import ChipDogs
import XCTest
import Combine

final class BreedListViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    var viewModel: BreedListViewModel!
    var mockDogApi: MockDogAPI!
    var testBreedList = [
        "hound": ["blood", "sleepy", "dozey"],
        "sausage": []
    ]

    override func setUpWithError() throws {
        mockDogApi = MockDogAPI( )
        mockDogApi.breedResponse = testBreedList
        viewModel = BreedListViewModel(dogAPI: mockDogApi)
    }

    override func tearDownWithError() throws {
        cancellables.forEach({$0.cancel()})
    }

    func testBreedListHasBreedListDict() throws {
        XCTAssertNotNil(viewModel.breedList)
    }
    
    func testViewModelReturnsExpectedTitle() {
        XCTAssertEqual("Dog Breeds", viewModel.title)
    }
    
    
    func testFetchBreedsCallsDogApiSetsBreedList() async throws
    {
        var updatedBreedList: [Breed]?
        let exp = XCTestExpectation(description: "BreedList not updated")
        
        viewModel.$breedList.sink(receiveValue: {
            result in
            if !result.isEmpty {
                updatedBreedList = result
                exp.fulfill()
            }
        })
        .store(in: &cancellables)
        
        XCTAssertNil(updatedBreedList)
        
        await viewModel.fetchBreeds()
        await fulfillment(of: [exp], timeout: 1)
        
        XCTAssertFalse(viewModel.fetchFailed)
        XCTAssertEqual(1, mockDogApi.fetchBreedListCallCounter)
        XCTAssertNotNil(updatedBreedList)
        XCTAssertEqual(3, updatedBreedList?.first?.subbreeds.count)
    }
    
    func testModifyingSearchTermsUpdatesTheBreedListIfBreedsMatchTerm() async {
                
        var updatedBreedList: [Breed]?
        let exp1 = XCTestExpectation(description: "Initial population of list is greater than 1")
        let exp2 = XCTestExpectation(description: "Breed list should be filtered")
        
        await viewModel.fetchBreeds()
        
        viewModel.$breedList.sink(receiveValue: {
            result in
            if result.count > 1 {
                //initial population of the list after calling fetch breeds
                updatedBreedList = result
                exp1.fulfill()
            }
            if self.viewModel.searchTerm != "" {
                updatedBreedList = result
                exp2.fulfill()
            }
        })
        .store(in: &cancellables)
        
        await fulfillment(of: [exp1], timeout: 1)
        
        XCTAssertEqual(updatedBreedList?.count, testBreedList.count)
        
        viewModel.searchTerm = "Sausage"
        
        await fulfillment(of: [exp2], timeout: 1)

        XCTAssertNotNil(updatedBreedList)
        XCTAssertEqual(1, updatedBreedList?.count)
        XCTAssertEqual("sausage", updatedBreedList?.first?.breedName)
    }
    
    func testModifyingSearchTermsUpdatesTheBreedListIfNoBreedsMatchTheTerm() async {
                
        var updatedBreedList: [Breed]?
        let exp1 = XCTestExpectation(description: "Initial population of list is greater than 1")
        let exp2 = XCTestExpectation(description: "Breed list should be filtered")
        
        await viewModel.fetchBreeds()
        
        viewModel.$breedList.sink(receiveValue: {
            result in
            if result.count > 1 {
                //initial population of the list after calling fetch breeds
                updatedBreedList = result
                exp1.fulfill()
            }
            if self.viewModel.searchTerm != "" {
                updatedBreedList = result
                exp2.fulfill()
            }
        })
        .store(in: &cancellables)
        
        await fulfillment(of: [exp1], timeout: 1)
        
        XCTAssertEqual(updatedBreedList?.count, testBreedList.count)
        
        viewModel.searchTerm = "Hotdog"
       
        await fulfillment(of: [exp2], timeout: 2)

       
        
        XCTAssertNotNil(updatedBreedList)
        XCTAssertEqual(0, updatedBreedList?.count)
    }
    
    func testIfAPIThrowsUrlsNotSetAndFetchFailedIsSet() async {
        mockDogApi.throwError = true
        
        viewModel = BreedListViewModel(dogAPI: mockDogApi)
        
        let exp = XCTestExpectation(description: "fetchFailed not updated")
        
        viewModel.$fetchFailed.sink(receiveValue: {
            result in
            if result {
                exp.fulfill()
            }
            
        }).store(in: &cancellables)
        
        await viewModel.fetchBreeds()
        
        await fulfillment(of: [exp], timeout: 1)
        
        XCTAssertTrue(viewModel.fetchFailed)
        XCTAssertEqual(1, mockDogApi.fetchBreedListCallCounter)
        XCTAssertEqual(0, viewModel.breedList.count)
    }

}
