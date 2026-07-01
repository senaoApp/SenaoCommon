import Foundation
import UIKit

open class Browser {
    public enum ErrorMessage:Int{
        case urlNil = 0
        case notOpenUrl = 1
    }
    
    open class func openUrl(urlStr: String, vc: UIViewController? = nil ,_ error: ((_ message: ErrorMessage) -> Void)? = nil) {
        if let url = URL(string: urlStr) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                error?(ErrorMessage.notOpenUrl)
            }
        } else {
            error?(ErrorMessage.urlNil)
        }
    }
    
    open class func openUrl(url: URL,_ error: ((_ message: ErrorMessage) -> Void)? = nil) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            error?(ErrorMessage.notOpenUrl)
         }
    }

    open class func forceOpenUrlOpenUrl(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

}
