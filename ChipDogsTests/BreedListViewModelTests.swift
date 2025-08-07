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
        "Hound": ["Blood", "Sleepy", "Dozey"],
        "Sausage": []
    ]

    override func setUpWithError() throws {
        mockDogApi = MockDogAPI( )
        mockDogApi.breedResponse = BreedListResponse(message: testBreedList, status: "test")
        viewModel = BreedListViewModel(dogAPI: mockDogApi)
    }

    override func tearDownWithError() throws {
       
    }

    func testBreedListHasBreedListDict() throws {
        XCTAssertNotNil(viewModel.breedList)
    }
    
    func testViewModelReturnsExpectedTitle() {
        XCTAssertEqual("Dog Breeds", viewModel.title)
    }
    
    
    func testFetchBreedsCallsDogApiSetsBreedList() throws
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
        
        viewModel.fetchBreeds()
        
        wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(1, mockDogApi.fetchBreedListCallCounter)
        XCTAssertNotNil(updatedBreedList)
        XCTAssertEqual(3, updatedBreedList?.first?.subbreeds.count)
    }
    

}
