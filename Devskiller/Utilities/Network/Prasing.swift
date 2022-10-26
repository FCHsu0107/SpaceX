import Foundation
import Combine

func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, HTTPClientError> {
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .secondsSince1970
    print(data)

  return Just(data)
    .decode(type: T.self, decoder: decoder)
    .mapError { error in
            .decodeError(message: error.localizedDescription)
    }
    .eraseToAnyPublisher()
}
