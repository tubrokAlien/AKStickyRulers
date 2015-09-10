//
//  AKStickInfo.swift
//  StickyRulers
//
//  Created by Alen Korbut on 02.09.15.
//  Copyright (c) 2015 KorbCorp LLC. All rights reserved.
//

import Foundation

class AKStickInfo {
    var stickProviderSide: AKStickyProviderSide
    var stickProviders: [AKStickyProvider]
    
    init(provider: AKStickyProvider, side: AKStickyProviderSide) {
        stickProviders = [provider]
        stickProviderSide = side
    }
    
    init(providers: [AKStickyProvider], side: AKStickyProviderSide) {
        stickProviders = providers
        stickProviderSide = side
    }
}
