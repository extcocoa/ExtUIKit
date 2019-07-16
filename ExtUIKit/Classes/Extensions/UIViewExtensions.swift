//
//  UIViewExtensions.swift
//  ExtUIKit
//
//  Created by Jesse Hao on 2019/5/5.
//

import Foundation

extension UIEdgeInsets : ExtUIKitNamespaceWrappable {}

extension UIView : ExtUIKitNamespaceWrappable {}
public extension ExtUIKitNamespaceWrapper where Base : UIView {
	@discardableResult
	func add(to superview:UIView) -> ExtUIKitNamespaceWrapper<Base> {
		superview.addSubview(self.unwrapped)
		return self
	}
	
	func addSubview(_ subviews:UIView...) {
		subviews.forEach { self.unwrapped.addSubview($0) }
	}
	
	func addSubview<S>(_ subviews:S) where S : Sequence, S.Element : UIView {
		subviews.forEach { self.unwrapped.addSubview($0) }
	}
	
	func removeAllSubviews() {
		self.unwrapped.subviews.forEach {
			$0.removeConstraints($0.constraints)
			$0.removeFromSuperview()
		}
	}
	
	func addTapGesture(target:Any?, action:Selector?) {
		self.unwrapped.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
	}
	
	func addLongPressGesture(target:Any?, action:Selector?) {
		self.unwrapped.addGestureRecognizer(UILongPressGestureRecognizer(target: target, action: action))
	}
	
	func setShadow(withOpacity opacity:Float, offsetX:Double, offsetY:Double, blur:CGFloat, color:UIColor) {
		self.unwrapped.layer.shadowColor = color.cgColor
		self.unwrapped.layer.shadowOpacity = opacity
		self.unwrapped.layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
		self.unwrapped.layer.shadowRadius = blur
	}
	
	func setBorder(withColor color:UIColor, thickness:CGFloat = 1, cornerRadius:CGFloat = 0) {
		self.unwrapped.layer.borderColor = color.cgColor
		self.unwrapped.layer.borderWidth = thickness
		self.unwrapped.layer.cornerRadius = cornerRadius
	}
	
	var insetForSafeAreaOrZero:ExtUIKitNamespaceWrapper<UIEdgeInsets> {
		if #available(iOS 11.0, *) {
			return self.unwrapped.safeAreaInsets.ext
		}
		return UIEdgeInsets.zero.ext
	}
	
	static func animateOrNot(_ animated:Bool, duration:TimeInterval, closure:@escaping () -> Void, completeHandler:((Bool) -> Void)?) {
		guard animated else {
			closure()
			completeHandler?(true)
			return
		}
		Base.animate(withDuration: duration, animations: closure, completion: completeHandler)
	}
	
	static func animateOrNot(_ animated:Bool, duration:TimeInterval = 0.3, closure:@escaping () -> Void) {
		self.animateOrNot(animated, duration: duration, closure: closure, completeHandler: nil)
	}
}

public extension ExtUIKitNamespaceWrapper where Base : UILabel {
	static func label(withFont font:UIFont, color:UIColor, text:@autoclosure () -> String? = nil) -> ExtUIKitNamespaceWrapper<UILabel> {
		let retval = UILabel()
		retval.font = font
		retval.textColor = color
		retval.text = text()
		return retval.ext
	}
	
	static func label(withSystemFontSize size:CGFloat, weight: UIFont.Weight, color:UIColor, text:@autoclosure () -> String? = nil) -> ExtUIKitNamespaceWrapper<UILabel> {
		return self.label(withFont: .systemFont(ofSize: size, weight: weight), color: color, text: text())
	}
	
	static func label(withPingFangSCFontSize size:CGFloat, weight: UIFont.Weight, color:UIColor, text:@autoclosure () -> String? = nil) -> ExtUIKitNamespaceWrapper<UILabel> {
		return self.label(withFont: UIFont.ext.pingFangSCFont(ofSize: size, weight: weight).unwrapped, color: color, text: text())
	}
}

