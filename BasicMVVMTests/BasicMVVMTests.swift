//
//  BasicMVVMTests.swift
//  BasicMVVMTests
//
//  Created by otto on 11.06.2025.
//

import XCTest
@testable import BasicMVVM

final class SendPicViewModelTests: XCTestCase {
    
    var mockUploadManager: MockImageUploadManager!
    var mockDelegate: MockSendPicViewModelDelegate!
    var viewModel: SendPicViewModel!

    override func setUp() {
        super.setUp()
        mockUploadManager = MockImageUploadManager()
        mockDelegate = MockSendPicViewModelDelegate()
        viewModel = SendPicViewModel(imageUploadManager: mockUploadManager)
        viewModel.delegate = mockDelegate
    }

    override func tearDown() {
        viewModel = nil
        mockUploadManager = nil
        mockDelegate = nil
        super.tearDown()
    }

    func test_selectImage_setsSelectedImage() {
        let expectation = self.expectation(description: "selectedImage should update")
        let testImage = UIImage(systemName: "star")
        mockDelegate.simulatedImage = testImage

        viewModel.selectedImage.bind { image in
            if image == testImage {
                expectation.fulfill()
            }
        }

        viewModel.selectImage()
        wait(for: [expectation], timeout: 2.0)
    }

    func test_sendImage_success() {
        let expectation = self.expectation(description: "onSuccess should call")
        let testImage = UIImage(systemName: "photo")
        viewModel.selectedImage.value = testImage

        viewModel.onSuccess = { message in
            XCTAssertEqual(message, "upload_success")
            XCTAssertTrue(self.mockUploadManager.didCallUpload)
            XCTAssertEqual(self.mockUploadManager.uploadedImage, testImage)
            expectation.fulfill()
        }

        viewModel.sendImage()
        wait(for: [expectation], timeout: 2.0)
    }

    func test_sendImage_error() {
        let expectation = self.expectation(description: "onError should call")
        viewModel.selectedImage.value = UIImage()
        mockUploadManager.shouldReturnError = true

        viewModel.onError = { error in
            XCTAssertFalse(error.isEmpty)
            expectation.fulfill()
        }

        viewModel.sendImage()
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_sendImage_shouldToggleIsLoadingState() {
        let expectation = self.expectation(description: "isLoading state should change twice")

        var loadingStates: [Bool] = []
        
        viewModel.isLoading.bind(skipInitial: true) { isLoading in
            loadingStates.append(isLoading)
            if loadingStates.count == 2 {
                expectation.fulfill()
            }
        }

        viewModel.selectedImage.value = UIImage(systemName: "photo")
        viewModel.sendImage()

        // Assert
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(loadingStates, [true, false], "isLoading state waiting [true, false]")
    }


}
