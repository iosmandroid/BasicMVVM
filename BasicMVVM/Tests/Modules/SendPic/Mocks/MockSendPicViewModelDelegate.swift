//
//  MockImagePickerService.swift
//  BasicMVVM
//
//  Created by otto on 11.06.2025.
//

import UIKit
@testable import BasicMVVM

final class MockSendPicViewModelDelegate: SendPicViewModelDelegate {
    var simulatedImage: UIImage?

    func presentImagePicker(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            completion(self.simulatedImage)
        }
    }
}
