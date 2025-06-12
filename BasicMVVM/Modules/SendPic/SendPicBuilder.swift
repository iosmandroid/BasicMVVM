//
//  SendPicBuilder.swift
//  BasicMVVM
//
//  Created by otto on 5.06.2025.
//

import UIKit

enum SendPicBuilder {
    static func build() -> UIViewController {
        let imagePickerService = DefaultImagePickerService()
        let imageUploadManager = DefaultImageUploadManager()
        let viewModel = SendPicViewModel(imageUploadManager: imageUploadManager)
        let viewController = SendPicViewController(viewModel: viewModel,
                                                   imagePickerService: imagePickerService)
        return viewController
    }
}

