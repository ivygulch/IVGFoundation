//
//  UIView+IVGFoundation
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 6/15/16.
//  Copyright © 2017 Ivy Gulch. All rights reserved.
//

import UIKit

public extension UIView {

    public class func loadFromNIB(_ nibNameOrNil: String? = nil) -> Self? {
        return loadFromNIB(nibNameOrNil, type: self)
    }

    public class func loadFromNIB<T : UIView>(_ nibNameOrNil: String? = nil, type: T.Type) -> T? {
        let name = nibNameOrNil ?? String(describing: self).components(separatedBy: ".").first!
        let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        for nibView in nibViews! {
            if let result = nibView as? T {
                return result
            }
        }
        return nil
    }

}

public enum NSLayoutConstraintPosition {
    case First
    case Second
}

public typealias NSLayoutConstraintMatcher = ((NSLayoutConstraint,UIView,NSLayoutConstraintPosition,NSLayoutConstraint.Attribute,NSLayoutConstraint.Relation,AnyObject?) -> Bool)
public typealias NSLayoutConstraintAndOwner = (NSLayoutConstraint,UIView)

public extension UIView {

    public func firstConstraint(matchingAttribute: NSLayoutConstraint.Attribute, relation matchingRelation: NSLayoutConstraint.Relation) -> NSLayoutConstraintAndOwner? {
        let constraints = relatedConstraints() { (constraint,owner,position,attribute,relation,otherItem) -> Bool in
            return attribute == matchingAttribute && relation == matchingRelation
        }
        return constraints.first
    }

    public func relatedConstraints(matcher: NSLayoutConstraintMatcher? = nil) -> [NSLayoutConstraintAndOwner] {
        let constraintsAndOwners = relatedConstraints(toView: self)
        guard let matcher = matcher else { return constraintsAndOwners }

        var result: [NSLayoutConstraintAndOwner] = []
        for (constraint, owner) in constraintsAndOwners {
            if let firstView = constraint.firstItem as? UIView, firstView == self {
                if matcher(constraint, owner, .First, constraint.firstAttribute, constraint.relation, constraint.secondItem) {
                    result.append((constraint, owner))
                }
            } else if let secondView = constraint.secondItem as? UIView, secondView == self {
                if matcher(constraint, owner, .Second, constraint.secondAttribute, reverseRelation(relation: constraint.relation), constraint.secondItem) {
                    result.append((constraint, owner))
                }
            }
        }
        return result
    }

    private func reverseRelation(relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint.Relation {
        switch relation {
        case .lessThanOrEqual: return .greaterThanOrEqual
        case .equal: return .equal
        case .greaterThanOrEqual: return .lessThanOrEqual
        }
    }

    private func relatedConstraints(toView viewToCheck: UIView) -> [NSLayoutConstraintAndOwner] {
        var result: [NSLayoutConstraintAndOwner] = []
        for constraint in constraints {
            // NSContentSizeLayoutConstraint is the internal intrinsic size constraint used
            if String(describing: type(of: constraint)) != "NSContentSizeLayoutConstraint" {
                if let firstView = constraint.firstItem as? UIView, firstView == viewToCheck {
                    result.append((constraint, self))
                } else if let secondView = constraint.secondItem as? UIView, secondView == viewToCheck {
                    result.append((constraint, self))
                }
            }
        }
        if let parentView = superview {
            result += parentView.relatedConstraints(toView: viewToCheck)
        }
        return result
    }
}
