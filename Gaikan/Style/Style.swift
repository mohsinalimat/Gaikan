//
// This file is part of Gaikan
//
// Created by JC on 11/10/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public struct Style : DictionaryLiteralConvertible {
    private var pseudoStyles: [StylePseudoClass:StyleRule]

    public init(dictionaryLiteral elements: (StyleRule.Key, StyleRule.Value)...) {
        var attributes = Dictionary<StyleRule.Key, StyleRule.Value>()

        for (attributeName, attributeValue) in elements {
            attributes[attributeName] = attributeValue
        }

        self.init(defaultStyle: StyleRule(attributes: attributes))
    }

    public init(_ styleBlock: (inout style: StyleRule) -> ()) {
        var styleRule = StyleRule(attributes: [:])

        styleBlock(style: &styleRule)

        self.init(defaultStyle: styleRule)
    }

    private init(defaultStyle: StyleRule) {
        self.pseudoStyles = [.Normal: defaultStyle]
    }

    public func include(pseudoClass: StylePseudoClass, styleRule styleBlock: (inout style: StyleRule) -> ()) -> Style {
        var styleRule = StyleRule(attributes: [:]).extends(self.normal)
        var style = self

        styleBlock(style: &styleRule)

        style.pseudoStyles[pseudoClass] = styleRule

        return style
    }

    public mutating func include(pseudoClass: StylePseudoClass, attributes: [StyleRule.Key:StyleRule.Value]) {
        let styleRule = StyleRule(attributes: attributes).extends(self.normal)
        var style = self

        style.pseudoStyles[pseudoClass] = styleRule
    }
}

public extension Style {
    public var normal: StyleRule {
        get { return self.pseudoStyles[.Normal]! }
    }

    public var disabled: StyleRule? {
        get { return self.pseudoStyles[.Disabled] }
    }

    public var enabled: StyleRule? {
        get { return self.pseudoStyles[.Enabled] }
    }

    public var highlighted: StyleRule? {
        get { return self.pseudoStyles[.Highlighted] }
    }

    public var selected: StyleRule? {
        get { return self.pseudoStyles[.Selected] }
    }
}