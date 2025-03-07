//
//  BAProfileViewController.swift
//  Bump
//
//  Created by Tim Wong on 8/30/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import AVKit
import Photos
import ReactiveCocoa
import ReactiveSwift

class ProfileBaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    struct Constants {
        static let cellIdentifier = "ProfileDetailValueTableViewCellIdentifier"
        
        static let nameIndex = 0
        static let emailIndex = 1
    }
    
    var successCallback: EmptyHandler?
    
    let user: User
    
    let image = MutableProperty<UIImage?>(nil)
    let name = MutableProperty<String?>(nil)
    let email = MutableProperty<String?>(nil)
    
    let imageDidUpdate = MutableProperty<Bool>(false)
    
    var originalProfileFrame: CGRect?
    
    let profileView: ProfileView = {
        let view = ProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var disposables = CompositeDisposable()
    
    init(user: User) {
        self.user = user
        name.value = user.name
        email.value = user.email
        
        super.init(nibName: nil, bundle: nil)
        
        user.loadImage(success: { image in
            self.image.value = image
        }, failure: {_ in
            self.image.value = .blankAvatarLight
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        disposables.dispose()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disposables += (profileView.avatarImageView.imageView.reactive.image <~ self.image)
        profileView.saveButton.addTarget(self, action: #selector(self.saveProfileView(_:)), for: .touchUpInside)
        profileView.tableView.delegate = self
        profileView.tableView.dataSource = self
        profileView.layer.cornerRadius = 20.0
        profileView.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.avatarPressed(_:)))
        profileView.avatarImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: dismiss
    
    func dismissViewController() {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: save
    
    @objc private func saveProfileView(_ sender: LoadingButton?) {
        user.updateUser(name: name.value ?? "", email: email.value ?? "", success: {
            if self.imageDidUpdate.value, let newImage = self.image.value {
                self.user.updateImage(newImage, success: {
                    self.dismissViewController()
                    self.successCallback?()
                }, failure: { error in
                    self.showLeftMessage("Failed to update user image, please try again.", type: .error)
                })
            }
            else {
                self.dismissViewController()
                self.successCallback?()
            }
        }) { _ in
            self.showLeftMessage("Failed to update info", type: .error, view: self.profileView)
        }
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as? ProfileDetailValueTableViewCell ?? ProfileDetailValueTableViewCell(style: .default, reuseIdentifier: Constants.cellIdentifier)
        
        let attributes: [NSAttributedString.Key : Any] = [.foregroundColor :  UIColor.Grayscale.placeholderColor]
        
        cell.detailLabel.isHidden = false
        cell.accountHolderView.isHidden = true
        cell.iconLabel.isHidden = true
        cell.textField.isEnabled = true
        cell.textField.delegate = self
        
        switch indexPath.section {
        case Constants.nameIndex:
            cell.detailLabel.text = GlobalStrings.fullName.localized
            cell.textField.attributedPlaceholder = NSAttributedString(string: "Muhammad", attributes: attributes)
            cell.textField.autocapitalizationType = .none
            cell.textField.autocorrectionType = .no
            cell.textField.text = self.name.value
            disposables += (self.name <~ cell.textField.reactive.continuousTextValues)
        case Constants.emailIndex:
            cell.detailLabel.text = GlobalStrings.email.localized
            cell.textField.attributedPlaceholder = NSAttributedString(string: "muhammad.nakmura@ciao.haus", attributes: attributes)
            cell.textField.autocapitalizationType = .words
            cell.textField.autocorrectionType = .default
            cell.textField.text = self.email.value
            disposables += (self.email <~ cell.textField.reactive.continuousTextValues)
        default: break
        }
        
        if indexPath.section == Constants.emailIndex {
            cell.textField.autocapitalizationType = .none
            cell.textField.autocorrectionType = .no
            cell.textField.keyboardType = .emailAddress
        } else {
            cell.textField.keyboardType = .default
        }
        
        return cell
    }
    
    // MARK: text field
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string != " "
    }
    
    //MARK: photo/camera delegate
    
    @objc private func avatarPressed(_ sender: UIGestureRecognizer?) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = profileView.avatarImageView
        alertController.popoverPresentationController?.sourceRect = profileView.avatarImageView.bounds
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { _ in
            let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
            
            if authStatus == .authorized {
                self.showCameraController()
            }
            else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                    if granted {
                        self.showCameraController()
                    }
                })
            }
        }
        let choosePhoto = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            let authStatus = PHPhotoLibrary.authorizationStatus()
            
            if authStatus == .authorized {
                self.showImageController()
            }
            else {
                PHPhotoLibrary.requestAuthorization { newStatus in
                    if newStatus == .authorized {
                        self.showImageController()
                    }
                    else {
                        self.showLeftMessage("Failed to gain access to photo library", type: .error)
                    }
                }
            }
        }
        
        alertController.addAction(cancel)
        alertController.addAction(choosePhoto)
        alertController.addAction(takePhoto)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func showCameraController() {
        let cameraController = UIImagePickerController()
        cameraController.allowsEditing = true
        cameraController.delegate = self
        cameraController.sourceType = .camera
        
        present(cameraController, animated: true, completion: nil)
    }
    
    private func showImageController() {
        let cameraController = UIImagePickerController()
        cameraController.allowsEditing = true
        cameraController.delegate = self
        cameraController.sourceType = .photoLibrary
        
        present(cameraController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage {
            self.image.value = image
            imageDidUpdate.value = true
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
