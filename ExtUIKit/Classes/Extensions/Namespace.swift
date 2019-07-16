//
//  Namespace.swift
//  ExtUIKit
//
//  Created by Jesse Hao on 2019/5/5.
//

public protocol ExtUIKitNamespaceWrappable {
	associatedtype WrapperType:ExtUIKitTypeWrapperProtocol
	var ext:WrapperType { get }
	static var ext:WrapperType.Type { get }
}

public extension ExtUIKitNamespaceWrappable {
	var ext:ExtUIKitNamespaceWrapper<Self> {
		return ExtUIKitNamespaceWrapper(value: self)
	}
	static var ext:ExtUIKitNamespaceWrapper<Self>.Type {
		return ExtUIKitNamespaceWrapper.self
	}
}

public protocol ExtUIKitTypeWrapperProtocol {
	associatedtype WrappedType
	var unwrapped: WrappedType { get }
	init(value: WrappedType)
}

public struct ExtUIKitNamespaceWrapper<Base> : ExtUIKitTypeWrapperProtocol {
	public var unwrapped: Base
	public init(value: Base) {
		self.unwrapped = value
	}
}
