//
//  ContainerStyle.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 1/26/17.
//  Copyright © 2017 Ivy Gulch LLC. All rights reserved.
//

import UIKit

public struct ContainerStyle {
    public let backgroundColor: UIColor?
    public let selectedColor: UIColor?
    public let borderColor: UIColor?
    public let borderWidth: CGFloat?
    public let cornerRadius: CGFloat?
    public let shadowColor: UIColor?
    public let shadowOffset: CGSize?
    public let normalFontStyle: FontStyle?
    public let selectedFontStyle: FontStyle?
    public let otherFontStyle: FontStyle?
    public let otherData: Any?

    public init(style: ContainerStyle? = nil, backgroundColor: UIColor? = nil, normalFontStyle: FontStyle? = nil, selectedColor: UIColor? = nil, selectedFontStyle: FontStyle? = nil, otherFontStyle: FontStyle? = nil, otherData: Any? = nil, borderColor: UIColor? = nil, borderWidth: CGFloat? = nil, cornerRadius: CGFloat? = nil, shadowColor: UIColor? = nil, shadowOffset: CGSize? = nil) {
        self.backgroundColor = backgroundColor ?? style?.backgroundColor
        self.normalFontStyle = normalFontStyle ?? style?.normalFontStyle
        self.selectedColor = selectedColor ?? style?.selectedColor
        self.selectedFontStyle = selectedFontStyle ?? style?.selectedFontStyle
        self.otherFontStyle = otherFontStyle ?? style?.otherFontStyle
        self.otherData = otherData ?? style?.otherData
        self.borderColor = borderColor ?? style?.borderColor
        self.borderWidth = borderWidth ?? style?.borderWidth
        self.cornerRadius = cornerRadius ?? style?.cornerRadius
        self.shadowColor = shadowColor ?? style?.shadowColor
        self.shadowOffset = shadowOffset ?? style?.shadowOffset
    }

    public func setBackgroundColor(_ backgroundColor: UIColor) -> ContainerStyle {
        return ContainerStyle(style: self, backgroundColor: backgroundColor)
    }

    public func setSelectedColor(_ selectedColor: UIColor) -> ContainerStyle {
        return ContainerStyle(style: self, selectedColor: selectedColor)
    }

    public func setBorderColor(_ borderColor: UIColor) -> ContainerStyle {
        return ContainerStyle(style: self, selectedColor: borderColor)
    }

    public func setBorderWidth(_ borderWidth: CGFloat) -> ContainerStyle {
        return ContainerStyle(style: self, borderWidth: borderWidth)
    }

    public func setCornerRadius(_ cornerRadius: CGFloat) -> ContainerStyle {
        return ContainerStyle(style: self, cornerRadius: cornerRadius)
    }

    public func setShadowColor(_ shadowColor: UIColor) -> ContainerStyle {
        return ContainerStyle(style: self, shadowColor: shadowColor)
    }

    public func setShadowOffset(_ shadowOffset: CGSize) -> ContainerStyle {
        return ContainerStyle(style: self, shadowOffset: shadowOffset)
    }

    public func setNormalFontStyle(_ normalFontStyle: FontStyle) -> ContainerStyle {
        return ContainerStyle(style: self, normalFontStyle: normalFontStyle)
    }

    public func setSelectedFontStyle(_ selectedFontStyle: FontStyle) -> ContainerStyle {
        return ContainerStyle(style: self, selectedFontStyle: selectedFontStyle)
    }

    public func setOtherFontStyle(_ otherFontStyle: FontStyle) -> ContainerStyle {
        return ContainerStyle(style: self, otherFontStyle: otherFontStyle)
    }

    public func setOtherData(_ otherData: Any) -> ContainerStyle {
        return ContainerStyle(style: self, otherData: otherData)
    }


    private func apply(toLayer layer: CALayer?) {
        guard let layer = layer else { return }

        if let borderColor = self.borderColor {
            layer.borderColor = borderColor.cgColor
        }
        if let borderWidth = self.borderWidth {
            layer.borderWidth = borderWidth
        }
        if let cornerRadius = self.cornerRadius {
            layer.cornerRadius = cornerRadius
        }
        if let shadowColor = self.shadowColor {
            layer.shadowColor = shadowColor.cgColor
        }
        if let shadowOffset = self.shadowOffset {
            layer.shadowOffset = shadowOffset
        }
    }

