//
//  UICollectionViewExtension.swift
//  Cloudiness
//
//  Created by Admin on 7/18/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func curve(fromGrayscaleFrame frame: CGRect, _ clouds: [Cloud]) -> CAShapeLayer? {
        guard clouds.count > 1 else {
            return nil
        }
        let points = controlPoints(fromFirstGrayscaleFrame: frame, clouds)
        let layer = CAShapeLayer()
        layer.path = UIBezierPath.cubicCurvedPath(withPoints: points).cgPath
        layer.lineWidth = 4
        layer.strokeColor = UIColor.lightBlue.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = kCALineCapRound
        layer.lineJoin = kCALineJoinBevel
        return layer
    }
    
    private func controlPoints(fromFirstGrayscaleFrame frame: CGRect, _ clouds: [Cloud]) -> [CGPoint] {
        let width = frame.size.width
        let start = frame.origin.y
        let height = frame.size.height
        var points = [CGPoint]()
        for (index, cloud) in clouds.enumerated() {
            let point = CGPoint(x: width * CGFloat(index) + width / 2,
                                y: start + height * (1.0 - CGFloat(cloud.cloudiness / 100.0)))
            points.append(point)
        }
        return points
    }
}
