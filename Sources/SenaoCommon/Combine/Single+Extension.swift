

import Foundation
import RxSwift

public extension Single{
    func mainThread() -> PrimitiveSequence<Trait, Element> {
        observe(on: MainScheduler.instance)
    }
}
