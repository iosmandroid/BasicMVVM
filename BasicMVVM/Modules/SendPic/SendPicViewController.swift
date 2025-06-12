//
//  SendPicViewController.swift
//  BasicMVVM
//
//  Created by otto on 4.06.2025.
//

import UIKit
import SnapKit

extension SendPicViewController: SendPicViewModelDelegate {
    func presentImagePicker(completion: @escaping (UIImage?) -> Void) {
        imagePickerService.presentPicker(from: self, completion: completion)
    }
}

final class SendPicViewController: UIViewController {

    private var viewModel: SendPicViewModelProtocol
    private let imagePickerService: ImagePickerServiceProtocol

    private lazy var previewImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGray
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var uploadButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Upload", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(handleUpload), for: .touchUpInside)
        return btn
    }()
    
    private lazy var selectButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Select", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(handleSelect), for: .touchUpInside)
        return btn
    }()
    
    init(viewModel: SendPicViewModelProtocol, imagePickerService: ImagePickerServiceProtocol) {
        self.viewModel = viewModel
        self.imagePickerService = imagePickerService
        super.init(nibName: nil, bundle: nil)
        
        if let vm = viewModel as? SendPicViewModel {
            vm.delegate = self
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
        bindViewModel()
    }
    
    private func setupUI() {
        setPreviewImageView()
        setUploadButton()
        setSelectButton()
    }
    
    private func configure() {
        configurePreviewImageView()
    }
    
    private func configurePreviewImageView() {
        previewImageView.image = UIImage(systemName: "photo.fill")
    }
    
    private func setPreviewImageView() {
        view.addSubview(previewImageView)
        previewImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func setUploadButton() {
        view.addSubview(uploadButton)
        uploadButton.snp.makeConstraints {
            $0.left.bottom.equalToSuperview().inset(20)
            $0.top.equalTo(previewImageView.snp.bottom).inset(-12)
            $0.width.equalToSuperview().multipliedBy(0.4)
            $0.height.equalTo(44)
        }
    }

    private func setSelectButton() {
        view.addSubview(selectButton)
        selectButton.snp.makeConstraints {
            $0.right.bottom.equalToSuperview().inset(20)
            $0.top.equalTo(previewImageView.snp.bottom).inset(-12)
            $0.width.equalToSuperview().multipliedBy(0.4)
            $0.height.equalTo(44)
        }
    }
    
    private func bindViewModel() {
        viewModel.isLoading.bind(skipInitial: true) { [weak self] isLoading in
            if isLoading {
                print("Loading...")
            } else {
                print("Loading Over.")
            }
        }
        
        viewModel.onSuccess = { [weak self] message in
            print("Success status:" + message)
        }
        
        viewModel.onError = { [weak self] error in
            print("Error: \(error)")
        }
        
        viewModel.selectedImage.bind { [weak self] image in
            guard let image, let self else { return }
            self.previewImageView.image = image
        }
    }
}

// MARK: - Handle Actions
extension SendPicViewController {
    @objc func handleUpload() {
        viewModel.sendImage()
    }
    
    @objc func handleSelect() {
        viewModel.selectImage()
    }
}
