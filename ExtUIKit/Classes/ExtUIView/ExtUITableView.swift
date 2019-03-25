//
//  ExtUITableView.swift
//  ExtUIKit
//
//  Created by Jesse Hao on 2019/3/25.
//

import Foundation

protocol ExtUITableViewDataSource : class {
	func tableViewWillLoadData()
	func tableViewDidLoadData()
	func tableViewWillBeginUpdate()
	func tableViewDidEndUpdate()
}

extension ExtUITableViewDataSource {
	func tableViewWillLoadData() {}
	func tableViewDidLoadData() {}
	func tableViewWillBeginUpdate() {}
	func tableViewDidEndUpdate() {}
}

class ExtUITableView : UITableView {
	weak var extDataSource:ExtUITableViewDataSource?
	
	override func reloadData() {
		self.extDataSource?.tableViewWillLoadData()
		super.reloadData()
		DispatchQueue.main.async { [weak self] in
			self?.extDataSource?.tableViewDidLoadData()
		}
	}
	
	override func beginUpdates() {
		self.extDataSource?.tableViewWillBeginUpdate()
		super.beginUpdates()
	}
	
	override func endUpdates() {
		super.endUpdates()
		DispatchQueue.main.async { [weak self] in
			self?.extDataSource?.tableViewDidEndUpdate()
		}
	}
}
