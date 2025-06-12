//
//  ImageUploadService.swift
//  BasicMVVM
//
//  Created by otto on 10.06.2025.
//

import Foundation
import UIKit

protocol ImageUploadManagerProtocol {
    func uploadImage(_ image: UIImage?, completion: @escaping (Result<String, Error>) -> Void)
}

final class DefaultImageUploadManager: ImageUploadManagerProtocol {
    func uploadImage(_ image: UIImage?, completion: @escaping (Result<String, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let isSuccess = Bool.random()
            
            if isSuccess {
                completion(.success("Image uploaded successfully."))
            } else {
                let error = NSError(domain: "ImageUploadServiceErrorDomain", code: 500, userInfo: [NSLocalizedDescriptionKey : "Upload image failed."])
                completion(.failure(error))
            }
        }
    }
}
