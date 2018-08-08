//
//  UICollectionViewExtension.swift
//  Cloudiness
//
//  Created by Admin on 7/18/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    private static let labelHeight: CGFloat = 20.5
    
    func curve(fromGrayscaleFrame grayscaleFrame: CGRect?, _ clouds: [Cloud]) -> CAShapeLayer? {
        guard clouds.count > 1 else {
            return nil
        }
        
        var frame: CGRect
        if let grayscaleFrame = grayscaleFrame {
            frame = grayscaleFrame
        } else {
            frame = CGRect(x: 0,
                           y: UICollectionView.labelHeight,
                           width: FlexibleCollectionView.cellWidth,
                           height: bounds.size.height - UICollectionView.labelHeight * 2)
        }
        
        let points = controlPoints(fromGrayscaleFrame: frame, clouds)
        let layer = CAShapeLayer()
        layer.path = UIBezierPath.cubicCurvedPath(withPoints: points).cgPath
        layer.lineWidth = 4
        layer.strokeColor = UIColor.lightBlue.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = kCALineCapRound
        layer.lineJoin = kCALineJoinBevel
        return layer
    }
    
    private func controlPoints(fromGrayscaleFrame frame: CGRect, _ clouds: [Cloud]) -> [CGPoint] {
        let width = frame.size.width
        var points = [CGPoint]()
        for (index, cloud) in clouds.enumerated() {
            let point = CGPoint(x: width * CGFloat(index) + width / 2,
                                y: frame.origin.y + frame.size.height * (1.0 - CGFloat(cloud.cloudiness / 100.0)))
            points.append(point)
        }
        return points
    }
}
