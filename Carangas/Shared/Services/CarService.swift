//
//  CarService.swift
//  Carangas
//
//  Created by Yuri Cunha on 25/10/23.
//

import Foundation

enum CarServiceError: Error {
    case badURL
    case taskError
    case noResponse
    case invalidStatusCode(Int)
    case decodingError
    case unknown
    
    
    var errorMessage: String {
        switch self {
        case .badURL:
            return "URL invalido!"
        case .taskError:
            return "Erro de conexao"
        case .noResponse:
            return "Servidor nao enviou uma resposta"
        case .invalidStatusCode(let statusCode):
            return "Status code invalido: \(statusCode)"
        case .decodingError:
            return "Erro de Decoding"
        case .unknown:
            return "Erro desconhecido"
        }
    }
}

final class CarService {
    
    private let basePath = "https://carangas.herokuapp.com/cars"
    private let configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default //.default: padrao, .ephemeral: "modo anonimo", .backgroumd(withIdentifier:): dataTask com o app em background
        configuration.allowsCellularAccess = true // define se pode ou nao usar o 4G
        configuration.timeoutIntervalForRequest = 10 //60 segundos para esperar a requisicao por padrao
        configuration.httpAdditionalHeaders = ["Content-Type" : "application/json"]
        configuration.httpMaximumConnectionsPerHost = 6 //significa dizer que pode ser feito ate 5 chamadas a api ao mesmo tempo, por padrao 6
        return configuration
    }()
    
    private lazy var session = URLSession(configuration: configuration)
    
    func loadCars() async -> Result<[Car],CarServiceError> {
        guard let url = URL(string: basePath) else {
            return .failure(.badURL)
        }
        
        do {
            let (data,response) = try await session.data(from: url)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
            if !(200...299  ~= response.statusCode) {
                return .failure(.invalidStatusCode(response.statusCode))
            }
            
            if let cars = try? JSONDecoder().decode([Car].self, from: data) {
                return .success(cars)
            } else {
                return .failure(.decodingError)
            }
            
            
        } catch {
            print(error)
            
        }
        return .failure(.badURL)
    }
    
    @discardableResult func createCar(_ car: Car) async -> Result<Void,CarServiceError> {
        await request(httpMethod: "POST", car: car)
    }
    @discardableResult func deleteCar(_ car: Car) async -> Result<Void,CarServiceError> {
        await request(httpMethod: "DELETE", car: car)
    }
    @discardableResult func updateCar(_ car: Car) async -> Result<Void,CarServiceError> {
        await request(httpMethod: "PUT", car: car)
    }
    
    
    private func request(httpMethod: String, car: Car) async -> Result<Void,CarServiceError> {
        
        let urlString = basePath + "/" + (car._id ?? "")
        guard let url = URL(string: urlString) else {
            return .failure(.badURL)
        }
        
        do {
            //let (data,response) = try await session.data(from: url) usado para requisicoes do tipo GET, nao usaremos get agora
            
            var request = URLRequest(url:url)
            
            request.httpMethod = httpMethod
            request.httpBody = try JSONEncoder().encode(car)
            let (_,response) = try await session.data(for: request)
        
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
          
            if !(200...299 ~= response.statusCode) {
                return .failure(.invalidStatusCode(response.statusCode))
            }
            return .success(())

 
            
        } catch {
            print(error)
            
        }
        return .failure(.badURL)
    }
    
}
