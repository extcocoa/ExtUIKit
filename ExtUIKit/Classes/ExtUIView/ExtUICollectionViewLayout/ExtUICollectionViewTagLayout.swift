//
//  ExtUICollectionViewTagLayout.swift
//  ExtUICollectionView
//
//  Created by Allen_Tancy on 2018/10/23.
//  Copyright © 2018 Allen Tancy. All rights reserved.
//

import UIKit

protocol ExtUICollectionViewTagLayoutDelegate: class {
	/// - Returns: The item's width
	func tagFlowLayout(_ layout: ExtUICollectionViewTagLayout, widthAtIndexPath indexPath: IndexPath) -> CGFloat
}

class ExtUICollectionViewTagLayout: UICollectionViewFlowLayout {
	
	// MARK: - Interface
	public var itemHeight: CGFloat = 30 // item's height
	public var sectionHeight: CGFloat = 50 // section's height
	public weak var delegate: ExtUICollectionViewTagLayoutDelegate?
	
	// Privates
	private var itemAttributes: [UICollectionViewLayoutAttributes] = []
	private var headerViewAttributes: [UICollectionViewLayoutAttributes] = []
	private var heightOfItems: [CGFloat] = [] // the height of all section's items
	private var numberOfRows:CGFloat = 0
	private var numberOfSections:CGFloat = 0
	
	override func prepare()  {
		super.prepare()
		self.scrollDirection = .vertical
		self.configAttributes()
	}
	
	private func configAttributes() {
		self.itemAttributes.removeAll()
		self.headerViewAttributes.removeAll()
		self.heightOfItems.removeAll()
		self.numberOfRows = 0
		let width = self.collectionView?.frame.size.width ?? 0
		let numberOfSections = self.collectionView?.numberOfSections ?? 0
		self.numberOfSections = CGFloat(numberOfSections)
		var lastSectionY: CGFloat = 0
		for sectionIndex in 0..<numberOfSections {
			// Section's headerView
			let sectionAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: sectionIndex))
			sectionAttribute.size = CGSize(width: width, height: sectionHeight)
			sectionAttribute.frame.origin = CGPoint(x: 0, y: lastSectionY)
			self.headerViewAttributes.append(sectionAttribute)
			lastSectionY = sectionAttribute.frame.origin.y
			// Items
			var lastOrigin = CGPoint(x: self.sectionInset.left, y: self.sectionInset.top + lastSectionY + sectionHeight)
			var lastSize = CGSize(width: 0, height: 0)
			let numberOfItems: Int = self.collectionView?.numberOfItems(inSection: sectionIndex) ?? 0
			var numberOfRows: CGFloat = 0
			for itemIndex in 0..<numberOfItems {
				let indexPath = IndexPath(row: itemIndex, section: sectionIndex)
				let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
				let maxWidth = width - self.sectionInset.right - self.sectionInset.left
				let width = self.delegate?.tagFlowLayout(self, widthAtIndexPath: indexPath) ?? 0
				attribute.size.height = itemHeight
				attribute.size.width = min(maxWidth, width)
				let currentWidth = lastOrigin.x + lastSize.width + self.minimumInteritemSpacing + attribute.size.width - self.sectionInset.left
				if  currentWidth > maxWidth { // 这一行显示不完
					attribute.frame.origin.x = self.sectionInset.left
					attribute.frame.origin.y = lastOrigin.y + lastSize.height + self.minimumLineSpacing
					numberOfRows += 1
				} else {
					if itemIndex == 0 {
						attribute.frame.origin = lastOrigin
						numberOfRows += 1
					} else {
						attribute.frame.origin.x = lastOrigin.x + lastSize.width + self.minimumInteritemSpacing
						attribute.frame.origin.y = lastOrigin.y
					}
				}
				lastSize = attribute.size
				lastOrigin = attribute.frame.origin
				lastSectionY = lastOrigin.y + lastSize.height + self.sectionInset.bottom
				self.itemAttributes.append(attribute)
			}
			let heightOfItemsForEachSection = (numberOfRows - 1) * self.minimumLineSpacing + numberOfRows * itemHeight + self.sectionInset.top + self.sectionInset.bottom
			self.heightOfItems.append(heightOfItemsForEachSection)
			self.numberOfRows += numberOfRows
			
		}
	}
	
	override var collectionViewContentSize: CGSize {
		let sumOfItemHeight = self.heightOfItems.reduce(0) { $0 + $1 }
		let height = sumOfItemHeight + sectionHeight * numberOfSections
		return CGSize(width: self.collectionView?.frame.width ?? 0, height: height)
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		var allAttributes: [UICollectionViewLayoutAttributes] = []
		allAttributes.append(contentsOf: self.headerViewAttributes)
		allAttributes.append(contentsOf: self.itemAttributes)
		return allAttributes
	}
	
	override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		if elementKind == UICollectionView.elementKindSectionHeader {
			return self.headerViewAttributes[indexPath.section]
		}
		return UICollectionViewLayoutAttributes()
	}
	
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}
}
