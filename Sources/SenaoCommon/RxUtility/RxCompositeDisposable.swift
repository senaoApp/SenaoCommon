import Foundation
import RxSwift

public struct RxCompositeDisposable {
    public let compositeDisposable = CompositeDisposable()
    private var disposeKeyArray = [CompositeDisposable.DisposeKey]()

    public init() {
    }

    public mutating func insert(_ disposable: Disposable) {
        if let key = compositeDisposable.insert(disposable) {
            disposeKeyArray.append(key)
        }
    }

    public mutating func disposeKeyCount() -> Int {
        disposeKeyArray.count
    }


    public mutating func clear() {
        disposeKeyArray.forEach { key in
            compositeDisposable.remove(for: key)
        }

    }

    public mutating func dispose() {
        compositeDisposable.dispose()
    }
}
