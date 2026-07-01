import Foundation
import UIKit

open class Alert {
    
    typealias AlertHandler = @convention(block) (UIAlertAction) -> Void
    
    @MainActor open class func show(_ vc: UIViewController, title: String, message: String, confirmBtn btnTitle: String, handler:((_ action: UIAlertAction?) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: btnTitle, style: .default, handler: handler)
        alert.addAction(alertAction)
        vc.present(alert, animated: true, completion: nil)
    }


    @MainActor open class func show(viewController: UIViewController, title: String, message: String, actions: Array<Any>) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for model in actions {
            if let data = model as? Dictionary<String, Any> {
                let actionStyle = (data["actionStyle"] as? String) ?? "0"
                let rawValue = Int(actionStyle) ?? 0
                var block:Alert.AlertHandler? = nil
                var action: UIAlertAction? = nil
                
                if let handler = data["handler"] as? AnyObject {
                    block = unsafeBitCast(handler, to: AlertHandler.self)
                }
                
                if let int = UIAlertAction.Style(rawValue: rawValue) {
                    action = UIAlertAction(title: data["btnTitle"] as? String, style: int, handler: block)
                }
                
                if let action = action {
                    alert.addAction(action)
                }
            }
        }
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
    open class func show(_ viewController: UIViewController, actions: [UIAlertAction], title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            alert.addAction(action)
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
