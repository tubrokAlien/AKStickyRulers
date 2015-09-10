//
//  AKStickySupporting.swift
//  StickyRulers
//
//  Created by Alen Korbut on 31.08.15.
//  Copyright (c) 2015 KorbCorp LLC. All rights reserved.
//

import Foundation
import UIKit

struct AKStickySupportingSide : RawOptionSetType {
    typealias RawValue = UInt
    private var value: UInt = 0
    init(_ value: UInt) { self.value = value }
    init(rawValue value: UInt) { self.value = value }
    init(nilLiteral: ()) { self.value = 0 }
    static var allZeros: AKStickySupportingSide { return self(0) }
    static func fromMask(raw: UInt) -> AKStickySupportingSide { return self(raw) }
    var rawValue: UInt { return self.value }
    
    func isSideSupporting(side: AKStickySupportingSide) -> Bool {
        return self & side == side
    }
    
    static var None: AKStickySupportingSide { return self(0) }
    static var Left: AKStickySupportingSide { return AKStickySupportingSide(1 << 0) }
    static var Right: AKStickySupportingSide { return AKStickySupportingSide(1 << 1) }
    static var Top: AKStickySupportingSide { return AKStickySupportingSide(1 << 2) }
    static var Bottom: AKStickySupportingSide { return AKStickySupportingSide(1 << 3) }
    static var MiddleVertical: AKStickySupportingSide { return AKStickySupportingSide(1 << 4) }
    static var MiddleHorizontal: AKStickySupportingSide { return AKStickySupportingSide(1 << 5) }
    
    static var MiddleSides: AKStickySupportingSide { get { return self.MiddleHorizontal | self.MiddleVertical } }
    static var AllSides: AKStickySupportingSide { get { return self.AllSidesWithoutMiddle | self.MiddleSides } }
    static var AllSidesWithoutMiddle: AKStickySupportingSide { get { return self.Left | self.Top | self.Right | self.Bottom } }
    
    static var VerticalSides: AKStickySupportingSide { get { return self.Left | self.Right | self.MiddleVertical } }
    static var HorizontalSides: AKStickySupportingSide { get { return self.Top | self.Bottom | self.MiddleHorizontal } }
}


protocol AKStickySupporting: NSCoding {
    func stickyRect() -> CGRect
    func stickySides() -> AKStickySupportingSide
    
    func stickToRect(rect: CGRect)
}