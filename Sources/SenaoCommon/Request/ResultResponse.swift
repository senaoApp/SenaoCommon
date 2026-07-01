import Foundation

open class BaseResultResponse: Codable {
    public static let SUCCESS = "1"
    public static let RESULT_SUCCESS = "200"
    private var _result: Result?
    
    public init(){}
    
    public required  init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            _result = try container.decode(Result.self, forKey: ._result)
    }
    
    open var result: Result {
        get {
            _result ?? Result()
        }
    }

    enum CodingKeys: String, CodingKey {
        case _result = "RO"
    }

    public struct Result: Codable {

        private var _desc: String?
        private var _message: String?
        private var _time: String?
        private var _code: String?
        private var _timestamp: Int?
        private var _result: String?

        public init() {}

        public var desc: String {
            get {
                _desc ?? JASON_DEFAULT_TXT
            }
        }

        public var message: String {
            get {
                _message ?? JASON_DEFAULT_TXT
            }
        }

        public var time: String {
            get {
                _time ?? JASON_DEFAULT_TXT
            }
        }
        public var code: String {
            get {
                _code ?? JASON_DEFAULT_TXT
            }
        }
        public var timestamp: Int {
            get {
                _timestamp ?? JASON_DEFAULT_INT
            }
        }
        public var result: String {
            get {
                _result ?? JASON_DEFAULT_TXT
            }
        }

        enum CodingKeys: String, CodingKey {
            case _desc = "Desc"
            case _message = "Message"
            case _time = "Time"
            case _code = "Code"
            case _timestamp = "Timestamp"
            case _result = "Result"
        }
    }
}

