//
//  MockImageUploadManager.swift
//  BasicMVVM
//
//  Created by otto on 13.06.2025.
//

import UIKit
@testable import BasicMVVM

final class MockImageUploadManager: ImageUploadManagerProtocol {
    var didCallUpload = false
    var shouldReturnError = false
    var uploadedImage: UIImage?

    func uploadImage(_ image: UIImage?, completion: @escaping (Result<String, Error>) -> Void) {
        didCallUpload = true
        uploadedImage = image
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.shouldReturnError {
                completion(.failure(NSError(domain: "upload", code: -1)))
            } else {
                completion(.success("upload_success"))
            }
        }
    }
}
