//
//  CustomTransition.swift
//  VideoSearchDemo
//
//  Created by Vikash Kumar on 29/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

protocol CustomTranstionDelegate: NSObjectProtocol {
    func animationStartFrame()->CGRect
    func animationEndFrame()->CGRect
    func animatingImage()->UIImage?
}

class CustomTranstion: NSObject {
    var animatingView = UIView()
    weak var delegate: CustomTranstionDelegate?
    var duration = 0.5
    
    var startCenter = CGPoint.zero
    
    enum ModelState {
        case present, dismiss, pop
    }
    
    var circleColor: UIColor = .white
    var transitionModelState = ModelState.present

}



extension CustomTranstion : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        if transitionModelState == .present {
            if let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                animatingView = UIView()
                animatingView.frame = delegate?.animationStartFrame() ?? CGRect.zero
                animatingView.backgroundColor = UIColor.red
                presentedView.alpha = 0
                containerView.addSubview(presentedView)
                containerView.addSubview(animatingView)

                UIView.animate(withDuration: duration, animations: {
                    self.animatingView.frame = self.delegate?.animationEndFrame() ?? CGRect.zero
                    presentedView.alpha = 0.6
                }, completion: { (success:Bool) in
                    self.animatingView.removeFromSuperview()
                    presentedView.alpha = 1.0
                    transitionContext.completeTransition(success)
                })
            }
        }else{
            let transitionModeKey = (transitionModelState == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
            
            if let returningView = transitionContext.view(forKey: transitionModeKey) {
                animatingView.frame = delegate?.animationEndFrame() ?? CGRect.zero
                animatingView.backgroundColor  = UIColor.gray
                containerView.addSubview(animatingView)
                returningView.alpha = 0.0
                UIView.animate(withDuration: duration, animations: {
                self.animatingView.frame = self.delegate?.animationStartFrame() ?? .zero
                    if self.transitionModelState == .pop {
                        containerView.insertSubview(returningView, belowSubview: returningView)
                        containerView.insertSubview(self.animatingView, belowSubview: returningView)
                    }
                    
                    
                }, completion: { (success:Bool) in
                    returningView.removeFromSuperview()
                    
                    self.animatingView.removeFromSuperview()
                    
                    transitionContext.completeTransition(success)
                    
                })
                
            }
            
        }
        
    }
    

}

