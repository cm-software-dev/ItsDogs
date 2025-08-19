//
//  BreedDetailViewModelTests.swift
//  ItsDogsTests
//
//  Created by Calum Maclellan on 07/08/2025.
//
@testable import ItsDogs
import XCTest
import Combine

final class BreedDetailViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    var viewModel: BreedDetailViewModel!
    var selectedBreed: SelectedBreed!
    var mockImageService: MockDogImageService!
    
    var testURLs: [URL] = []
    
    override func setUpWithError() throws {
        selectedBreed = SelectedBreed(breedName: "terrier", subbreed: "border")
        mockImageService = MockDogImageService()
        viewModel = BreedDetailViewModel(breed: selectedBreed, imageService: mockImageService)
        
        let testURLstrings =  ["https://images.dog.ceo/breeds/weimaraner/n02092339_114.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_4271.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_4346.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_512.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_5978.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_6269.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_6401.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_6752.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_7918.jpg", "https://images.dog.ceo/breeds/weimaraner/n02092339_93.jpg"]
        testURLs = testURLstrings.compactMap({URL(string: $0)})
    }

    override func tearDownWithError() throws {
    }

    func testExpectedTitleIsReturned()  {
        var selectedBreed = SelectedBreed(breedName: "terrier", subbreed: nil)
        
        viewModel = BreedDetailViewModel(breed: selectedBreed, imageService: mockImageService)
        
        XCTAssertEqual(selectedBreed.breedName.capitalized, viewModel.title)
        
        selectedBreed = SelectedBreed(breedName: "terrier", subbreed: "border")
        
        viewModel = BreedDetailViewModel(breed: selectedBreed, imageService: mockImageService)
        XCTAssertEqual("Border Terrier", viewModel.title)
    }
    
    func testFetchImagesCallsTheApiAndSetsTheURLSForBreedOnly() async {
        let selectedBreed = SelectedBreed(breedName: "terrier", subbreed: nil)
        
        mockImageService = MockDogImageService()
        mockImageService.imageResponse = testURLs
        
        viewModel = BreedDetailViewModel(breed: selectedBreed, imageService: mockImageService)
        
        var updatedImageUrls: [URL]?
        let exp = XCTestExpectation(description: "imageUrls not updated")
        
        viewModel.$imageURLs.sink(receiveValue: {
            result in
            if !result.isEmpty {
                updatedImageUrls = result
                exp.fulfill()
            }
        }).store(in: &cancellables)
        
        await viewModel.fetchImages()
        
        await fulfillment(of: [exp], timeout: 1)
        
        XCTAssertFalse(viewModel.fetchFailed)
        XCTAssertNotNil(updatedImageUrls)
        XCTAssertEqual(1, mockImageService.fetchDogImagesBreedOnlyCallCounter)
        XCTAssertEqual(testURLs.count, updatedImageUrls?.count)
        XCTAssertEqual(testURLs.first?.absoluteString, updatedImageUrls?.first?.absoluteString)
        
    }
    
    func testFetchImagesCallsTheApiAndSetsTheURLSForBreedAndSubreed() async {
        let selectedBreed = SelectedBreed(breedName: "terrier", subbreed: "border")
        
        mockImageService = MockDogImageService()
        mockImageService.imageResponse = testURLs
        
        viewModel = BreedDetailViewModel(breed: selectedBreed, imageService: mockImageService)
        
        var updatedImageUrls: [URL]?
        let exp = XCTestExpectation(description: "imageUrls not updated")
        
        viewModel.$imageURLs.sink(receiveValue: {
            result in
            if !result.isEmpty {
                updatedImageUrls = result
                exp.fulfill()
            }
        }).store(in: &cancellables)
        
        await viewModel.fetchImages()
        
        await fulfillment(of: [exp], timeout: 1)
        
        XCTAssertFalse(viewModel.fetchFailed)
        XCTAssertNotNil(updatedImageUrls)
        XCTAssertEqual(1, mockImageService.fetchDogImagesWithSubreedCallCounter)
        XCTAssertEqual(testURLs.count, updatedImageUrls?.count)
        XCTAssertEqual(testURLs.first?.absoluteString, updatedImageUrls?.first?.absoluteString)
        
    }
   
    func testIfAPIThrowsUrlsNotSetAndFetchFailedIsSetForBreedAndSubreed() async {
        mockImageService.throwError = true
        
        let selectedBreed = SelectedBreed(breedName: "terrier", subbreed: "border")
        
        viewModel = BreedDetailViewModel(breed: selectedBreed, imageService: mockImageService)
        
        let exp = XCTestExpectation(description: "$fetchFailed not updated")
        
        viewModel.$fetchFailed.sink(receiveValue: {
            result in
            if result {
                exp.fulfill()
            }
            
        }).store(in: &cancellables)
        
        await viewModel.fetchImages()
        
        await fulfillment(of: [exp], timeout: 1)
        
        XCTAssertTrue(viewModel.fetchFailed)
        XCTAssertEqual(1, mockImageService.fetchDogImagesWithSubreedCallCounter)
        XCTAssertEqual(0, viewModel.imageURLs.count)
    }
    
    func testIfAPIThrowsUrlsNotSetAndFetchFailedIsSetForBreedOnly() async {
        mockImageService.throwError = true
        
        let selectedBreed = SelectedBreed(breedName: "terrier", subbreed: nil)
        
        viewModel = BreedDetailViewModel(breed: selectedBreed, imageService: mockImageService)
        
        let exp = XCTestExpectation(description: "$fetchFailed not updated")
        
        viewModel.$fetchFailed.sink(receiveValue: {
            result in
            if result {
                exp.fulfill()
            }
            
        }).store(in: &cancellables)
        
       await viewModel.fetchImages()
        
        await fulfillment(of: [exp], timeout: 1)
        
        XCTAssertTrue(viewModel.fetchFailed)
        XCTAssertEqual(1, mockImageService.fetchDogImagesBreedOnlyCallCounter)
        XCTAssertEqual(0, viewModel.imageURLs.count)
    }

}
