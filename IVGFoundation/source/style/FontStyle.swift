//
//  FontStyle.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 1/26/17.
//  Copyright © 2017 Ivy Gulch LLC. All rights reserved.
//

import UIKit

public enum FontType {
    // System fonts are special cases. Apple says the actual font names for them are private, so set up special flags
    case system(CGFloat?)
    case custom(String)

    public func font(withSize size: CGFloat) -> UIFont? {
        switch self {
        case let .system(weight):
            if let weight = weight {
                return UIFont.systemFont(ofSize: size, weight: weight)
            } else {
                return UIFont.systemFont(ofSize: size)
            }
        case let .custom(family):
            return UIFont(name: family, size: size)
        }
    }

}

public extension FontType {
    public static let systemRegular = FontType.system(nil)
    public static let systemSemibold = FontType.system(UIFontWeightSemibold)
    public static let systemBold = FontType.system(UIFontWeightBold)
    public static let systemMedium = FontType.system(UIFontWeightMedium)
}

public struct FontStyleConstants {
    public static let defaultSize: CGFloat = 12.0

}
public struct FontStyle {
    public let type: FontType?
    public let size: CGFloat
    public let textColor: UIColor?
    public var font: UIFont?

    public init(style: FontStyle? = nil, type: FontType? = nil, size: CGFloat? = nil, textColor: UIColor? = nil) {
        self.type = type ?? style?.type
        self.size = size ?? style?.size ?? FontStyleConstants.defaultSize
        self.textColor = textColor ?? style?.textColor

        if let type = self.type {
            if let font = type.font(withSize: self.size) {
                self.font = font
            } else {
                print("WARNING: Could not load font: \(String(describing: self.type)) \(self.size)")
                self.font = nil
            }
        } else {
            self.font = nil
        }
    }

    public func setType(_ type: FontType) -> FontStyle {
        return FontStyle(style: self, type: type)
    }

    public func setSize(_ size: CGFloat) -> FontStyle {
        return FontStyle(style: self, size: size)
    }

    public func setTextColor(_ textColor: UIColor?) -> FontStyle {
        return FontStyle(style: self, textColor: textColor)
    }

    public func setFont(_ font: UIFont) -> FontStyle {
        return FontStyle(style: self, type: .custom(font.familyName), size: font.pointSize)
    }

    public func style(type: FontType? = nil, size: CGFloat? = nil, textColor: UIColor? = nil) -> FontStyle {
        let useType = type ?? self.type
        let useSize = size ?? self.size
        let useTextColor = textColor ?? self.textColor
        return FontStyle(type: useType, size: useSize, textColor: useTextColor)
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

    public func apply(toTextView textView: UITextView?, animated: Bool = true) {
        guard let textView = textView else { return }

        apply(block: {
            if let font = self.font {
                textView.font = font
            }
            if let textColor = self.textColor {
                textView.textColor = textColor
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
        } else if let textView = to as? UITextView {
            apply(toTextView: textView, animated: animated)
        } else if let button = to as? UIButton {
            apply(toButton: button, animated: animated)
        }
    }

    public var attributes: [String: AnyObject]  {
        var result: [String: AnyObject] = [:]
        if let textColor = textColor {
            result[NSForegroundColorAttributeName] = textColor
        }
        if let font = font {
            result[NSFontAttributeName] = font
        }
        return result
    }
    
}
