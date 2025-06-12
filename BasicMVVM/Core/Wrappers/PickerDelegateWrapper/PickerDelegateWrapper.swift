//
//  PickerDelegateWrapper.swift
//  BasicMVVM
//
//  Created by otto on 11.06.2025.
//

import UIKit

final class PickerDelegateWrapper: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let completion: (UIImage?) -> Void
    
    init(completion: @escaping (UIImage?) -> Void) {
        self.completion = completion
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        let image = info[.originalImage] as? UIImage
        completion(image)
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        completion(nil)
        picker.dismiss(animated: true)
    }
}
