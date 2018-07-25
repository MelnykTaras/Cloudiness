//
//  FlexibleCollectionView.swift
//  Cloudiness
//
//  Created by Admin on 7/24/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import UIKit

class FlexibleCollectionView: UICollectionView {
    
    var isCellSizeAnimationAllowed = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let animationSize = layer.animation(forKey: "bounds.size")
        guard let animationDuration = animationSize?.duration else {
            return
        }
        
        if isCellSizeAnimationAllowed {
            isCellSizeAnimationAllowed = false
            self.performBatchUpdates({ updateCellSize() })
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                self.isCellSizeAnimationAllowed = true
            }
        }
    }
    
    func updateCellSize() {
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        let height = self.bounds.size.height
        layout.itemSize = CGSize(width: 40, height: height)
    }
}
