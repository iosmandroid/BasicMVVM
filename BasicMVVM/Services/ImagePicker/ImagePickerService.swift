//
//  ImagePickerService.swift
//  BasicMVVM
//
//  Created by otto on 5.06.2025.
//

import UIKit

protocol ImagePickerServiceProtocol {
    func presentPicker(from viewController: UIViewController, completion: @escaping (UIImage?) -> Void)
}

final class DefaultImagePickerService: NSObject, ImagePickerServiceProtocol {
    
    private var pickerDelegate: PickerDelegateWrapper?
    
    func presentPicker(from viewController: UIViewController, completion: @escaping (UIImage?) -> Void) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        let wrapper = PickerDelegateWrapper { [weak self] image in
            completion(image)
        }
        picker.delegate = wrapper
        pickerDelegate = wrapper
        viewController.present(picker, animated: true)
    }
}
