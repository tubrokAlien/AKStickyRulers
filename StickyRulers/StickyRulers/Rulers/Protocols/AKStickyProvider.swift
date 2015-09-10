//
//  AKStickyProvider.swift
//  StickyRulers
//
//  Created by Alen Korbut on 31.08.15.
//  Copyright (c) 2015 KorbCorp LLC. All rights reserved.
//

import Foundation
import UIKit

enum AKStickyProviderSide: Int {
    case None = 0
    case Horizontal = 1
    case Vertical = 2
    case Both = 3    
}

protocol AKStickyProvider: NSCoding {
    func provideToCheckSide() -> AKStickyProviderSide
    func checkForSticky(stickySupporting: AKStickySupporting, ignoreStickSide: AKStickyProviderSide) -> AKStickInfo
}