//
//  BreedListViewModelTests.swift
//  ItsDogsTests
//
//  Created by Calum Maclellan on 07/08/2025.
//
@testable import ItsDogs
import XCTest
import Combine

final class BreedListViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    var viewModel: BreedListViewModel!
    var mockBreedService: MockDogBreedService!
    var mockImageService: MockDogImageService!
    var testBreedList = [
        Breed(breedName: "hound", subbreeds: ["blood", "sleepy", "dozey"]),
        Breed(breedName: "sausage", subbreeds: [])
    ]

    override func setUpWithError() throws {
        mockBreedService = MockDogBreedService()
        mockImageService = MockDogImageService()
        mockBreedService.breedResponse = testBreedList
        viewModel = BreedListViewModel(imageService: mockImageService, breedService: mockBreedService)
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
        XCTAssertEqual(1, mockBreedService.fetchBreedListCallCounter)
        XCTAssertNotNil(updatedBreedList)
        XCTAssertEqual(3, updatedBreedList?.first?.subbreeds.count)
    }
    
    func testModifyingSearchTermsUpdatesTheBreedListIfBreedsMatchTerm() async {
                
        let exp1 = XCTestExpectation(description: "Initial population of list is greater than 1")
        let exp2 = XCTestExpectation(description: "Breed list should be filtered")
        
        await viewModel.fetchBreeds()
        
        viewModel.$breedList.sink(receiveValue: {
            result in
            if result.count == 2 {
                //initial population of the list after calling fetch breeds
                exp1.fulfill()
            }
            if result.count == 1 {
                exp2.fulfill()
            }
        })
        .store(in: &cancellables)
        
        await fulfillment(of: [exp1], timeout: 1)
        
        XCTAssertEqual(viewModel.breedList.count, testBreedList.count)
        
        await viewModel.filterBreeds(term:  "Sausage")
        
        await fulfillment(of: [exp2], timeout: 1)

        XCTAssertNotNil(viewModel.breedList)
        XCTAssertEqual(1, viewModel.breedList.count)
        XCTAssertEqual("sausage", viewModel.breedList.first?.breedName)
    }
    
   func testModifyingSearchTermsUpdatesTheBreedListIfNoBreedsMatchTheTerm() async {
                
        let exp1 = XCTestExpectation(description: "Initial population of list is greater than 1")
        let exp2 = XCTestExpectation(description: "Breed list should be filtered")
        
        await viewModel.fetchBreeds()
        
        viewModel.$breedList.sink(receiveValue: {
            result in
            if result.count > 1 {
                //initial population of the list after calling fetch breeds
                exp1.fulfill()
            }
            if result.count == 0 {
                exp2.fulfill()
            }
        })
        .store(in: &cancellables)
        
        await fulfillment(of: [exp1], timeout: 1)
        
        XCTAssertEqual(viewModel.breedList.count, testBreedList.count)
        
        await viewModel.filterBreeds(term: "Hotdog")
       
        await fulfillment(of: [exp2], timeout: 2)

        XCTAssertNotNil(viewModel.breedList)
        XCTAssertEqual(0, viewModel.breedList.count)
    }
    
    func testIfAPIThrowsUrlsNotSetAndFetchFailedIsSet() async {
        mockBreedService.throwError = true
        
        viewModel = BreedListViewModel(imageService: mockImageService, breedService: mockBreedService)
        
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
        XCTAssertEqual(1, mockBreedService.fetchBreedListCallCounter)
        XCTAssertEqual(0, viewModel.breedList.count)
    }

}
