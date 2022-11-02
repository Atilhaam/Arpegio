//
//  TextFieldNode.swift
//  Arpegio
//
//  Created by Ilham Wibowo on 27/10/22.
//

import Foundation
import AsyncDisplayKit

class TextFieldNode: ASDisplayNode {
    
    var bar: UITextField? {
        return self.view as? UITextField
    }
    
    init(height: CGFloat) {
        super.init()
        self.setViewBlock({
            let textFieldView: UITextField = .init(frame: .zero)
            textFieldView.layer.cornerRadius = 12
            textFieldView.layer.borderColor = UIColor.lightGray.cgColor
            textFieldView.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
            textFieldView.leftViewMode = .always
            textFieldView.backgroundColor = .white
            
            return textFieldView
        })
        self.style.height = .init(unit: .points, value: height)
        self.style.width = .init(unit: .fraction, value: 1)
        self.backgroundColor = .white
    }
}