public extension ExtUIKitNamespaceWrapper where Base : UIButton {
	static func button(withImage image:UIImage?) -> ExtUIKitNamespaceWrapper<UIButton> {
		let retval = UIButton()
		retval.setImage(image, for: .normal)
		return retval.ext
	}
	
	static func textButton(text:String, font:UIFont, color:UIColor) -> ExtUIKitNamespaceWrapper<UIButton> {
		let retval = UIButton()
		retval.titleLabel?.font = font
		retval.setTitleColor(color, for: .normal)
		retval.setTitle(text, for: .normal)
		return retval.ext
	}
}

public extension ExtUIKitNamespaceWrapper where Base : UISwitch {
	func reverse() {
		self.unwrapped.setOn(!self.unwrapped.isOn, animated: true)
	}
}

public extension ExtUIKitNamespaceWrapper where Base : UIScrollView {
	/// Scroll to bottom of scrollView.
	///
	/// - Parameter animated: set true to animate scroll (default is true).
	func scrollToBottom(animated: Bool = true) {
		let bottomOffset = CGPoint(x: 0, y: self.unwrapped.contentSize.height - self.unwrapped.bounds.size.height)
		self.unwrapped.setContentOffset(bottomOffset, animated: animated)
	}
	
	/// Scroll to top of scrollView.
	///
	/// - Parameter animated: set true to animate scroll (default is true).
	func scrollToTop(animated: Bool = true) {
		self.unwrapped.setContentOffset(CGPoint.zero, animated: animated)
	}
}

public extension ExtUIKitNamespaceWrapper where Base : UITableView {
	var hasCell:Bool {
		let sectionCount = self.unwrapped.numberOfSections
		guard sectionCount > 0 else { return false }
		return (0..<sectionCount).contains { self.unwrapped.numberOfRows(inSection: $0) > 0 }
	}
	
	/// Number of all rows in all sections of tableView.
	///
	/// - Returns: The count of all rows in the tableView.
	func numberOfRows() -> Int {
		let sectionCount = self.unwrapped.numberOfSections
		guard sectionCount > 0 else { return 0 }
		return (0..<sectionCount).reduce(0) { $0 + self.unwrapped.numberOfRows(inSection: $1) }
	}
	
	func registerCells(withDictionary dict:[String:AnyClass]) {
		dict.forEach { self.unwrapped.register($1, forCellReuseIdentifier: $0) }
	}
	
	var lastSectionIndex:Int? {
		return self.unwrapped.numberOfSections > 0 ? self.unwrapped.numberOfSections - 1 : nil
	}
	
	func lastRowIndex(inSection section:Int) -> Int? {
		let count = self.unwrapped.numberOfRows(inSection: section)
		return count > 0 ? count - 1 : nil
	}
	
	func indexPathForFirstCell() -> IndexPath? {
		guard let section = (0..<self.unwrapped.numberOfSections).first(where: { self.unwrapped.numberOfRows(inSection: $0) > 0 }) else { return nil }
		return [section, 0]
	}
	
	func indexPathForLastCell() -> IndexPath? {
		var row:Int = -1
		guard let section = (0..<self.unwrapped.numberOfSections).last(where: {
			row = self.unwrapped.numberOfRows(inSection: $0) - 1
			return row >= 0
		}) else { return nil }
		return [section, row]
	}
	
	func scrollToTopRow(animated:Bool = true) {
		guard let indexPath = self.indexPathForFirstCell() else { return }
		self.unwrapped.scrollToRow(at: indexPath, at: .top, animated: animated)
	}
	
	func scrollToBottomRow(animated:Bool = true) {
		guard let indexPath = self.indexPathForLastCell() else { return }
		self.unwrapped.scrollToRow(at: indexPath, at: .bottom, animated: animated)
	}
	
	/// Reload data with a completion handler.
	///
	/// - Parameter completion: completion handler to run after reloadData finishes.
	func reloadData(_ completion: @escaping () -> Void) {
		UIView.animate(withDuration: 0, animations: {
			self.unwrapped.reloadData()
		}, completion: { _ in
			completion()
		})
	}
}
