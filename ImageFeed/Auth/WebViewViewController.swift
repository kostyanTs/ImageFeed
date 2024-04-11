//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Konstantin on 10.04.2024.
//

import UIKit
import WebKit

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

class WebViewViewController: UIViewController {
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        loadAuthView()
    }
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            return
        }  //1
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),                  //2
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURL),             //3
           URLQueryItem(name: "response_type", value: "code"),                 //4
            URLQueryItem(name: "scope", value: Constants.accessScope)                     //5
         ]
        guard let url = urlComponents.url else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,                         //1
            let urlComponents = URLComponents(string: url.absoluteString),  //2
            urlComponents.path == "/oauth/authorize/native",                //3
            let items = urlComponents.queryItems,                           //4
            let codeItem = items.first(where: { $0.name == "code" })        //5
        {
            return codeItem.value                                           //6
        } else {
            return nil
        }
    }

}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) { //1
                    delegate?.webViewViewController(self, didAuthenticateWithCode: code)
                    decisionHandler(.cancel)
                } else {
                    decisionHandler(.allow) 
                }
    }
}
