//
//  CustomNavigationController.swift
//  UserInterface
//
//  Created by Ilya on 24.03.2021.
//

import UIKit

class CustomNavigationController: UINavigationController {

    let interactiveTransition = CustomInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }
}

extension CustomNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        var animatedTransitioning: UIViewControllerAnimatedTransitioning? = nil
        switch operation {
        case .push:
            self.interactiveTransition.viewController = toVC
            animatedTransitioning = CustomPushAnimator()
            
        case .pop:
            if navigationController.viewControllers.first != toVC {
                self.interactiveTransition.viewController = toVC
            }
            animatedTransitioning = CustomPopAnimator()
            
        default:
            break
        }
        
        return animatedTransitioning
    }
}

