// swiftlint:disable all
// Generated using tuist — https://github.com/tuist/tuist

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
public enum PresentationStrings {

  public enum Bookmarks {
    /// Bookmarks
    public static let title = PresentationStrings.tr("Localizable", "bookmarks.title")
  }

  public enum EmptyState {
    /// There is nothing here so far.
    public static let message = PresentationStrings.tr("Localizable", "emptyState.message")
  }

  public enum Error {
    public enum Connection {
      /// Check your connection and try again.
      public static let message = PresentationStrings.tr("Localizable", "error.connection.message")
      /// No internet connection
      public static let title = PresentationStrings.tr("Localizable", "error.connection.title")
    }
    public enum Content {
      /// Something went wrong.
      public static let message = PresentationStrings.tr("Localizable", "error.content.message")
      /// Ooops
      public static let title = PresentationStrings.tr("Localizable", "error.content.title")
    }
    public enum Empty {
      /// There is nothing here so far.
      public static let message = PresentationStrings.tr("Localizable", "error.empty.message")
      /// Nothing found
      public static let title = PresentationStrings.tr("Localizable", "error.empty.title")
    }
    public enum Generic {
      /// Looks like we are having some internal errors. Try again later
      public static let message = PresentationStrings.tr("Localizable", "error.generic.message")
      /// Ops! Something went wrong
      public static let title = PresentationStrings.tr("Localizable", "error.generic.title")
    }
  }

  public enum ErrorState {
    /// Tap to reload
    public static let button = PresentationStrings.tr("Localizable", "errorState.button")
  }

  public enum General {
    /// Ok
    public static let ok = PresentationStrings.tr("Localizable", "general.ok")
  }

  public enum GistDetails {
    /// Created on %@
    public static func creationDate(_ p1: Any) -> String {
      return PresentationStrings.tr("Localizable", "gistDetails.creationDate", String(describing: p1))
    }
    /// Gist
    public static let title = PresentationStrings.tr("Localizable", "gistDetails.title")
  }

  public enum GistList {
    /// Discover
    public static let title = PresentationStrings.tr("Localizable", "gistList.title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension PresentationStrings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = PresentationResources.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
