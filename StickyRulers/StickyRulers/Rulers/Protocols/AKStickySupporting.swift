//
//  AKStickySupporting.swift
//  StickyRulers
//
//  Created by Alen Korbut on 31.08.15.
//  Copyright (c) 2015 KorbCorp LLC. All rights reserved.
//

import Foundation
import UIKit

struct AKStickySupportingSide : OptionSetType {
    typealias RawValue = UInt
    private var value: UInt = 0
    init(_ value: UInt) { self.value = value }
    init(rawValue value: UInt) { self.value = value }
    init(nilLiteral: ()) { self.value = 0 }
    static var allZeros: AKStickySupportingSide { return self.init(0) }
    static func fromMask(raw: UInt) -> AKStickySupportingSide { return self.init(raw) }
    var rawValue: UInt { return self.value }
    
    func isSideSupporting(side: AKStickySupportingSide) -> Bool {
        return self.intersect(side) == side
    }
    
    static var None: AKStickySupportingSide { return self.init(0) }
    static var Left: AKStickySupportingSide { return AKStickySupportingSide(1 << 0) }
    static var Right: AKStickySupportingSide { return AKStickySupportingSide(1 << 1) }
    static var Top: AKStickySupportingSide { return AKStickySupportingSide(1 << 2) }
    static var Bottom: AKStickySupportingSide { return AKStickySupportingSide(1 << 3) }
    static var MiddleVertical: AKStickySupportingSide { return AKStickySupportingSide(1 << 4) }
    static var MiddleHorizontal: AKStickySupportingSide { return AKStickySupportingSide(1 << 5) }
    
    static var MiddleSides: AKStickySupportingSide { get { return self.MiddleHorizontal.union(self.MiddleVertical) } }
    static var AllSides: AKStickySupportingSide { get { return self.AllSidesWithoutMiddle.union(self.MiddleSides) } }
    static var AllSidesWithoutMiddle: AKStickySupportingSide { get { return self.Left.union(self.Top).union(self.Right).union(self.Bottom) } }
    
    static var VerticalSides: AKStickySupportingSide { get { return self.Left.union(self.Right).union(self.MiddleVertical) } }
    static var HorizontalSides: AKStickySupportingSide { get { return self.Top.union(self.Bottom).union(self.MiddleHorizontal) } }
}


protocol AKStickySupporting: NSCoding {
    func stickyRect() -> CGRect
    func stickySides() -> AKStickySupportingSide
    
    func stickToRect(rect: CGRect)
}