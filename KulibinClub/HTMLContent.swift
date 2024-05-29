////
////  HTMLContent.swift
////  KulibinClub
////
////  Created by Dmitry Mikhaylov on 28.05.2024.
////
//
//import SwiftUI
//import WebKit
//import SwiftUI
//
//#Preview(body: {
//    
//})
//
//extension NSAttributedString {
//    static func themedHtml(withBody body: String, theme: Theme = .default) -> NSAttributedString {
//        // Match the HTML `lang` attribute to current localisation used by the app (aka Bundle.main).
//        let bundle = Bundle.main
//        let lang = bundle.preferredLocalizations.first
//        ?? bundle.developmentLocalization
//        ?? "ru"
//        
//        return (try? NSAttributedString(
//            data: """
//            <!doctype html>
//            <html lang="\(lang)">
//            <head>
//                <meta charset="utf-8">
//                <style type="text/css">
//                    /*
//                      Custom CSS styling of HTML formatted text.
//                      Note, only a limited number of CSS features are supported by NSAttributedString/UITextView.
//                    */
//            
//                    body {
//                        font: -apple-system-body;
//                        color: \(theme.textSecondary.hex);
//                    }
//            
//                    h1, h2, h3, h4, h5, h6 {
//                        color: \(theme.textPrimary.hex);
//                    }
//            
//                    a {
//                        color: \(theme.textInteractive.hex);
//                    }
//            
//                    li:last-child {
//                        margin-bottom: 1em;
//                    }
//                </style>
//            </head>
//            <body>
//                \(body)
//            </body>
//            </html>
//            """.data(using: .utf8)!,
//            options: [
//                .documentType: NSAttributedString.DocumentType.html,
//                .characterEncoding: NSUTF8StringEncoding,
//            ],
//            documentAttributes: nil
//        )) ?? NSAttributedString(string: body)
//    }
//
//
//// MARK: Converting UIColors into CSS friendly color hex string
//static func html(withBody body: String) -> NSAttributedString {
//        // Match the HTML `lang` attribute to current localisation used by the app (aka Bundle.main).
//        let bundle = Bundle.main
//        let lang = bundle.preferredLocalizations.first
//        ?? bundle.developmentLocalization
//        ?? "ru"
//        
//        return (try? NSAttributedString(
//            data: """
//            <!doctype html>
//            <html lang="\(lang)">
//            <head>
//                <meta charset="utf-8">
//                <style type="text/css">
//                    /*
//                      Custom CSS styling of HTML formatted text.
//                      Note, only a limited number of CSS features are supported by NSAttributedString/UITextView.
//                    */
//            
//                    body {
//                        font: -apple-system-body;
//                        color: \(UIColor.secondaryLabel.hex);
//                    }
//            
//                    h1, h2, h3, h4, h5, h6 {
//                        color: \(UIColor.label.hex);
//                    }
//            
//                    a {
//                        color: \(UIColor.systemGreen.hex);
//                    }
//            
//                    li:last-child {
//                        margin-bottom: 1em;
//                    }
//                </style>
//            </head>
//            <body>
//                \(body)
//            </body>
//            </html>
//            """.data(using: .utf8)!,
//            options: [
//                .documentType: NSAttributedString.DocumentType.html,
//                .characterEncoding: NSUTF8StringEncoding,
//            ],
//            documentAttributes: nil
//        )) ?? NSAttributedString(string: body)
//    }
//}
//
//// MARK: Converting UIColors into CSS friendly color hex string
//
//private extension UIColor {
//    var hex: String {
//        var red: CGFloat = 0
//        var green: CGFloat = 0
//        var blue: CGFloat = 0
//        var alpha: CGFloat = 0
//        
//        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
//        
//        return String(
//            format: "#%02lX%02lX%02lX%02lX",
//            lroundf(Float(red * 255)),
//            lroundf(Float(green * 255)),
//            lroundf(Float(blue * 255)),
//            lroundf(Float(alpha * 255))
//        )
//    }
//}
//struct AttributedText: UIViewRepresentable {
//    private let attributedString: NSAttributedString
//    
//    init(_ attributedString: NSAttributedString) {
//        self.attributedString = attributedString
//    }
//    
//    func makeUIView(context: Context) -> UITextView {
//        // Called the first time SwiftUI renders this "View".
//        
//        let uiTextView = UITextView()
//        
//        // Make it transparent so that background Views can shine through.
//        uiTextView.backgroundColor = .clear
//        
//        // For text visualisation only, no editing.
//        uiTextView.isEditable = false
//        
//        // Make UITextView flex to available width, but require height to fit its content.
//        // Also disable scrolling so the UITextView will set its `intrinsicContentSize` to match its text content.
//        uiTextView.isScrollEnabled = true
//        uiTextView.setContentHuggingPriority(.defaultLow, for: .vertical)
//        uiTextView.setContentHuggingPriority(.defaultLow, for: .horizontal)
//        uiTextView.setContentCompressionResistancePriority(.required, for: .vertical)
//        uiTextView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        
//        return uiTextView
//    }
//    
//    func updateUIView(_ uiTextView: UITextView, context: Context) {
//        // Called the first time SwiftUI renders this UIViewRepresentable,
//        // and whenever SwiftUI is notified about changes to its state. E.g via a @State variable.
//        uiTextView.attributedText = attributedString
//    }
//}
//// Example of a simple Theme struct.
//struct Theme {
//    let textPrimary: UIColor
//    let textSecondary: UIColor
//    let textInteractive: UIColor
//}
//
//extension Theme {
//    static let `default` = Theme(
//        textPrimary: .label,
//        textSecondary: .secondaryLabel,
//        textInteractive: .systemGreen
//    )
//}
//
//private struct ThemeEnvironmentKey: EnvironmentKey {
//    static var defaultValue: Theme = .default
//}
//
//extension EnvironmentValues {
//    var theme: Theme {
//        get { self[ThemeEnvironmentKey.self] }
//        set { self[ThemeEnvironmentKey.self] = newValue }
//    }
//}
