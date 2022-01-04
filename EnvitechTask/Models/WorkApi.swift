//
//  WorkApi.swift
//  EnvitechTask
//
//  Created by yaniv shtein on 02/01/2022.
//

import Foundation
import Combine

let url = "https://e11fa232-ea43-4496-8b0f-13f41eb563f4.mock.pstmn.io/config"

struct GetData{
    //getting data
     func getData()-> AnyPublisher<Api?,Error>{
        guard let url = URL(string: url) else {return Fail(error: NSError(domain: "Missing Feed URL", code: -10001)).eraseToAnyPublisher()}
        let urlRequest = URLRequest(url: url)
        return URLSession.shared.dataTaskPublisher(for: urlRequest).tryMap { data,response -> Api in
            
            let decoder = JSONDecoder()
            
            return try decoder.decode(Api.self, from: data)
        }.receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        

            
            
    }
}
