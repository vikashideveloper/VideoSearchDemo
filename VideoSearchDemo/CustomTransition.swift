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
    var duration = 0.3
    
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
                let imageView = UIImageView(frame: animatingView.bounds)
                imageView.image = delegate?.animatingImage()

                animatingView.addSubview(imageView)
                containerView.addSubview(presentedView)
                containerView.addSubview(animatingView)

                UIView.animate(withDuration: duration, animations: {
                    self.animatingView.frame = self.delegate?.animationEndFrame() ?? CGRect.zero
                    imageView.frame = self.animatingView.bounds
                }, completion: { (success:Bool) in
                    UIView.animate(withDuration: 0.2, animations: {
                        presentedView.alpha = 1.0
                    }, completion: { (success:Bool) in
                        self.animatingView.removeFromSuperview()
                    })
                    transitionContext.completeTransition(success)
                })
            }
        }else{
            let transitionModeKey = (transitionModelState == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
            
            if let returningView = transitionContext.view(forKey: transitionModeKey) {
                animatingView.frame = delegate?.animationEndFrame() ?? CGRect.zero
                animatingView.backgroundColor  = UIColor.gray
                animatingView.subviews.forEach({v in v.removeFromSuperview()})
                let imageView = UIImageView(frame: animatingView.bounds)
                imageView.image = delegate?.animatingImage()
                animatingView.addSubview(imageView)

                containerView.addSubview(animatingView)
                returningView.alpha = 0.0
                UIView.animate(withDuration: duration, animations: {
                    self.animatingView.frame = self.delegate?.animationStartFrame() ?? .zero
                    imageView.frame = self.animatingView.bounds
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

