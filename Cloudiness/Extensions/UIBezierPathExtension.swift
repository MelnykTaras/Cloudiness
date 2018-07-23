//
//  UIBezierPathExtension.swift
//  Cloudiness
//
//  Created by Admin on 7/18/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import UIKit

extension UIBezierPath {
    
    static func cubicCurvedPath(withPoints points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        
        var p1 = points[0]
        path.move(to: p1)
        var oldControlP = p1
        
        for i in 0..<points.count {
            let p2 = points[i]
            var p3: CGPoint? = nil
            if i < points.count - 1 {
                p3 = points[i + 1]
            }
            let newControlP = controlPointForPoints(p1, p2, p3)
            path.addCurve(to: p2, controlPoint1: oldControlP , controlPoint2: newControlP ?? p2)
            oldControlP = mirror(forPoint: newControlP, center: p2) ?? p1
            if let p3 = p3 {
                if oldControlP.x > p3.x { oldControlP.x = p3.x }
            }
            p1 = p2
        }
        UIColor.lightBlue.setStroke()
        path.lineWidth = 4
        path.stroke()
        return path
    }
}

private extension UIBezierPath {
    
    static func mirror(forPoint point: CGPoint?, center: CGPoint?) -> CGPoint? {
        guard let p = point, let center = center else {
            return nil
        }
        let newX = center.x + center.x - p.x
        let newY = center.y + center.y - p.y
        return CGPoint(x: newX, y: newY)
    }
    
    static func midPointBetweenPoints(_ p1: CGPoint, _ p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }
    
    static func clamp(num: CGFloat, bounds1: CGFloat, bounds2: CGFloat) -> CGFloat {
        if (bounds1 < bounds2) {
            return min(max(bounds1, num), bounds2)
        } else {
            return min(max(bounds2, num), bounds1)
        }
    }
    
    static func controlPointForPoints(_ p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint?) -> CGPoint? {
        guard let p3 = p3 else {
            return nil
        }
        let leftMidPoint  = midPointBetweenPoints(p1, p2)
        let rightMidPoint = midPointBetweenPoints(p1, p3)
        let imaginPoint = mirror(forPoint: rightMidPoint, center: p2)
        var controlPoint = midPointBetweenPoints(leftMidPoint, imaginPoint!)
        controlPoint.y = clamp(num: controlPoint.y, bounds1: p1.y, bounds2: p2.y)
        let flippedP3 = p2.y + (p2.y - p3.y)
        controlPoint.y = clamp(num: controlPoint.y, bounds1: p2.y, bounds2: flippedP3)
        controlPoint.x = clamp (num:controlPoint.x, bounds1: p1.x, bounds2: p2.x)
        return controlPoint
    }
}
