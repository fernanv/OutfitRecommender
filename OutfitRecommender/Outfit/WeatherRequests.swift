//
//  PeticionesTiempo.swift
//  Armario
//
//  Created by Fernando Villalba  on 7/5/22.
//

import Alamofire
import LocationPickerViewController

class WeatherRequests {
    
    let apiKey: String
    let language: String
    var location: LocationItem?
    
    init(){
        apiKey = "rAkyLj9XPRAl1ROe5tjU1h2nND9flfxb"
        language = "es"
    }
    
    func cityRequest(callback: @escaping (Result<Location, Error>) -> Void){
        let cityURLString = "https://dataservice.accuweather.com/locations/v1/cities/geoposition/search?apikey=\(apiKey)&q=\(location?.coordinate?.latitude ?? 0),\(location?.coordinate?.longitude ?? 0)"
        AF.request(cityURLString, method: .get)
            .validate(statusCode: 200..<600)
            .responseDecodable(of: Location.self){ response in
                switch response.result {
                    case let .success(response):
                        callback(.success(response))
                    case let .failure(error):
                        callback(.failure(error))
                }
        }
    }
    
    func weatherRequest(cityKey: String, callback: @escaping (Result<LocationWeather, Error>) -> Void){
        let weatherURLString = "https://dataservice.accuweather.com/forecasts/v1/daily/5day/\(cityKey)?apikey=\(apiKey)&language=\(language)&metric=true"
        AF.request(weatherURLString, method: .get)
            .validate(statusCode: 200..<600)
            .responseDecodable(of: LocationWeather.self){ response in
                switch response.result {
                    case let .success(response):
                        callback(.success(response))
                    case let .failure(error):
                        callback(.failure(error))
                }
        }
    }
    
    
}


