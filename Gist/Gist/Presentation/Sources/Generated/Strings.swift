// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Bookmarks {
    /// Bookmarks
    internal static let title = L10n.tr("Localizable", "bookmarks.title")
  }

  internal enum EmptyState {
    /// There is nothing here so far.
    internal static let message = L10n.tr("Localizable", "emptyState.message")
  }

  internal enum Error {
    internal enum Connection {
      /// Check your connection and try again.
      internal static let message = L10n.tr("Localizable", "error.connection.message")
      /// No internet connection
      internal static let title = L10n.tr("Localizable", "error.connection.title")
    }
    internal enum Content {
      /// Something went wrong.
      internal static let message = L10n.tr("Localizable", "error.content.message")
      /// Ooops
      internal static let title = L10n.tr("Localizable", "error.content.title")
    }
    internal enum Empty {
      /// There is nothing here so far.
      internal static let message = L10n.tr("Localizable", "error.empty.message")
      /// Nothing found
      internal static let title = L10n.tr("Localizable", "error.empty.title")
    }
    internal enum Generic {
      /// Looks like we are having some internal errors. Try again later
      internal static let message = L10n.tr("Localizable", "error.generic.message")
      /// Ops! Something went wrong
      internal static let title = L10n.tr("Localizable", "error.generic.title")
    }
  }

  internal enum ErrorState {
    /// Tap to reload
    internal static let button = L10n.tr("Localizable", "errorState.button")
  }

  internal enum General {
    /// Ok
    internal static let ok = L10n.tr("Localizable", "general.ok")
  }

  internal enum GistDetails {
    /// Created on %@
    internal static func creationDate(_ p1: Any) -> String {
      return L10n.tr("Localizable", "gistDetails.creationDate", String(describing: p1))
    }
    /// Gist
    internal static let title = L10n.tr("Localizable", "gistDetails.title")
  }

  internal enum GistList {
    /// Discover
    internal static let title = L10n.tr("Localizable", "gistList.title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    Bundle(for: BundleToken.self)
  }()
}
// swiftlint:enable convenience_type
