//
//  AKStickyRuler.swift
//  StickyRulers
//
//  Created by Alen Korbut on 31.08.15.
//  Copyright (c) 2015 KorbCorp LLC. All rights reserved.
//

import Foundation
import UIKit

let kStickyZone = "zone"
let kLocation = "location"

class AKStickyRuler: NSObject, AKStickyProvider {
    private var _stickyZone: Int = 5
    var stickyZone: Int { get { return _stickyZone } }
    
    private var location: Int
    
    init(location: Int) {
        self.location = location
    }
    
    func provideToCheckSide() -> AKStickyProviderSide {
        return AKStickyProviderSide.None
    }
    func checkForSticky(stickySupporting: AKStickySupporting, ignoreStickSide: AKStickyProviderSide) -> AKStickInfo {
        return AKStickInfo(provider: self, side: AKStickyProviderSide.None)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(stickyZone, forKey: kStickyZone)
        aCoder.encodeInteger(location, forKey: kLocation)
    }
    required init(coder aDecoder: NSCoder) {
        _stickyZone = aDecoder.decodeIntegerForKey(kStickyZone)
        location = aDecoder.decodeIntegerForKey(kLocation)
    }
}

class AKStickyVerticalRuler: AKStickyRuler {
    var xLocation: Int { get { return location } }
    override func provideToCheckSide() -> AKStickyProviderSide {
        return AKStickyProviderSide.Vertical
    }
    override func checkForSticky(stickySupporting: AKStickySupporting, ignoreStickSide: AKStickyProviderSide) -> AKStickInfo {
        if ignoreStickSide == provideToCheckSide() || ignoreStickSide == AKStickyProviderSide.Both {
            return super.checkForSticky(stickySupporting, ignoreStickSide: ignoreStickSide)
        }
        
        let stickyRect = stickySupporting.stickyRect()
        let sides: AKStickySupportingSide = stickySupporting.stickySides()
        var res = AKStickyProviderSide.None
        let loc = xLocation
        
        var stickFr = stickyRect
        
        if sides.isSideSupporting(AKStickySupportingSide.Left) {
            let checkX = stickyRect.origin.x
            let sp = abs(loc - Int(checkX))
            if sp <= stickyZone {
                stickFr.origin.x = CGFloat(loc)
            }
        }
        if res == AKStickyProviderSide.None && sides.isSideSupporting(AKStickySupportingSide.MiddleVertical) {
            let checkX = CGRectGetMidX(stickyRect)
            let sp = abs(loc - Int(checkX))
            if sp <= stickyZone {
                stickFr.origin.x = CGFloat(loc) - stickFr.size.width/2
            }
        }
        if res == AKStickyProviderSide.None && sides.isSideSupporting(AKStickySupportingSide.Right) {
            let checkX = CGRectGetMaxX(stickyRect)
            let sp = abs(loc - Int(checkX))
            if sp <= stickyZone {
                stickFr.origin.x = CGFloat(loc) - stickFr.size.width
            }
        }
        
        if !CGRectEqualToRect(stickyRect, stickFr) {
            res = AKStickyProviderSide.Vertical
            stickySupporting.stickToRect(stickFr)
        }
        
        return AKStickInfo(provider: self, side: res)
    }
}

class AKStickyHorizontalRuler: AKStickyRuler {
    var yLocation: Int { get { return location } }
    override func provideToCheckSide() -> AKStickyProviderSide {
        return AKStickyProviderSide.Horizontal
    }
    override func checkForSticky(stickySupporting: AKStickySupporting, ignoreStickSide: AKStickyProviderSide) -> AKStickInfo {
        if ignoreStickSide == provideToCheckSide() || ignoreStickSide == AKStickyProviderSide.Both {
            return super.checkForSticky(stickySupporting, ignoreStickSide: ignoreStickSide)
        }
        
        let stickyRect = stickySupporting.stickyRect()
        let sides: AKStickySupportingSide = stickySupporting.stickySides()
        var res = AKStickyProviderSide.None
        let loc = yLocation
        
        var stickFr = stickyRect
        
        if sides.isSideSupporting(AKStickySupportingSide.Top) {
            let sp = abs(loc - Int(stickyRect.origin.y))
            if sp <= stickyZone {
                stickFr.origin.y = CGFloat(loc)
            }
        }
        if res == AKStickyProviderSide.None && sides.isSideSupporting(AKStickySupportingSide.MiddleHorizontal) {
            let sp = abs(loc - Int(CGRectGetMidY(stickyRect)))
            if sp <= stickyZone {
                stickFr.origin.y = CGFloat(loc) - stickFr.size.height/2
            }
        }
        if res == AKStickyProviderSide.None && sides.isSideSupporting(AKStickySupportingSide.Bottom) {
            let sp = abs(loc - Int(CGRectGetMaxY(stickyRect)))
            if sp <= stickyZone {
                stickFr.origin.y = CGFloat(loc) - stickFr.size.height
            }
        }
        
        if !CGRectEqualToRect(stickyRect, stickFr) {
            res = AKStickyProviderSide.Horizontal
            stickySupporting.stickToRect(stickFr)
        }
        
        return AKStickInfo(provider: self, side: res)
    }
}