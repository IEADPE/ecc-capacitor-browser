import Foundation
import SafariServices

@objc public enum BrowserEvent: Int {
    case loaded
    case finished
    case loggedIn
}

@objc public class Browser: NSObject, SFSafariViewControllerDelegate, UIPopoverPresentationControllerDelegate {
    private var safariViewController: SFSafariViewController?
    public typealias BrowserEventCallback = (BrowserEvent, String) -> Void

    @objc public var browserEventDidOccur: BrowserEventCallback?
    @objc var viewController: UIViewController? {
        return safariViewController
    }

    @objc public func prepare(for url: URL, withTint tint: UIColor? = nil, modalPresentation style: UIModalPresentationStyle = .fullScreen) -> Bool {
        if safariViewController == nil, let scheme = url.scheme?.lowercased(), ["http", "https"].contains(scheme) {
            let safariVC = SFSafariViewController(url: url)
            safariVC.delegate = self
            if let color = tint {
                safariVC.preferredBarTintColor = color
            }
            safariVC.modalPresentationStyle = style
            if style == .popover {
                DispatchQueue.main.async {
                    safariVC.popoverPresentationController?.delegate = self
                }
            }
            safariViewController = safariVC
            return true
        }
        return false
    }

    @objc public func cleanup() {
        safariViewController = nil
    }

    public func safariViewController(_ controller: SFSafariViewController,initialLoadDidRedirectTo URL: URL){

           let urlString = URL.absoluteString
           let containsLoginGoogle = urlString.contains("login-social-google-redirect")
           let containsLoginApple = urlString.contains("login-social-apple-redirect")
           let containsLoginMicrosoft = urlString.contains("login-social-microsoft-redirect")
           if containsLoginGoogle {
               browserEventDidOccur?(.loggedIn, urlString)
               controller.dismiss(animated: true, completion: nil)
           } else if containsLoginApple {
               browserEventDidOccur?(.loggedIn, urlString)
               controller.dismiss(animated: true, completion: nil)
           } else if containsLoginMicrosoft {
               browserEventDidOccur?(.loggedIn, urlString)
               controller.dismiss(animated: true, completion: nil)
           }
    }

    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        browserEventDidOccur?(.finished, "")
        safariViewController = nil
    }

    public func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity] {
        return []
    }

    public func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        browserEventDidOccur?(.loaded, "")
    }

    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        browserEventDidOccur?(.finished, "")
        safariViewController = nil
    }

    public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        browserEventDidOccur?(.finished, "")
        safariViewController = nil
    }
}
