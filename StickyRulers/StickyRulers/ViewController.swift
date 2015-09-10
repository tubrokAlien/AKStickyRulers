//
//  ViewController.swift
//  StickyRulers
//
//  Created by Alen Korbut on 31.08.15.
//  Copyright (c) 2015 KorbCorp LLC. All rights reserved.
//

import UIKit

let kStickyManager = "stickyManager"
let kMoveView = "moveView"
let kStaticRulerViews = "staticRulerViews"

extension Array {
    mutating func removeObject<U: Equatable>(object: U) {
        var index: Int?
        for (idx, objectToCompare) in enumerate(self) {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        
        if(index != nil) {
            self.removeAtIndex(index!)
        }
    }
}

class ViewController: UIViewController {

    var stickyProviderManager: AKStickyProviderManager!
    var stickyTestView: UIView!
    var moveView: UIView!
    var blinks = [AKStickyRuler]()
    var staticRulerViews = [UIView]()
    
    var sp: CGPoint = CGPointZero

    @IBOutlet weak var verticalRulerSwitcher: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moveView = UIView(frame: CGRectMake(300, 300, 25, 25))
        moveView.backgroundColor = UIColor.redColor()
        addMoveView()
        
        stickyTestView = UIView(frame: CGRectMake(100, 100, 100, 100))
        stickyTestView.backgroundColor = UIColor.blueColor()
        view.addSubview(stickyTestView);
        
        stickyProviderManager = AKStickyProviderManager()
        stickyProviderManager.addStickyProvider(stickyTestView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Private Helper -
    
    private func documentsDirectory() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        return paths.count > 0 ? paths.first as? String : nil
    }
    private func testDataFilePath() -> String? {
        if let path = documentsDirectory() {
            return path.stringByAppendingPathComponent("testData.srdata")
        }
        return nil
    }
    private func addMoveView() {
        moveView.layer.borderColor = UIColor.blueColor().CGColor
        moveView.layer.borderWidth = 2.0
        view.addSubview(moveView)
    }
    private func showAlert(msg: String) {
        UIAlertView(title: msg, message: "Test Data", delegate: nil, cancelButtonTitle: "Ok").show()
    }
    private func blinkProvider(provider: AKStickyProvider) {
        if let ruler = provider as? AKStickyRuler {
            
            //TODO: fix skip mechanism
            
            //already exist in blinks list
            for itm in blinks {
                if itm == ruler {
                    return
                }
            }
            
            let blinkView = AKStickyBlinkView(provider: ruler)
            view.addSubview(blinkView)
            
            blinks.append(ruler)
            blinkView.blink({ (ok) -> Void in
                blinkView.removeFromSuperview()
                self.blinks.removeObject(ruler)
            })
        }
    }
    private func createRuler(point: CGPoint) {
        var ruler: AKStickyRuler!
        if verticalRulerSwitcher.on {
            ruler = AKStickyVerticalRuler(location: Int(point.x))
        }
        else {
            ruler = AKStickyHorizontalRuler(location: Int(point.y))
        }
        var blinkView = AKStickyBlinkView(provider: ruler)
        view.addSubview(blinkView)
        staticRulerViews.append(blinkView)
        
        stickyProviderManager.addStickyProvider(ruler)
    }

    
    //MARK: - Actions -
    
    @IBAction func savePressed(sender: AnyObject) {
        if let path = testDataFilePath() {
            let data = NSKeyedArchiver.archivedDataWithRootObject([kStickyManager : stickyProviderManager, kMoveView : moveView, kStaticRulerViews : staticRulerViews])
            let res = data.writeToFile(path, atomically: true)
            showAlert(res ? "Saved Successfully" : "Saving Fauled")
        }
    }
    @IBAction func loadPressed(sender: AnyObject) {
        if let path = testDataFilePath() {
            let res = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [String: AnyObject]
            if res != nil {
                
                if let manager = res![kStickyManager] as? AKStickyProviderManager {
                    stickyProviderManager = manager
                }
                if let mView = res![kMoveView] as? UIView {
                    moveView.removeFromSuperview()
                    moveView = mView
                    addMoveView()
                }
                if let staticRulers = res![kStaticRulerViews] as? [UIView] {
                    for tmp in staticRulers {
                        view.addSubview(tmp)
                        staticRulerViews.append(tmp)
                    }
                }
            }
            showAlert(res != nil ? "Load Successfully" : "Loading Fauled")
        }
    }
    @IBAction func doubleTapAction(sender: UITapGestureRecognizer) {
        let pt = sender.locationInView(self.view)
        createRuler(pt)
    }
    

    //MARK: - Touches -
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first! as! UITouch
        let pt = touch.locationInView(view)
        if CGRectContainsPoint(self.moveView.frame, pt) {
            sp.x = pt.x - moveView.frame.origin.x
            sp.y = pt.y - moveView.frame.origin.y
        }
    }
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first! as! UITouch
        let pt = touch.locationInView(view)
        if CGRectContainsPoint(self.moveView.frame, pt) {
            var fr = self.moveView.frame
            fr.origin.x = pt.x - sp.x
            fr.origin.y = pt.y - sp.y
            moveView.frame = fr
            
            let info = stickyProviderManager.checkForSticky(self.moveView, ignoreStickSide: AKStickyProviderSide.None)
            for itm in info.stickProviders {
                blinkProvider(itm)
            }
        }
    }
}

