import Foundation
import Alamofire
import RxSwift

public class HttpRequest: NSObject {
    @MainActor public static let Singleton = HttpRequest()
    private let manager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        return Alamofire.Session(configuration: configuration)
    }()

    public func post<Parameters: Encodable & Sendable>(url: String, parameter: Parameters, headers: [String: String]? = nil) -> Single<HttpStatus<Data>> {
        Single<HttpStatus<Data>>.create { [manager] closure in
            let httpHeaders = headers.map(HTTPHeaders.init)
            let request = manager.request(url, method: .post, parameters: parameter, headers: httpHeaders).response(queue:.global()) {
                response in
                switch response.result {
                case .success(let data):
                    if let d = data {
                        closure(.success(.data(d)))
                    } else {
                        closure(.failure(AppError("http data == nil")))
                    }
                case .failure(let error):
                    closure(.failure(AppError(error)))
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    // 若要api回傳Code != 1以及Result != 200就會顯示錯誤訊息，ApiService要選這個。Code != 1 且 Result != 200 的狀態就只會回傳error不會回傳data
    public func postDecodeApiResult<Parameters: Encodable & Sendable,T:BaseResultResponse>(url: String, parameter: Parameters, headers: [String: String]? = nil) -> Single<HttpStatus<T>> {
        post(url: url, parameter: parameter, headers: headers).flatMap{  status -> Single<HttpStatus<T>> in
             switch status{
             case .data(let d):
                do{
                    let result:T = try ResultDecoder.parserBaseResult(d)
                    return Single.just(HttpStatus<T>.data(result))
                }catch let error as AppError{
                    return Single.just(HttpStatus<T>.error(error))
                }
             case .error(let e):
                 return Single.just(HttpStatus<T>.error(e))
             }
        }
    }
    
    // 若要把api的Code及Result pass給前端去判斷，ApiService要選這個
    public func postDecodeApiResultWithFullData<Parameters: Encodable & Sendable,T:BaseResultResponse>(url: String, parameter: Parameters, headers: [String: String]? = nil) -> Single<HttpStatus<T>> {
        post(url: url, parameter: parameter, headers: headers).flatMap{  status -> Single<HttpStatus<T>> in
             switch status{
             case .data(let d):
                do{
                    let result:T = try ResultDecoder.parser(d)
                    return Single.just(HttpStatus<T>.data(result))
                }catch let error as AppError{
                    return Single.just(HttpStatus<T>.error(error))
                }
             case .error(let e):
                 return Single.just(HttpStatus<T>.error(e))
             }
        }
    }
}



