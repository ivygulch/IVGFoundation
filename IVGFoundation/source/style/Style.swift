//
//  Style.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 4/30/17.
//  Copyright © 2017 Ivy Gulch. All rights reserved.
//

import UIKit

public struct Style {

    fileprivate enum StyleType {
        case Font(FontStyle)
        case Container(ContainerStyle)
    }

    fileprivate let style: StyleType
    fileprivate let sizeClass: UIUserInterfaceSizeClass?
    fileprivate let userInterfaceIdiom: UIUserInterfaceIdiom?

    public init(_ fontStyle: FontStyle, sizeClass: UIUserInterfaceSizeClass? = nil, userInterfaceIdiom: UIUserInterfaceIdiom? = nil) {
        style = .Font(fontStyle)
        self.sizeClass = sizeClass
        self.userInterfaceIdiom = userInterfaceIdiom
    }

    public init(_ containerStyle: ContainerStyle, sizeClass: UIUserInterfaceSizeClass? = nil, userInterfaceIdiom: UIUserInterfaceIdiom? = nil) {
        style = .Container(containerStyle)
        self.sizeClass = sizeClass
        self.userInterfaceIdiom = userInterfaceIdiom
    }

    public func matches(sizeClass currentSizeClass: UIUserInterfaceSizeClass, userInterfaceIdiom currentUserInterfaceIdiom: UIUserInterfaceIdiom) -> Bool {
        if let sizeClass = sizeClass, sizeClass != currentSizeClass {
            return false
        }
        if let userInterfaceIdiom = userInterfaceIdiom, userInterfaceIdiom != currentUserInterfaceIdiom {
            return false
        }
        return true
    }

    public func apply(to: Any?, animated: Bool = true) {
        switch style {
        case let .Font(fontStyle):
            fontStyle.apply(to: to, animated: animated)
        case let .Container(containerStyle):
            containerStyle.apply(to: to, animated: animated)
        }
    }

}

public struct StyleSet {

    let styles: [Style]

    public init(_ styles: [Style]) {
        self.styles = styles
    }

    public func apply(to: Any?, sizeClass: UIUserInterfaceSizeClass, animated: Bool = true) {
        apply(to: [to], sizeClass: sizeClass, animated: animated)
    }

    public func apply(to: [Any?], sizeClass: UIUserInterfaceSizeClass, animated: Bool = true) {
        for item in to {
            for style in styles {
                if style.matches(sizeClass: sizeClass, userInterfaceIdiom: UIDevice.current.userInterfaceIdiom) {
                    style.apply(to: item, animated: animated)
                }
            }
        }
    }

    public func attributes(forSizeClass sizeClass: UIUserInterfaceSizeClass) -> [NSAttributedStringKey: AnyObject]  {
        var result: [NSAttributedStringKey: AnyObject] = [:]
        for style in styles {
            if style.matches(sizeClass: sizeClass, userInterfaceIdiom: UIDevice.current.userInterfaceIdiom) {
                if case let .Font(fontStyle) = style.style {
                    result.merge(fontStyle.attributes)
                }
            }
        }
        return result
    }

}

public typealias StyleSheet = [String: StyleSet]
