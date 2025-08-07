//
//  BreedDetailViewModelTests.swift
//  ChipDogsTests
//
//  Created by Calum Maclellan on 07/08/2025.
//
@testable import ChipDogs
import XCTest

final class BreedDetailViewModelTests: XCTestCase {

    var viewModel: BreedDetailViewModel!
    
    override func setUpWithError() throws {
        viewModel = BreedDetailViewModel(breed: "test dog")
    }

    override func tearDownWithError() throws {
    }

    func testExpectedTitleIsReturned()  {
        viewModel = BreedDetailViewModel(breed: "terrier")
        
        XCTAssertEqual("Terrier", viewModel.title)
        
        viewModel = BreedDetailViewModel(breed: "terrier", subbreed: "border")
        XCTAssertEqual("Border terrier", viewModel.title)
    }

   

}
