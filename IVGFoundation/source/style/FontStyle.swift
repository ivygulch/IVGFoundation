//
//  FontStyle.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 1/26/17.
//  Copyright © 2017 Ivy Gulch LLC. All rights reserved.
//

import UIKit

public struct FontStyle {
    public let family: String?
    public let size: CGFloat?
    public let textColor: UIColor?
    public let font: UIFont?

    public init(style: FontStyle? = nil, family: String? = nil, size: CGFloat? = nil, textColor: UIColor? = nil) {
        self.family = family ?? style?.family
        self.size = size ?? style?.size
        self.textColor = textColor ?? style?.textColor

        if let family = family, let size = size {
            if let font = UIFont(name: family, size: size) {
                self.font = font
            } else {
                print("WARNING: Could not load font: \(family) \(size)")
                self.font = nil
            }
        } else {
            self.font = nil
        }
    }

    public func setFamily(_ family: String) -> FontStyle {
        return FontStyle(style: self, family: family)
    }

    public func setSize(_ size: CGFloat) -> FontStyle {
        return FontStyle(style: self, size: size)
    }

    public func setTextColor(_ textColor: UIColor) -> FontStyle {
        return FontStyle(style: self, textColor: textColor)
    }

    public func setFont(_ font: UIFont) -> FontStyle {
        return FontStyle(style: self, family: font.familyName, size: font.pointSize)
    }

    public func style(family: String? = nil, size: CGFloat? = nil, textColor: UIColor? = nil) -> FontStyle {
        let useFamily = family ?? self.family
        let useSize = size ?? self.size
        let useTextColor = textColor ?? self.textColor
        return FontStyle(family: useFamily, size: useSize, textColor: useTextColor)
    }

    private func apply(block: @escaping (() -> Void), animated: Bool = true, duration: TimeInterval? = nil) {
        if animated {
            UIView.animate(withDuration: duration ?? 0.3, animations: block)
        } else {
            block()
        }
    }

    public func apply(toLabel label: UILabel?, animated: Bool = true) {
        guard let label = label else { return }

        apply(block: {
            if let font = self.font {
                label.font = font
            }
            if let textColor = self.textColor {
                label.textColor = textColor
            }
        }, animated: animated)
    }

    public func apply(toTextField textField: UITextField?, animated: Bool = true) {
        guard let textField = textField else { return }

        apply(block: {
            if let font = self.font {
                textField.font = font
            }
            if let textColor = self.textColor {
                textField.textColor = textColor
            }
        }, animated: animated)
    }

    public func apply(toButton button: UIButton?, controlState: UIControlState = .normal, animated: Bool = true) {
        guard let button = button else { return }

        apply(block: {
            if let font = self.font {
                button.titleLabel?.font = font
            }
            if let textColor = self.textColor {
                button.setTitleColor(textColor, for: controlState)
            }
        }, animated: animated)
    }

    public func apply(to: Any?, animated: Bool = true) {
        if let label = to as? UILabel {
            apply(toLabel: label, animated: animated)
        } else if let textField = to as? UITextField {
            apply(toTextField: textField, animated: animated)
        } else if let button = to as? UIButton {
            apply(toButton: button, animated: animated)
        } 
    }

}
