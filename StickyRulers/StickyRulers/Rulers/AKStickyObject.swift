//
//  AKStickyObject.swift
//  StickyRulers
//
//  Created by Alen Korbut on 31.08.15.
//  Copyright (c) 2015 KorbCorp LLC. All rights reserved.
//

import Foundation
import UIKit

let kStickySupportingObject = "stickySupportingObj"
let kProviderManager = "providerComposite"

class AKStickyObject: NSObject, AKStickyProvider {
    var object: AKStickySupporting!
    var providerManager: AKStickyProviderManager!
    
    init(object: AKStickySupporting) {
        self.object = object
        self.providerManager = AKStickyProviderManager()
        
        let fr = object.stickyRect()
        let sides = object.stickySides()
        if sides.isSideSupporting(AKStickySupportingSide.Left) {
            let ruler = AKStickyVerticalRuler(location: Int(fr.origin.x))
            providerManager.addStickyProvider(ruler)
        }
        if sides.isSideSupporting(AKStickySupportingSide.Right) {
            let ruler = AKStickyVerticalRuler(location: Int(CGRectGetMaxX(fr)))
            providerManager.addStickyProvider(ruler)
        }
        if sides.isSideSupporting(AKStickySupportingSide.MiddleVertical) {
            let ruler = AKStickyVerticalRuler(location: Int(CGRectGetMidX(fr)))
            providerManager.addStickyProvider(ruler)
        }
        if sides.isSideSupporting(AKStickySupportingSide.Top) {
            let ruler = AKStickyHorizontalRuler(location: Int(fr.origin.y))
            providerManager.addStickyProvider(ruler)
        }
        if sides.isSideSupporting(AKStickySupportingSide.Bottom) {
            let ruler = AKStickyHorizontalRuler(location: Int(CGRectGetMaxY(fr)))
            providerManager.addStickyProvider(ruler)
        }
        if sides.isSideSupporting(AKStickySupportingSide.MiddleHorizontal) {
            let ruler = AKStickyHorizontalRuler(location: Int(CGRectGetMidY(fr)))
            providerManager.addStickyProvider(ruler)
        }
    }
    
    func provideToCheckSide() -> AKStickyProviderSide {
        return AKStickyProviderSide.Both
    }
    func checkForSticky(stickySupporting: AKStickySupporting, ignoreStickSide: AKStickyProviderSide) -> AKStickInfo {
        return providerManager.checkForSticky(stickySupporting, ignoreStickSide: ignoreStickSide)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(object, forKey: kStickySupportingObject)
        aCoder.encodeObject(providerManager, forKey: kProviderManager)
    }
    required init?(coder aDecoder: NSCoder) {
        if let obj = aDecoder.decodeObjectForKey(kStickySupportingObject) as? AKStickySupporting {
            object = obj
        }
        if let obj = aDecoder.decodeObjectForKey(kProviderManager) as? AKStickyProviderManager {
            providerManager = obj
        }
    }
}