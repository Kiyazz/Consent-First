//
//  Signaturerecognizer.swift
//  ugu
//
//  Created by Darius Kashani on 9/12/21.
//

import UIKit;
import UIKit.UIGestureRecognizerSubclass;

class Signaturerecognizer: UIGestureRecognizer {
    var points:[CGPoint] = [CGPoint]();
    
    
    
    var fingerOn:Bool = false;
    
    
    
    required override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event);
        self.state = .began;
        fingerOn = true;
        if (touches.count == 1) {
            let touch = touches.first;
            points.append((touch?.location(in: view))!);
        }
        print("we got here")
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if (touches.count == 1) {
            points.append((touches.first?.location(in: view))!);
        }
        print("we got here")
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        fingerOn = false;
        endSignature();
        print("we got here")
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        fingerOn = false;
        endSignature();
        print("we got here")
    }
    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        super.touchesEstimatedPropertiesUpdated(touches);
    }
    
    func endSignature() {
        print(points.description);
    }
    
    
}
