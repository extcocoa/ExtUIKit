//
//  UIFontExtensions.swift
//  ExtUIKit
//
//  Created by Jesse Hao on 2019/5/5.
//

import Foundation

extension UIFont : ExtUIKitNamespaceWrappable {}
public extension ExtUIKitNamespaceWrapper where Base : UIFont {
	static func pingFangSCFont(ofSize size:CGFloat, weight:UIFont.Weight) -> ExtUIKitNamespaceWrapper<UIFont> {
		var fontStr = "PingFangSC-"
		switch weight {
		case UIFont.Weight.semibold:
			fontStr += "Semibold"
		case UIFont.Weight.light:
			fontStr += "Light"
		case UIFont.Weight.medium:
			fontStr += "Medium"
		case UIFont.Weight.bold:
			fontStr += "Bold"
		case UIFont.Weight.regular:
			fontStr += "Regular"
		default:
			fontStr += "Regular"
		}
		return UIFont(name: fontStr, size: size)!.ext
	}
}
