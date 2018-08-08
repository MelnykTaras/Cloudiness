//
//  FlexibleCollectionView.swift
//  Cloudiness
//
//  Created by Admin on 7/24/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import UIKit

final class FlexibleCollectionView: UICollectionView {
    
    private var cellHeight: CGFloat?
    static let cellWidth: CGFloat = 40
    
    override func layoutSubviews() {
        if cellHeight != collectionViewHeight() {
            performBatchUpdates({ updateCellSize() }, completion: nil)
        }
        super.layoutSubviews()
    }
    
    func updateCellSize() {
        let estimatedCellHeight = collectionViewHeight()
        guard cellHeight != estimatedCellHeight else {
            return
        }
        cellHeight = estimatedCellHeight
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: FlexibleCollectionView.cellWidth, height: cellHeight!)
    }
    
    private func collectionViewHeight() -> CGFloat {
        return bounds.size.height
    }
}
