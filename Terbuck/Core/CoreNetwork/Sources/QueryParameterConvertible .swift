//
//  QueryParameterConvertible .swift
//  Core
//
//  Created by ParkJunHyuk on 5/23/25.
//

import Foundation

protocol QueryParameterConvertible: Encodable {
    func toQueryItems() -> [URLQueryItem]
}

extension QueryParameterConvertible {
    func toQueryItems() -> [URLQueryItem] {
        guard let data = try? JSONEncoder().encode(self),
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return []
        }

        return dict.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
    }
}
