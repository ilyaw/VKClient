//
//  VKLoginViewController.swift
//  UserInterface
//
//  Created by Ilya on 22.03.2021.
//

import UIKit
import WebKit
import Alamofire



class VKLoginViewController: UIViewController {
    
    private let realmManager = RealmManager.shared
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        Session.shared.token = "58a91173aac68ab1fcade3ba8000c30b94bfea85d81819b7e4ab126efbfff6071a45d5164a6c3119a0794"
//        Session.shared.userId = 210404335
//        moveToTabBarController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // moveToTabBarController()
        
        //        realmManager.get
        //
        //        if Session.shared.token != nil,
        //           Session.shared.userId != nil {
        //            moveToTabBarController()
        //        }
        
        //        if true {
        //            Session.shared.token = "6bfb9c35ebcc773b15c8f65d47cf475f5f5606b1c9c52ef1dd5a222e4cb123295a4dfbc1133d616217063"
        //            Session.shared.userId = 210404335
        //            moveToTabBarController()
        //        } else {
        //
        
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
        
        //        }
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
            moveToTabBarController()
        }
    }
    
    func moveToTabBarController() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarController") as? UITabBarController else { return }
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
