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

    public func post<Parameters: Encodable & Sendable>(url: String, parameter: Parameters) -> Single<HttpStatus<Data>> {
        Single<HttpStatus<Data>>.create { closure in
            let request = AF.request(url, method: .post, parameters: parameter).response(queue:.global()) {
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
    //若要api回傳Code != 1以及Result != 200就會顯示錯誤訊息，ApiService要選這個。Code != 1且Result != 200的狀態就只會回傳error不會回傳data
    public func postDecodeApiResult<Parameters: Encodable & Sendable,T:BaseResultResponse>(url: String, parameter: Parameters) -> Single<HttpStatus<T>> {
        post(url: url, parameter: parameter).flatMap{  status -> Single<HttpStatus<T>> in
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
    //若要把api的Code及Result pass給前端去判斷，ApiService要選這個
    public func postDecodeApiResultWithFullData<Parameters: Encodable & Sendable,T:BaseResultResponse>(url: String, parameter: Parameters) -> Single<HttpStatus<T>> {
        post(url: url, parameter: parameter).flatMap{  status -> Single<HttpStatus<T>> in
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
    
    
//    public func post2<Parameters: Encodable>(url: String, parameter: Parameters) -> CombineSingle<HttpStatus<Data>> {
//        CombineSingle<HttpStatus<Data>> { closure in
//            let request = AF.request(url, method: .post, parameters: parameter).response(queue:.global()) {
//                response in
//                switch response.result {
//                case .success(let data):
//                    if let d = data {
//                        closure(.success(.data(d)))
//                    } else {
//                        closure(.success(.error(AppError("http data == nil"))))
//                        //closure(.failure(AppError("http data == nil")))
//                    }
//                case .failure(let error):
//                    closure(.success(.error(AppError(error))))
//                    //closure(.failure(AppError(error)))
//                }
//            }
//            return Disposables.create {
//                request.cancel()
//            }
//        }
//    }
//
//    public func postDecodeApiResult2<Parameters: Encodable,T:BaseResultResponse>(url: String, parameter: Parameters) -> CombineSingle<HttpStatus<T>> {
//        post2(url: url, parameter: parameter).flatMap{  status -> Single<HttpStatus<T>> in
//             switch status{
//             case .data(let d):
//                 do {
//                     let response = try JSONDecoder().decode(T.self, from: d)
//                     if response.result.code == BaseResultResponse.SUCCESS{
//                         return Single.just(HttpStatus<T>.data(response))
//                     }else{
//                         return Single.just(HttpStatus<T>.error(AppError(response.result.desc)))
//                     }
//                 }catch{
//                     let errorText = "error:\(error) Json_Decoder_Error : "+String(decoding: d, as: UTF8.self)
//                     return Single.just(HttpStatus<T>.error(AppError(errorText)))
//                 }
//             case .error(let e):
//                 return Single.just(HttpStatus<T>.error(e))
//             }
//        }
//    }
}



