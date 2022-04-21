//
//  ShareViewController.swift
//  share
//
//  Created by aanorbel on 4/21/22.
//  Copyright © 2022 OONI. All rights reserved.
//

import UIKit
import Social
import CoreServices
/*

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
*/


class ShareViewController: UIViewController {

    private let typeText = String(kUTTypeText)
    private let typeURL = String(kUTTypeURL)
    private let appURL = "ooni://"
    private let groupName = "group.org.openobservatory.ooniprobe"
    private let urlDefaultName = "incomingURL"

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 1
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let itemProvider = extensionItem.attachments?.first else {
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            return
        }

        if itemProvider.hasItemConformingToTypeIdentifier(typeText) {
            handleIncomingText(itemProvider: itemProvider)
        } else if itemProvider.hasItemConformingToTypeIdentifier(typeURL) {
            handleIncomingURL(itemProvider: itemProvider)
        } else {
            print("Error: No url or text found")
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }

    private func handleIncomingText(itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: typeText, options: nil) { (item, error) in
            if let error = error { print("Text-Error: \(error.localizedDescription)") }


            if let text = item as? String {
                do {// 2.1
                    let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                    let matches = detector.matches(
                            in: text,
                            options: [],
                            range: NSRange(location: 0, length: text.utf16.count)
                    )
                    // 2.2
                    if let firstMatch = matches.first, let range = Range(firstMatch.range, in: text) {
                        self.saveURLString(String(text[range]))
                    }
                } catch let error {
                    print("Do-Try Error: \(error.localizedDescription)")
                }
            }

            self.openMainApp()
        }
    }

    private func handleIncomingURL(itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: typeURL, options: nil) { (item, error) in
            if let error = error { print("URL-Error: \(error.localizedDescription)") }

            if let url = item as? NSURL, let urlString = url.absoluteString {
                self.saveURLString(urlString)
            }

            self.openMainApp()
        }
    }

    private func saveURLString(_ urlString: String) {
        UserDefaults(suiteName: self.groupName)?.set(urlString, forKey: self.urlDefaultName)
    }

    private func openMainApp() {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: { _ in
            guard let url = URL(string: self.appURL) else { return }
            _ = self.openURL(url)
        })
    }

    // Courtesy: https://stackoverflow.com/a/44499222/13363449 👇🏾
    // Function must be named exactly like this so a selector can be found by the compiler!
    // Anyway - it's another selector in another instance that would be "performed" instead.
    @objc private func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
}
