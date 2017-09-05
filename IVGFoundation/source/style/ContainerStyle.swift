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
    public let height: CGFloat?
    public let adjustsFontSizeToFitWidth: Bool?
    public let minimumScaleFactor: CGFloat?
    public let horizontalAlignment: UIControlContentHorizontalAlignment?
    public let verticalAlignment: UIControlContentVerticalAlignment?

    public init(style: ContainerStyle? = nil, backgroundColor: UIColor? = nil, normalFontStyle: FontStyle? = nil, selectedColor: UIColor? = nil, selectedFontStyle: FontStyle? = nil, otherFontStyle: FontStyle? = nil, otherData: Any? = nil, borderColor: UIColor? = nil, borderWidth: CGFloat? = nil, cornerRadius: CGFloat? = nil, shadowColor: UIColor? = nil, shadowOffset: CGSize? = nil, height: CGFloat? = nil, adjustsFontSizeToFitWidth: Bool? = nil, minimumScaleFactor: CGFloat? = nil, horizontalAlignment: UIControlContentHorizontalAlignment? = nil, verticalAlignment: UIControlContentVerticalAlignment? = nil) {
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
        self.height = height ?? style?.height
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth ?? style?.adjustsFontSizeToFitWidth
        self.minimumScaleFactor = minimumScaleFactor ?? style?.minimumScaleFactor
        self.horizontalAlignment = horizontalAlignment ?? style?.horizontalAlignment
        self.verticalAlignment = verticalAlignment ?? style?.verticalAlignment
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

    public func setHeight(_ height: CGFloat) -> ContainerStyle {
        return ContainerStyle(style: self, height: height)
    }

    public func setHorizontalAlignment(_ horizontalAlignment: UIControlContentHorizontalAlignment) -> ContainerStyle {
        return ContainerStyle(style: self, horizontalAlignment: horizontalAlignment)
    }

    public func setVerticalAlignment(_ verticalAlignment: UIControlContentVerticalAlignment) -> ContainerStyle {
        return ContainerStyle(style: self, verticalAlignment: verticalAlignment)
    }

    private func applyConstraints(toView view: UIView) {
        if let height = self.height {
            if let (constraint, owner) = view.firstConstraint(matchingAttribute: .height, relation: .equal) {
                if constraint.constant != height {
                    constraint.constant = height
                    owner.setNeedsUpdateConstraints()
                    owner.updateConstraintsIfNeeded()
                    owner.setNeedsLayout()
                    owner.layoutIfNeeded()
                }
            } else {
                view.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height))
                view.setNeedsLayout()
                view.layoutIfNeeded()
            }

        }
    }

    private func applyControlValues(toView view: UIView?) {
        guard let control = view as? UIControl else { return }

        if let horizontalAlignment = horizontalAlignment {
            control.contentHorizontalAlignment = horizontalAlignment
        }
        if let verticalAlignment = verticalAlignment {
            control.contentVerticalAlignment = verticalAlignment
        }
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
            layer.masksToBounds = true
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
            self.applyConstraints(toView: label)
            self.applyControlValues(toView: label)

            if let backgroundColor = self.backgroundColor {
                label.backgroundColor = backgroundColor
            }
            if let adjustsFontSizeToFitWidth = self.adjustsFontSizeToFitWidth {
                label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
            }
            if let minimumScaleFactor = self.minimumScaleFactor {
                label.minimumScaleFactor = minimumScaleFactor
            }
            self.apply(toLayer: label.layer)

            self.normalFontStyle?.apply(toLabel: label, animated: false)
        }, animated: animated)
    }

    public func apply(toTextField textField: UITextField, animated: Bool = true) {
        apply(block: {
            self.applyConstraints(toView: textField)
            self.applyControlValues(toView: textField)

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

    public func apply(toTextView textView: UITextView, animated: Bool = true) {
        apply(block: {
            self.applyConstraints(toView: textView)
            self.applyControlValues(toView: textView)

            if let backgroundColor = self.backgroundColor {
                textView.backgroundColor = backgroundColor
            }
            self.apply(toLayer: textView.layer)

            self.normalFontStyle?.apply(toTextView: textView, animated: false)
        }, animated: animated)
    }

    public func apply(toButton button: UIButton, animated: Bool = true) {
        apply(block: {
            self.applyConstraints(toView: button)
            self.applyControlValues(toView: button)

            if let backgroundColor = self.backgroundColor {
                button.setBackgroundColor(color: backgroundColor, forState: .normal)
            }
            if let selectedColor = self.selectedColor {
                button.setBackgroundColor(color: selectedColor, forState: .selected)
            }
            if let adjustsFontSizeToFitWidth = self.adjustsFontSizeToFitWidth {
                button.titleLabel?.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
            }
            if let minimumScaleFactor = self.minimumScaleFactor {
                button.titleLabel?.minimumScaleFactor = minimumScaleFactor
            }
            self.apply(toLayer: button.layer)

            self.normalFontStyle?.apply(toButton: button, controlState: .normal, animated: false)
            self.selectedFontStyle?.apply(toButton: button, controlState: .selected, animated: false)
        }, animated: animated)
    }

    public func apply(toPageControl pageControl: UIPageControl, animated: Bool = true) {
        apply(block: {
            self.applyConstraints(toView: pageControl)
            self.applyControlValues(toView: pageControl)

            if let backgroundColor = self.backgroundColor {
                pageControl.tintColor = backgroundColor
            }
            if let selectedColor = self.selectedColor {
                pageControl.currentPageIndicatorTintColor = selectedColor
            }
            self.apply(toLayer: pageControl.layer)
        }, animated: animated)
    }

    public func apply(toView view: UIView, animated: Bool = true) {
        apply(block: {
            self.applyConstraints(toView: view)
            self.applyControlValues(toView: view)

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
    
    public func apply(toTextView textView: UITextView) {
        apply(toTextView: textView, animated: true)
    }

    public func apply(toButton button: UIButton) {
        apply(toButton: button, animated: true)
    }

    public func apply(toPageControl pageControl: UIPageControl) {
        apply(toPageControl: pageControl, animated: true)
    }

    public func apply(toView view: UIView) {
        apply(toView: view, animated: true)
    }

    public func apply(to: Any?, animated: Bool = true) {
        if let label = to as? UILabel {
            apply(toLabel: label, animated: animated)
        } else if let textField = to as? UITextField {
            apply(toTextField: textField, animated: animated)
        } else if let textView = to as? UITextView {
            apply(toTextView: textView, animated: animated)
        } else if let button = to as? UIButton {
            apply(toButton: button, animated: animated)
        } else if let pageControl = to as? UIPageControl {
            apply(toPageControl: pageControl, animated: animated)
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
