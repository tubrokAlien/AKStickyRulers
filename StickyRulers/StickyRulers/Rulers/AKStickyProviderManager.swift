//
//  AKStickyProviderManager.swift
//  StickyRulers
//
//  Created by Alen Korbut on 31.08.15.
//  Copyright (c) 2015 KorbCorp LLC. All rights reserved.
//

import Foundation
import UIKit

let kStickyProviderList = "stickyProviderList"

class AKStickyProviderManager: NSObject, AKStickyProvider {
    private var stickyProviderList: [AKStickyProvider] = []
    
    func addStickyProvider(provider: AKStickyProvider) {
        stickyProviderList.append(provider)
    }
    
    override init() {
        super.init()
        //do nothing for now
    }
    
    func provideToCheckSide() -> AKStickyProviderSide {
        return AKStickyProviderSide.Both
    }
    func checkForSticky(stickySupporting: AKStickySupporting, ignoreStickSide: AKStickyProviderSide) -> AKStickInfo {
        var sticks = [AKStickyProvider]()
        var res = AKStickyProviderSide.None
        for itm in stickyProviderList {
            if itm.provideToCheckSide() != res {
                let info = itm.checkForSticky(stickySupporting, ignoreStickSide: ignoreStickSide)
                let side = info.stickProviderSide
                if side != AKStickyProviderSide.None && side != res {
                    for infoProvider in info.stickProviders {
                        sticks.append(infoProvider)
                    }
                    if res == AKStickyProviderSide.Horizontal || res == AKStickyProviderSide.Vertical || side == AKStickyProviderSide.Both {
                        return AKStickInfo(providers: sticks, side: AKStickyProviderSide.Both)
                    }
                    res = side
                }
            }
        }
        
        return AKStickInfo(providers: sticks, side: res)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        var list = [AnyObject]()
        for itm in stickyProviderList {
            list.append(itm)
        }
        aCoder.encodeObject(list, forKey: kStickyProviderList)
    }
    required init?(coder aDecoder: NSCoder) {
        if let list = aDecoder.decodeObjectForKey(kStickyProviderList) as? [AnyObject] {
            for itm in list {
                if let provider = itm as? AKStickyProvider {
                    stickyProviderList.append(provider)
                }
            }
        }
    }

}