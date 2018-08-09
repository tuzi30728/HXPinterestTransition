//
//  HXPinterestTransition.swift
//  HXPinterestTransitionDemo
//
//  Created by HongXiangWen on 2018/8/8.
//  Copyright © 2018年 WHX. All rights reserved.
//

import UIKit

// MARK: -  要实现转场动画的ViewController必须遵守此协议
protocol HXPinterestTransitionView {
    func fromTransitionView() -> UIView?
    func toTransitionView() -> UIView?
}

class HXPinterestTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let animationType: HXNavigationTransitionAnimationType
    
    init(_ animationType: HXNavigationTransitionAnimationType) {
        self.animationType = animationType
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch animationType {
        case .push:
            pushAnimateTransition(using: transitionContext)
        case .pop:
            popAnimateTransition(using: transitionContext)
        default:
            break
        }
    }
    
    /// push
    private func pushAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        /// 首先对参数进行校验
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromTargetView = (fromVC as? HXPinterestTransitionView)?.fromTransitionView(),
            let toTargetView = (toVC as? HXPinterestTransitionView)?.toTransitionView() else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
        }
        let containerView = transitionContext.containerView
        /// 计算动画view的初始frame和结束frame
        let fromFrame = fromTargetView.convert(fromTargetView.bounds, to: UIApplication.shared.keyWindow)
        let toFrame = toTargetView.convert(toTargetView.bounds, to: UIApplication.shared.keyWindow)
        let animationScale = toFrame.width / fromFrame.width
        let toScale = 1 / animationScale
        /// 定义一个UIImageView来做动画
        let snapImageView = UIImageView(image: fromTargetView.getScreenImage())
        snapImageView.frame = fromFrame
        /// 设置动画的初始状态
        toVC.view.alpha = 0
        toVC.view.transform = CGAffineTransform(scaleX: toScale, y: toScale)
        toVC.view.frame.origin = CGPoint(x: -toFrame.origin.x * toScale + fromFrame.origin.x, y: -toFrame.origin.y * toScale + fromFrame.origin.y)
        /// 添加一个白背景
        let bgView = UIView(frame: UIScreen.main.bounds)
        bgView.backgroundColor = .white
        /// 添加相应的view
        containerView.addSubview(bgView)
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        containerView.addSubview(snapImageView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: {
            /// 1. 放大snapImageView，并使snapImageView的frame.origin处于一个正确的位置
            snapImageView.transform = CGAffineTransform(scaleX: animationScale, y: animationScale)
            snapImageView.frame.origin = toFrame.origin
            /// 2. 同时放大fromVC.view，并使fromVC.view的frame.origin处于一个正确的位置, 并改变透明度
            fromVC.view.alpha = 0
            fromVC.view.transform = CGAffineTransform(scaleX: animationScale, y: animationScale)
            fromVC.view.frame.origin = CGPoint(x: -fromFrame.origin.x * animationScale + toFrame.origin.x, y: -fromFrame.origin.y * animationScale + toFrame.origin.y)
            /// 3. 还原toVC.view的状态
            toVC.view.alpha = 1
            toVC.view.transform = CGAffineTransform.identity
            toVC.view.frame = UIScreen.main.bounds
        }) { (_) in
            /// 动画结束，移除多余的view
            bgView.removeFromSuperview()
            snapImageView.removeFromSuperview()
            /// 还原fromVC.view的状态
            fromVC.view.alpha = 1
            fromVC.view.transform = CGAffineTransform.identity
            fromVC.view.frame = UIScreen.main.bounds
            /// 结束动画
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
    /// pop
    private func popAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromTargetView = (fromVC as? HXPinterestTransitionView)?.toTransitionView(),
            let toTargetView = (toVC as? HXPinterestTransitionView)?.fromTransitionView() else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
        }
        let containerView = transitionContext.containerView
        
        let fromFrame = fromTargetView.convert(fromTargetView.bounds, to: UIApplication.shared.keyWindow)
        let toFrame = toTargetView.convert(toTargetView.bounds, to: UIApplication.shared.keyWindow)
        let animationScale = fromFrame.width / toFrame.width
        
        let snapImageView = UIImageView(image: toTargetView.getScreenImage())
        snapImageView.frame = toFrame
        snapImageView.transform = CGAffineTransform(scaleX: animationScale, y: animationScale)
        snapImageView.frame.origin = fromFrame.origin
        
        toVC.view.transform = CGAffineTransform(scaleX: animationScale, y: animationScale)
        toVC.view.frame.origin = CGPoint(x: -toFrame.origin.x * animationScale + fromFrame.origin.x, y: -toFrame.origin.y * animationScale + fromFrame.origin.y)
        
        let bgView = UIView(frame: UIScreen.main.bounds)
        bgView.backgroundColor = .white
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(bgView)
        containerView.addSubview(snapImageView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: {
            snapImageView.transform = CGAffineTransform.identity
            snapImageView.frame.origin = toFrame.origin
            toVC.view.transform = CGAffineTransform.identity
            toVC.view.frame = UIScreen.main.bounds
            bgView.alpha = 0
        }) { (_) in
            snapImageView.removeFromSuperview()
            bgView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}

// MARK: -  为转场类定制的manager
class HXPinterestTransitionManager: NSObject, UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        /// 如果fromVC和toVC都遵守HXPinterestTransitionView协议，就使用Pinterest转场动画，否则使用系统转场动画
        guard let _ = fromVC as? HXPinterestTransitionView, let _ = toVC as? HXPinterestTransitionView else { return nil }
        switch operation {
        case .push:
            return HXPinterestTransition(.push)
        case .pop:
            return HXPinterestTransition(.pop)
        case .none:
            return nil
        }
    }
    
}












