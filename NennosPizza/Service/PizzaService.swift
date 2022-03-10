//
//  PizzaService.swift
//  NennosPizza
//
//  Created by kristof on 2021. 10. 12..
//

import Foundation
import RxSwift
import Alamofire
import RxRelay

protocol PizzaServiceUseCase {
    func getPizzas() -> Single<PizzaResponse>
    func getIngridients() -> Single<[Ingridient]>
    func getDrinks() -> Single<[Drink]>
    func checkout(cart: Cart)
}

struct PizzaService: PizzaServiceUseCase {

    func getPizzas() -> Single<PizzaResponse> {
        request(urlConvertible: PizzaServiceRouter.pizzas)
    }

    func getIngridients() -> Single<[Ingridient]> {
        request(urlConvertible: PizzaServiceRouter.ingridients)
    }

    func getDrinks() -> Single<[Drink]> {
        request(urlConvertible: PizzaServiceRouter.drinks)
    }

    func checkout(cart: Cart) {
        // TODO: decode response
        // request(urlConvertible: PizzaServiceRouter.checkout(cart: cart))
    }

    private func request<T: Decodable>(urlConvertible: URLRequestConvertible) -> Single<T> {
        return Single<T>.create { single in
            let request = AF.request(urlConvertible)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case let .success(value):
                        single(.success(value))
                    case let .failure(error):
                        single(.failure(error))
                    }
                }

            return Disposables.create {
                request.cancel()
            }
        }
    }
}

extension PizzaService {
    enum PizzaServiceRouter: URLRequestConvertible {
        case pizzas
        case ingridients
        case drinks
        case checkout(cart: Cart)

        func asURLRequest() throws -> URLRequest {
            let url = try baseUrl.asURL()

            var urlRequest = URLRequest(url: url.appendingPathComponent(path))

            urlRequest.httpMethod = method.rawValue

            if let httpBody = body {
                urlRequest.httpBody = httpBody
            }

            let encoding: ParameterEncoding = {
                switch method {
                case .get:
                    return URLEncoding.default
                default:
                    return JSONEncoding.default
                }
            }()

            return try encoding.encode(urlRequest, with: parameters)
        }

        private var baseUrl: String {
            switch self {
            case .pizzas, .ingridients, .drinks:
                return "https://doclerlabs.github.io/mobile-native-challenge"
            case .checkout:
                return "http://httpbin.org"
            }
        }

        private var method: HTTPMethod {
            switch self {
            case .pizzas, .ingridients, .drinks:
                return .get
            case .checkout:
                return .post
            }
        }

        private var path: String {
            switch self {
            case .pizzas:
                return "/pizzas.json"
            case .ingridients:
                return "/ingredients.json"
            case .drinks:
                return "/drinks.json"
            case .checkout:
                return "/post"
            }
        }

        private var parameters: Parameters? {
            switch self {
            default :
                return nil
            }
        }

        private var body: Data? {
            switch self {
            case let .checkout(cart):
                do {
                    return try JSONEncoder().encode(cart)
                } catch { return nil }
            default:
                return nil
            }
        }
    }
}
