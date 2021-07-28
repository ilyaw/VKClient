//
//  VKLoginViewController.swift
//  UserInterface
//
//  Created by Ilya on 22.03.2021.
//

import UIKit
import WebKit
import SwiftKeychainWrapper

class VKLoginViewController: UIViewController {
    
    private let webView: WKWebView = {
        let preferences = WKPreferences()
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.preferences = preferences
     
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    var canPresent: Bool = false
    let timeToSecnod: Double = 86400.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(webView)
        
        self.webView.navigationDelegate = self
       
        if let keychainData = KeychainWrapper.standard.string(forKey: "user") {
            let data = Data(keychainData.utf8)
            
            if let decodeUser = decode(json: data, as: KeychainUser.self) {
                
                let now = Date().timeIntervalSince1970
                let checkInterval = (now - decodeUser.date) >= timeToSecnod
                
                if !checkInterval {
                    Session.shared.token = decodeUser.token
                    Session.shared.userId = decodeUser.id
            
                    self.canPresent = true
                    return
                }
            }
        }
        
        let friendsMask = 1 << 1
        let photosMask = 1 << 2
        let wallMask = 1 << 13
        let groupsMask = 1 << 18

        let scope = friendsMask + photosMask + wallMask + groupsMask

        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "7798550"),
            URLQueryItem(name: "scope", value: "\(scope)"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.130")
        ]

        guard let url = components.url else { return }

        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.webView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.canPresent {
            moveToTabBarController()
        }
    }
}

extension VKLoginViewController: WKNavigationDelegate {
    //когда перешли на другую страницу вебкита
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url,
              url.path == "/blank.html",
              let fragment = url.fragment else {
            //Блок обработчика завершения для вызова с результатами о том, разрешать или отменить навигацию.
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                
                return dict
            }
        
        guard let token = params["access_token"],
              let userId = params["user_id"],
              let _ = Int(userId) else {
            decisionHandler(.allow)
            return
        }
        
        Session.shared.token = token
        Session.shared.userId = Int(userId)
        
        decisionHandler(.cancel)
        
        if Session.shared.token != nil,
           Session.shared.userId != nil {
            
            let user = KeychainUser(id: Session.shared.userId,
                            token: Session.shared.token,
                            date: Date().timeIntervalSince1970)
        
            let encodedUser = encode(object: user)
            KeychainWrapper.standard["user"] = encodedUser
            
            moveToTabBarController()
        }
    }
    
    func moveToTabBarController() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarController") as? UITabBarController else { return }
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension VKLoginViewController {
    func encode<T: Codable>(object: T) -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            return try encoder.encode(object)
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }

    func decode<T: Decodable>(json: Data, as class: T.Type) -> T? {
        do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(T.self, from: json)
            
            return data
        } catch {
            print("An error occurred while parsing JSON")
        }
        
        return nil
    }
}