    public func apply(toLabel label: UILabel, animated: Bool = true) {
        apply(block: {
            if let backgroundColor = self.backgroundColor {
                label.backgroundColor = backgroundColor
            }
            self.apply(toLayer: label.layer)

            self.normalFontStyle?.apply(toLabel: label, animated: false)
        }, animated: animated)
    }

    public func apply(toTextField textField: UITextField, animated: Bool = true) {
        apply(block: {
            if let backgroundColor = self.backgroundColor {
                textField.backgroundColor = backgroundColor
            }
            self.apply(toLayer: textField.layer)

            self.normalFontStyle?.apply(toTextField: textField, animated: false)
        }, animated: animated)
    }

    public func apply(toSearchTextField searchTextField: UITextField, animated: Bool = true) {
        apply(block: {
            if let backgroundColor = self.backgroundColor {
                searchTextField.backgroundColor = backgroundColor
            }
            self.apply(toLayer: searchTextField.layer)

            self.normalFontStyle?.apply(toTextField: searchTextField, animated: false)

            let placeholderText = (self.otherData as? String) ?? searchTextField.placeholder ?? "Search"
            if let otherFontStyle = self.otherFontStyle {
                var attributes: [String: Any] = [:]
                if let font = otherFontStyle.font {
                    attributes[NSFontAttributeName] = font
                }
                if let textColor = otherFontStyle.textColor {
                    attributes[NSForegroundColorAttributeName] = textColor
                }
                searchTextField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
            } else {
                searchTextField.placeholder = placeholderText
            }
            self.selectedFontStyle?.apply(toTextField: searchTextField, animated: false)

            if let searchIconImage = UIImage(named: "ico-search") {
                let searchIconImageView = UIImageView(image: searchIconImage)
                searchIconImageView.contentMode = .scaleAspectFit
                let imageSize = searchIconImage.size
                searchIconImageView.frame = CGRect(x: 0, y: 0, width: imageSize.width + 8, height: imageSize.height)

                searchTextField.rightView = searchIconImageView
                searchTextField.rightViewMode = .unlessEditing
            }

        }, animated: animated)
    }

    public func apply(toButton button: UIButton, animated: Bool = true) {
        apply(block: {
            if let backgroundColor = self.backgroundColor {
                button.setBackgroundColor(color: backgroundColor, forState: .normal)
            }
            if let selectedColor = self.selectedColor {
                button.setBackgroundColor(color: selectedColor, forState: .selected)
            }
            self.apply(toLayer: button.layer)

            self.normalFontStyle?.apply(toButton: button, controlState: .normal, animated: false)
            self.selectedFontStyle?.apply(toButton: button, controlState: .selected, animated: false)
        }, animated: animated)
    }

    public func apply(toView view: UIView, animated: Bool = true) {
        apply(block: {
            if let backgroundColor = self.backgroundColor {
                view.backgroundColor = backgroundColor
            }
            self.apply(toLayer: view.layer)
        }, animated: animated)
    }
    
}

extension ContainerStyle {

    public func apply(toLabel label: UILabel) {
        apply(toLabel: label, animated: true)
    }

    public func apply(toTextField textField: UITextField) {
        apply(toTextField: textField, animated: true)
    }

    public func apply(toSearchTextField searchTextField: UITextField) {
        apply(toSearchTextField: searchTextField, animated: true)
    }

    public func apply(toButton button: UIButton) {
        apply(toButton: button, animated: true)
    }

    public func apply(toView view: UIView) {
        apply(toView: view, animated: true)
    }

    public func apply(to: Any?, animated: Bool = true) {
        if let label = to as? UILabel {
            apply(toLabel: label, animated: animated)
        } else if let textField = to as? UITextField {
            apply(toTextField: textField, animated: animated)
        } else if let button = to as? UIButton {
            apply(toButton: button, animated: animated)
        } else if let view = to as? UIView {
            apply(toView: view, animated: animated)
        }
    }

    public func apply(block: @escaping (() -> Void), animated: Bool = true, duration: TimeInterval? = nil) {
        if animated {
            UIView.animate(withDuration: duration ?? 0.3, animations: block)
        } else {
            block()
        }
    }
    
}
