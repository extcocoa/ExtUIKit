//
//  ExtPaddingLabel.swift
//  ExtUIKit
//
//  Created by Allen_Tancy on 2019/4/3.
//  Copyright © 2019 Allen_Tancy. All rights reserved.
//

import UIKit

class ExtPaddingLabel: UILabel {
    var edgeInsets: UIEdgeInsets = .zero
    
    override var intrinsicContentSize: CGSize {
        let contentSize = super.intrinsicContentSize
        return CGSize(width: contentSize.width + self.edgeInsets.left + self.edgeInsets.right, height: contentSize.height + self.edgeInsets.top + self.edgeInsets.bottom)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.edgeInsets))
    }
}
