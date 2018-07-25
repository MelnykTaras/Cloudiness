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
        if isCellSizeAnimationAllowed {
            isCellSizeAnimationAllowed = false
            performBatchUpdates({ updateCellSize() }, completion: { _ in
                self.isCellSizeAnimationAllowed = true
            })
        }
    }
    
    func updateCellSize() {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let height = bounds.size.height
        layout.itemSize = CGSize(width: 40, height: height)
    }
}