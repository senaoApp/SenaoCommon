import Foundation
import RxSwift

public class CombineSingle<T> {
    private var single: Single<T>

    public init(subscribe: @escaping (@escaping (Result<T, Swift.Error>) -> Void) -> Disposable) {
        single = Single<T>.create { observer in
            subscribe { event in
                switch event {
                case .success(let element):
                    observer(.success(element))
                case .failure(let error):
                    observer(.failure(error))

                }
            }
        }
//        var disposeBag = DisposeBag()
//        
//        single.subscribe(onSuccess: {_ in
//            print("")
//        }, onFailure: {_ in
//            print("")
//        })
    
    }

    public init(s: Single<T>) {
        single = s
    }

    public init(_ t:T){
        single = Single.just(t)
    }

    public func backgroundThread() -> CombineSingle<T> {
        single = single.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
        return self
    }

    public func mainThread() -> CombineSingle<T> {
        single = single.observe(on: MainScheduler.instance)
        return self
    }

    public func flatMap<Result>(_ selector: @escaping (T) throws -> Single<Result>) -> CombineSingle<Result> {
        CombineSingle<Result>(s: single.flatMap(selector))
    }

    public func subscribe(onSuccess: ((T) -> Void)? = nil,
                          onError: @escaping (Swift.Error) -> Void,
                          onDisposed: (() -> Void)? = nil,
                          by bag: DisposeBag = DisposeBag()) {
        single.subscribe(onSuccess: onSuccess, onFailure: onError, onDisposed: onDisposed).disposed(by: bag)
    }
}
