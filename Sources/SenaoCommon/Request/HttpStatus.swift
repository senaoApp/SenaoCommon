//
// Created by Neo on 2021/4/29.
//

import Foundation

public enum HttpStatus<T>{
    case data(_ result:T)
    case error(_ error:AppError)
}

public enum WebviewViewModelState {
    case data(_ width: CGFloat,_ height:CGFloat)
    case error(_ error: AppError)
}

public enum AppError: Error, CustomStringConvertible{

    case message(String)
    case generic(Error)
    case result(BaseResultResponse.Result)
    public var description: String{
        switch self {
        case let .message(message):
            return message
        case let .generic(error):
            return "網路連線異常 錯誤代碼 : \((error as NSError).localizedDescription)"
        case let .result(v):
            return v.desc + v.message
        }
    }
    public init(_ message: String) {
        self = .message(message)
        
    }

    public init(_ error: Error) {
        if let error = error as? AppError {
            self = error
        } else {
            self = .generic(error)
        }
    }
    
    public init(_ error: BaseResultResponse.Result) {
        self = .result(error)
    }
}
