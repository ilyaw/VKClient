//
//  FriendsPhotoViewController.swift
//  UserInterface
//
//  Created by Илья Руденко on 19.03.2021.
//

import UIKit

//swipe 
class FriendsPhotoViewController: UIViewController {

    enum SwipeDirection {
        case left
        case right
    }
 
    private let photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let buttonsActionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let likeControl: LikeControl = {
        let control = LikeControl(frame: .zero)
        return control
    }()
    
    private let commentControl: CommentButton = {
        let control = CommentButton(frame: .zero)
        return control
    }()
    
    private let shareControl: ShareControl = {
        let control = ShareControl(frame: .zero)
        return control
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.compact.down"), for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return button
    }()
    
    @objc private func didTapClose() {
        let transition: CATransition = CATransition()
        transition.duration = 0.8
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.window!.layer.add(transition, forKey: nil)

        self.dismiss(animated: false, completion: nil)
    }
    
    private let photoService = PhotoService.shared
    private var photos: [PhotoItem]!
    private var currentIndex: Int = 0
    
    private var safeArea: UILayoutGuide {
        return view.safeAreaLayoutGuide
    }

    
    init(photos: [PhotoItem], currentIndex: Int) {
        self.photos = photos
        self.currentIndex = currentIndex
    
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setGesture()
        showPhoto()
    }
  
    private func setUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(closeButton)
        self.view.addSubview(photoView)
        self.view.addSubview(buttonsActionStackView)
        
        buttonsActionStackView.addArrangedSubview(likeControl)
        buttonsActionStackView.addArrangedSubview(commentControl)
        buttonsActionStackView.addArrangedSubview(shareControl)
        
        self.addCloseButtonnConstraints()
        self.addPhotoViewConstraints()
        self.addButtonsActionStackViewConstraints()
    }
    
    private func addCloseButtonnConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            closeButton.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 0),
            closeButton.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: 0),
            closeButton.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    private func addPhotoViewConstraints() {
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
            photoView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 0),
            photoView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: 0),
            photoView.bottomAnchor.constraint(equalTo: buttonsActionStackView.topAnchor, constant: -10),
        ])
    }
    
    private func addButtonsActionStackViewConstraints() {
        NSLayoutConstraint.activate([
            buttonsActionStackView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 10),
            buttonsActionStackView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -10),
            buttonsActionStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0),
            buttonsActionStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    

    private func setGesture() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
    }

    private func showPhoto() {
        updateInfoButtons()
        if let photo = self.photos[currentIndex].sizes.last {
            photoService.photo(urlString: photo.url)
                .done { [weak self] image in
                    self?.photoView.image = image
                }
                .catch { print($0.localizedDescription) }
        }
    }
    
    private func updateInfoButtons() {
        let photo = self.photos[currentIndex]
        
        let likesCount = photo.likes?.count ?? 0
        let isLike = photo.likes?.isLike ?? false
        let commentsCount = photo.comments?.count ?? 0
        let shareCount = photo.reposts?.count ?? 0
        
        likeControl.setLikeInfo(count: likesCount, isLike: isLike)
        commentControl.setComment(count: commentsCount)
        shareControl.setShare(count: shareCount)
    }
    
    @objc private func handleSwipeGesture(sender: UISwipeGestureRecognizer) {
        switch sender.direction{
        case .left:
            if self.currentIndex+1 > self.photos.count-1 {
                self.currentIndex = 0
            } else {
                self.currentIndex += 1
            }
            self.swipePhoto(direction: .left)
        case .right:
            if self.currentIndex-1 < 0 {
                self.currentIndex = self.photos.count-1
            } else {
                self.currentIndex -= 1
            }
            self.swipePhoto(direction: .right)
        default: break

        }
    }
    
    private func swipePhoto(direction: SwipeDirection) {
        
        let offset = self.view.bounds.width
        let swipeOffset = direction == .left ? offset : -offset
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.photoView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: { [weak self] _ in
            
            self?.photoView.image = nil
            self?.photoView.transform = CGAffineTransform(translationX: swipeOffset, y: 0)
            
            self?.showPhoto()
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                self?.photoView.transform = .identity
            }, completion: nil)
        })
    }

}
