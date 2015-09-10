//
//  UIView+Sticky.swift
//  StickyRulers
//
//  Created by Alen Korbut on 31.08.15.
//  Copyright (c) 2015 KorbCorp LLC. All rights reserved.
//

import Foundation
import UIKit

extension UIView: AKStickyProvider, AKStickySupporting {

    //MARK: - AKStickySupporting -
    
    func stickyRect() -> CGRect {
        return frame
    }
    func stickySides() -> AKStickySupportingSide {
        return AKStickySupportingSide.AllSides
    }
    func stickToRect(rect: CGRect) {
        frame = rect
    }
    
    
    //MARK: - AKStickyProvider -
    
    func provideToCheckSide() -> AKStickyProviderSide {
        return AKStickyProviderSide.Both
    }
    func checkForSticky(stickySupporting: AKStickySupporting, ignoreStickSide: AKStickyProviderSide) -> AKStickInfo {
        let stickyObject = AKStickyObject(object: self)
        return stickyObject.checkForSticky(stickySupporting, ignoreStickSide: ignoreStickSide)
    }
}