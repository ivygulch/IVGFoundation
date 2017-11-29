//
//  NextResponderHelper.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 11/28/17.
//  Copyright © 2017 Ivy Gulch. All rights reserved.
//

import UIKit

public protocol UITextInputTraitsWithReturnKeyType : UITextInputTraits {
    // redeclare the returnKeyType property of the parent protocol, but this time as mandatory
    var returnKeyType: UIReturnKeyType { get set }
}
extension UITextField: UITextInputTraitsWithReturnKeyType {}
extension UITextView: UITextInputTraitsWithReturnKeyType {}

public class NextResponderHelper {
    private var values: [UIResponder: UIResponder] = [:]
    private var automaticallySetReturnKeyType: Bool
    private var textFieldDelegate: UITextFieldDelegate!

    public init(automaticallySetReturnKeyType: Bool = true, textFieldDelegate: UITextFieldDelegate? = nil) {
        self.automaticallySetReturnKeyType = automaticallySetReturnKeyType
        self.textFieldDelegate = NextResponderHelperTextFieldDelegate(nextResponderHelper: self, textFieldDelegate: textFieldDelegate)
    }

    public func register(responder: UIResponder?, next nextResponder: UIResponder?) {
        guard let responder = responder else { return }
        values[responder] = nextResponder

        if automaticallySetReturnKeyType {
            if let textInputTraits = responder as? UITextInputTraitsWithReturnKeyType {
                textInputTraits.returnKeyType = (nextResponder == nil) ? .default : .next
            }
        }
        if let textField = responder as? UITextField {
            textField.delegate = textFieldDelegate
        }
    }

    @discardableResult public func finish(responder: UIResponder?) -> Bool {
        guard let responder = responder else { return false }
        guard let nextResponder = values[responder] else {
            responder.resignFirstResponder()
            return false
        }

        if Thread.isMainThread {
            nextResponder.becomeFirstResponder()
        } else {
            DispatchQueue.main.async {
                nextResponder.becomeFirstResponder()
            }
        }
        return true
    }
}

fileprivate class NextResponderHelperTextFieldDelegate: NSObject, UITextFieldDelegate {

    let nextResponderHelper: NextResponderHelper
    let textFieldDelegate: UITextFieldDelegate?

    init(nextResponderHelper: NextResponderHelper, textFieldDelegate: UITextFieldDelegate?) {
        self.nextResponderHelper = nextResponderHelper
        self.textFieldDelegate = textFieldDelegate
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextResponderHelper.finish(responder: textField)
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return textFieldDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldDelegate?.textFieldDidBeginEditing?(textField)
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return textFieldDelegate?.textFieldShouldEndEditing?(textField) ?? true
    }

    func textFieldDidEndEditing(_ textField: UITextField){
        textFieldDelegate?.textFieldDidEndEditing?(textField)
    }

    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        textFieldDelegate?.textFieldDidEndEditing?(textField, reason: reason)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textFieldDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return textFieldDelegate?.textFieldShouldClear?(textField) ?? true
    }

}

