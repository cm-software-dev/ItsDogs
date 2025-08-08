//
//  BreedDetailViewModelTests.swift
//  ChipDogsTests
//
//  Created by Calum Maclellan on 07/08/2025.
//
@testable import ChipDogs
import XCTest
import Combine

final class BreedDetailViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    var viewModel: BreedDetailViewModel!
    var selectedBreed: SelectedBreed!
    var api: MockDogImageAPI!
    
    let testURLs: [String] = ["https://images.dog.ceo/breeds/weimaraner/n02092339_114.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_4271.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_4346.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_512.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_5978.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_6269.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_6401.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_6752.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_7918.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_93.jpg"]
    
    override func setUpWithError() throws {
        selectedBreed = SelectedBreed(breedName: "terrier", subbreed: "border")
        api = MockDogImageAPI()
        viewModel = BreedDetailViewModel(breed: selectedBreed, api: api)
    }

    override func tearDownWithError() throws {
    }

    func testExpectedTitleIsReturned()  {
        var selectedBreed = SelectedBreed(breedName: "terrier", subbreed: nil)
        
        viewModel = BreedDetailViewModel(breed: selectedBreed, api: api)
        
        XCTAssertEqual(selectedBreed.breedName.capitalized, viewModel.title)
        
        selectedBreed = SelectedBreed(breedName: "terrier", subbreed: "border")
        
        viewModel = BreedDetailViewModel(breed: selectedBreed, api: api)
        XCTAssertEqual("Border terrier", viewModel.title)
    }
    
    func testFetchImagesCallsTheApiAndSetsTheURLSForBreedOnly() {
        let selectedBreed = SelectedBreed(breedName: "terrier", subbreed: nil)
        
        api = MockDogImageAPI()
        api.imageResponse = ImageResponse(message: testURLs, status: "success")
        
        viewModel = BreedDetailViewModel(breed: selectedBreed, api: api)
        
        var updatedImageUrls: [URL]?
        let exp = XCTestExpectation(description: "imageUrls not updated")
        
        viewModel.$imageURLs.sink(receiveValue: {
            result in
            if !result.isEmpty {
                updatedImageUrls = result
                exp.fulfill()
            }
        }).store(in: &cancellables)
        
        viewModel.fetchImages()
        
        wait(for: [exp], timeout: 1)
        
        XCTAssertNotNil(updatedImageUrls)
        XCTAssertEqual(1, api.fetchDogImagesBreedOnlyCallCounter)
        XCTAssertEqual(testURLs.count, updatedImageUrls?.count)
        XCTAssertEqual(testURLs.first, updatedImageUrls?.first?.absoluteString)
        
    }
    
    func testFetchImagesCallsTheApiAndSetsTheURLSForBreedAndSubreed() {
        let selectedBreed = SelectedBreed(breedName: "terrier", subbreed: "border")
        
        api = MockDogImageAPI()
        api.imageResponse = ImageResponse(message: testURLs, status: "success")
        
        viewModel = BreedDetailViewModel(breed: selectedBreed, api: api)
        
        var updatedImageUrls: [URL]?
        let exp = XCTestExpectation(description: "imageUrls not updated")
        
        viewModel.$imageURLs.sink(receiveValue: {
            result in
            if !result.isEmpty {
                updatedImageUrls = result
                exp.fulfill()
            }
        }).store(in: &cancellables)
        
        viewModel.fetchImages()
        
        wait(for: [exp], timeout: 1)
        
        XCTAssertNotNil(updatedImageUrls)
        XCTAssertEqual(1, api.fetchDogImagesWithSubreedCallCounter)
        XCTAssertEqual(testURLs.count, updatedImageUrls?.count)
        XCTAssertEqual(testURLs.first, updatedImageUrls?.first?.absoluteString)
        
    }
   

}
