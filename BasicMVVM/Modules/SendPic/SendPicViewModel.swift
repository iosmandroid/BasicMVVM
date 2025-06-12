//
//  SendPicViewModel.swift
//  BasicMVVM
//
//  Created by otto on 4.06.2025.
//

import UIKit

// MARK: - Input Protocol
protocol SendPicViewModelInput {
    func selectImage()
    func sendImage()
}

// MARK: - Output Protocol
protocol SendPicViewModelOutput {
    var selectedImage: Bindable<UIImage?> { get }
    
    var isLoading: Bindable<Bool> { get set }
    var onError: ((String) -> Void)? { get set }
    var onSuccess: ((String) -> Void)? { get set }
}

typealias SendPicViewModelProtocol = SendPicViewModelInput & SendPicViewModelOutput

protocol SendPicViewModelDelegate: AnyObject {
    func presentImagePicker(completion: @escaping (UIImage?) -> Void)
}

final class SendPicViewModel: SendPicViewModelProtocol {
    
    weak var delegate: SendPicViewModelDelegate?

    var imageUploadManager: ImageUploadManagerProtocol?
    
    init(imageUploadManager: ImageUploadManagerProtocol? = nil) {
        self.imageUploadManager = imageUploadManager
    }
    
    var isLoading: Bindable<Bool> = .init(wrappedValue: false)
    var onSuccess: ((String) -> Void)?
    var onError: ((String) -> Void)?
    var selectedImage: Bindable<UIImage?> = .init(wrappedValue: nil)

    func sendImage() {
        isLoading.value = true
        imageUploadManager?.uploadImage(self.selectedImage.value) { [weak self] result in
            self?.isLoading.value = false
            switch result {
            case .success(let success):
                self?.onSuccess?(success)
            case .failure(let failure):
                self?.onError?(failure.localizedDescription)
            }
        }
    }

    func selectImage() {
        delegate?.presentImagePicker { [weak self] image in
            guard let self = self else { return }
            if let image = image {
                self.selectedImage.value = image
            } else {
                self.onError?("Image is not selected.")
            }
        }
    }
}

