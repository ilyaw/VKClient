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
    
    @IBOutlet weak var imageView: UIImageView!
    
    var photos: [String]!
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

   //     self.view.backgroundColor = .black
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        
        self.imageView.image = UIImage(named: self.photos.first!)
    }
    
    @objc private func handleSwipeGesture(sender: UISwipeGestureRecognizer) {
        
        switch sender.direction{
        case .left:  //влевую сторону
            
            if self.index+1 > self.photos.count-1 {
                self.index = 0
            } else {
                self.index += 1
            }
            self.swipePhoto(direction: .left)
        case .right:
            
            if self.index-1 < 0 {
                self.index = self.photos.count-1
            } else {
                self.index -= 1
            }
            self.swipePhoto(direction: .right)
        default: break
        }
    }
    
    private func swipePhoto(direction: SwipeDirection) {
        
        let offset = self.view.bounds.width
        let swipeOffset = direction == .left ? offset : -offset
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: {_ in

            self.imageView.transform = CGAffineTransform(translationX: swipeOffset, y: 0)
            self.imageView?.image = UIImage(named: self.photos[self.index])
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                self.imageView.transform = .identity
            }, completion: nil)
        })
    }

}
