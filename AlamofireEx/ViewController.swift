//
//  ViewController.swift
//  AlamofireEx
//
//  Created by Jeongguk Kim on 2021/08/19.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Alamofire.request("https://api.github.com/users", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                if let jsonvalue = response.result.value {
                    do{
                        let data = try JSONSerialization.data(withJSONObject: jsonvalue, options: .prettyPrinted)
                        let value = ViewController.parseUserInfo(data)
                        print(value)
                    }
                    catch {
                        
                    }
                }
        }
    }
    
    static func parseUserInfo(_ data: Data) -> [Values] {
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(Response.self, from: data)
            let user = response.value
            print("******\(user)")
            return user
        }catch let error {
            print("-->parsing error: \(error.localizedDescription)")
            return []
        }
    }


}

struct Response: Codable {
    let resultCount: Int
    let value: [Values]
}
struct Values: Codable {
    let id: Int
    let login: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
    }
}

