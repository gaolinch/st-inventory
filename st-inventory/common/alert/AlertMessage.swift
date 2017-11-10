//
//  AlertMessage.swift
//  comedy_speed_dating
//
//  Created by Christophe Danguien on 2017/08/20.
//  Copyright © 2017 Comedy Speed Dating. All rights reserved.
//

import UIKit

class AlertMessage: NSObject
{
    // MARK: - class constants
    private static let MARGIN:CGFloat = 10.0
    
    public enum Position
    {
        /**
         Message view slides down from the top.
         */
        case top
        
        /**
         Message view slides up from the bottom.
         */
        case bottom
        
        /**
         Message view fades into the center.
         */
        case center
    }
    
    public enum Timing
    {
        /**
         Message view slides down from the top.
         */
        case short
        
        /**
         Message view slides up from the bottom.
         */
        case medium
        
        /**
         Message view fades into the center.
         */
        case forever
    }
    
    // MARK: - class attribute
    private static var s_alerts:[AlertConfig] = []
    
    private static var s_view_dimmed:UIView?
    
    static func show(view:UIView) -> Void
    {
        // Screen Size
        let screen:CGRect = UIScreen.main.bounds
        
        let maxWidthView:CGFloat = screen.width - (2.0 * MARGIN)
        let maxHeightView:CGFloat = screen.height - (2.0 * MARGIN)
        
        var viewWidth:CGFloat = view.frame.width
        var viewHeight:CGFloat = view.frame.height
        
        if viewWidth > maxWidthView
        {
            viewWidth = maxWidthView
        }
        
        if viewHeight > maxHeightView
        {
            viewHeight = maxHeightView
        }
        
        let viewX:CGFloat = (screen.width * 0.5) - (viewWidth * 0.5)
        let viewY:CGFloat = (screen.height * 0.5) - (viewHeight * 0.5)
        
        view.frame = CGRect(x: viewX, y: viewY, width: viewWidth, height: viewHeight)
        
        // Dim View Down
        if s_view_dimmed?.superview != nil
        {
            s_view_dimmed?.removeFromSuperview()
        }
        
        s_view_dimmed = UIView()
        s_view_dimmed?.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
        s_view_dimmed?.frame = CGRect(x: 0.0, y: 0.0, width: screen.width, height: screen.height)
        
        print(view.frame)
        
        let window:UIWindow? = UIApplication.shared.keyWindow
        
        if window != nil
        {
            let newConfig:AlertConfig = AlertConfig()
            newConfig._message_view = view
            newConfig._position = Position.center
            newConfig._timing = Timing.forever

            self.s_alerts.append(newConfig)
            
            window!.addSubview(s_view_dimmed!)
            window!.addSubview(view)
            // Now we center the view
            // Animate
            s_view_dimmed!.alpha = 0.0
            view.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            
            UIView.animate(withDuration: 0.3, animations: {
                s_view_dimmed!.alpha = 1.0
                view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }
    }
    
    static func show(view:UIView, config:AlertConfig) -> Void
    {
        // Remove previous
        if s_alerts.count > 0
        {
            closeNow()
        }
        // Screen Size
        let screen:CGRect = UIScreen.main.bounds
        
        let maxWidthView:CGFloat = screen.width - (2.0 * MARGIN)
        let maxHeightView:CGFloat = screen.height - (2.0 * MARGIN)
        
        var viewWidth:CGFloat = view.frame.width
        var viewHeight:CGFloat = view.frame.height
        
        if viewWidth > maxWidthView
        {
            viewWidth = maxWidthView
        }
        
        if viewHeight > maxHeightView
        {
            viewHeight = maxHeightView
        }
        
        let viewX:CGFloat = (screen.width * 0.5) - (viewWidth * 0.5)
        var viewY:CGFloat = (screen.height * 0.5) - (viewHeight * 0.5)
        
        if config._position == Position.top
        {
            viewY = 0.0 - MARGIN - viewHeight
        }
        else if config._position == Position.bottom
        {
            viewY = screen.height + MARGIN
        }
        
        view.frame = CGRect(x: viewX, y: viewY, width: viewWidth, height: viewHeight)
        
        // Dim View Down
        if s_view_dimmed?.superview != nil
        {
            s_view_dimmed?.removeFromSuperview()
            s_view_dimmed = nil
        }
        
        print(view.frame)
        
        let window:UIWindow? = UIApplication.shared.keyWindow
        
        if window != nil
        {
            config._message_view = view
            
            self.s_alerts.append(config)
            
            window!.addSubview(view)
            
            if config._position == Position.center
            {
                view.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }
            // Animate
            UIView.animate(withDuration: 0.3, animations: {
                if config._position == Position.top
                {
                    view.frame = CGRect(x: view.frame.origin.x, y: 2 * MARGIN, width: view.frame.size.width, height: view.frame.size.height)
                }
                else if config._position == Position.bottom
                {
                    let finalY:CGFloat = screen.height - viewHeight - (2 * MARGIN)
                    view.frame = CGRect(x: view.frame.origin.x, y: finalY, width: view.frame.size.width, height: view.frame.size.height)
                }
                else
                {
                    view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            }, completion:
                {
                    finished in
                    // clean up & revert all the temporary things
                    if config._timing == Timing.short
                    {
                        self.perform(#selector(AlertMessage.close), with: nil, afterDelay: 2.0)
                    }
                    else if config._timing == Timing.medium
                    {
                        self.perform(#selector(AlertMessage.close), with: nil, afterDelay: 5.0)
                    }
            })
        }
    }
    
    @objc static func close() -> Void
    {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute:
            {
                let config:AlertConfig? = s_alerts.popLast()
                if config != nil
                {
                    let screen:CGRect = UIScreen.main.bounds
                    let messageView:UIView = config!._message_view!
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        if config!._position == Position.top
                        {
                            messageView.frame = CGRect(x: messageView.frame.origin.x, y: 0.0 - messageView.frame.size.height - MARGIN, width: messageView.frame.size.width, height: messageView.frame.size.height)
                        }
                        else if config!._position == Position.bottom
                        {
                            messageView.frame = CGRect(x: messageView.frame.origin.x, y: screen.height + MARGIN, width: messageView.frame.size.width, height: messageView.frame.size.height)
                        }
                        else
                        {
                            messageView.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
                        }
                        
                        if s_view_dimmed != nil
                        {
                            s_view_dimmed?.alpha = 0.0
                        }
                    }, completion:
                        {
                            finished in
                            // clean up & revert all the temporary things
                            if s_view_dimmed != nil
                            {
                                s_view_dimmed?.removeFromSuperview()
                                s_view_dimmed = nil
                            }
                            
                            let messageView:UIView = config!._message_view!
                            messageView.removeFromSuperview()
                            
                            config?._message_view = nil
                    })
                }
        })
    }
    
    static func closeNow() -> Void
    {
        let config:AlertConfig? = s_alerts.popLast()
        if config != nil
        {
            let messageView:UIView = config!._message_view!
            messageView.removeFromSuperview()
            
            config?._message_view = nil
        }
        
        if s_view_dimmed != nil
        {
            s_view_dimmed?.removeFromSuperview()
            s_view_dimmed = nil
        }
    }
}
