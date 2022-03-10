// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Txt {

  internal enum Cart {
    /// CHECKOUT
    internal static let checkout = Txt.tr("Localization", "Cart.Checkout")
    /// CART
    internal static let title = Txt.tr("Localization", "Cart.Title")
    /// Total
    internal static let total = Txt.tr("Localization", "Cart.Total")
  }

  internal enum Drinks {
    /// DRINKS
    internal static let title = Txt.tr("Localization", "Drinks.Title")
  }

  internal enum Home {
    /// NENNO'S PIZZA
    internal static let title = Txt.tr("Localization", "Home.Title")
  }

  internal enum PizzaDetails {
    /// ADD TO CART ($%@)
    internal static func addToCart(_ p1: Any) -> String {
      return Txt.tr("Localization", "PizzaDetails.AddToCart", String(describing: p1))
    }
    /// Custom Pizza
    internal static let customPizza = Txt.tr("Localization", "PizzaDetails.CustomPizza")
    /// Ingridients
    internal static let ingridientsHeader = Txt.tr("Localization", "PizzaDetails.IngridientsHeader")
  }

  internal enum Price {
    /// $%@
    internal static func currency(_ p1: Any) -> String {
      return Txt.tr("Localization", "Price.Currency", String(describing: p1))
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Txt {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
