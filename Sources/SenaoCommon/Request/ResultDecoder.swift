
import Foundation

public class ResultDecoder {
    public static func parserBaseResult<T>(_ data:Data) throws -> T where T : BaseResultResponse{
        do {
            let response = try JSONDecoder().decode(T.self, from: data)
            if response.result.code == BaseResultResponse.SUCCESS && response.result.result == BaseResultResponse.RESULT_SUCCESS{
                return response
            }else{
                throw AppError(response.result.desc)
            }
        }catch let e as AppError{
            throw e
        }catch{
            let errorText = "error:\(error) Json_Decoder_Error : "+String(decoding: data, as: UTF8.self)
            throw AppError(errorText)
        }
    }
    
    public static func parser<T>(_ data:Data) throws -> T where T : Codable {
        do {
            let response = try JSONDecoder().decode(T.self, from: data)
            return response
            
        }catch{
            let errorText = "error:\(error) Json_Decoder_Error : "+String(decoding: data, as: UTF8.self)
            throw AppError(errorText)
        }
    }
}
