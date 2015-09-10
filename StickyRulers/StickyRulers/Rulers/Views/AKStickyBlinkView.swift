//
//  AKStickyBlinkView.swift
//  StickyRulers
//
//  Created by Alen Korbut on 02.09.15.
//  Copyright (c) 2015 KorbCorp LLC. All rights reserved.
//

import UIKit

class AKStickyBlinkView: UIView {
    var provider: AKStickyProvider!
    
    init(provider: AKStickyProvider) {
        self.provider = provider
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor.cyanColor()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func blink(completion: (finished: Bool) -> Void) {
        alpha = 0.0
        UIView.animateWithDuration(0.25, animations: { [weak self] () -> Void in
            if let itm = self {
                itm.alpha = 1.0
            }
        }, completion: completion)
    }
    
    private func configFrameByRuler() {
        if let parent = superview {
            if let vertical = provider as? AKStickyVerticalRuler {
                frame = CGRectMake(CGFloat(vertical.xLocation), 0, 1.0, parent.bounds.size.height)
            }
            else if let horizontal = provider as? AKStickyHorizontalRuler {
                frame = CGRectMake(0, CGFloat(horizontal.yLocation), parent.bounds.size.width, 1.0)
            }
        }
    }
    
    override func didMoveToSuperview() {
        configFrameByRuler()
    }
}
