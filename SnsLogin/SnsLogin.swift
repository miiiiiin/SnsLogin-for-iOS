//
//  SnsLogin.swift
//  SnsLogin
//
//  Created by GlobalHumanism on 2018. 12. 7..
//  Copyright © 2018년 GlobalHumanism. All rights reserved.
//

import UIKit
import NaverThirdPartyLogin


class SnsLogin : UIViewController, NaverThirdPartyLoginConnectionDelegate{
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    static let shared = SnsLogin()
   

    func naverLogin() {
        
        
        
        let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
        loginInstance?.delegate = self
        loginInstance?.requestThirdPartyLogin()
        
        guard let tokenType = loginInstance!.tokenType else {return}
        guard let accessToken = loginInstance!.accessToken else {return}
        
        //Mark: 네이버 얼러트 뷰 생성
        let alert = UIAlertController(title: "토큰 정보", message: "\(accessToken)", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: 네이버 앱 미설치 시 인증 진행 화면 띄움
    func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
        let signIn = NLoginThirdPartyOAuth20InAppBrowserViewController(request: request)
        present(signIn!, animated: true, completion: nil)
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("접근 토큰 정보 수신 성공 ")
        
        guard let accessToken = NaverThirdPartyLoginConnection.getSharedInstance()?.accessToken else {return}
        SnsLogin.shared.naverLogin()
    }//로그인 성공 시 accessToken 메서드로 접근 토큰 정보 얻어옴
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        loginInstance?.isValidAccessTokenExpireTimeNow() // 접근 토큰 유효한지 확인
        print("접근 토큰 재발급 요청")
        SnsLogin.shared.naverLogin()
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("토큰 삭제")
        
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print(error)
    }

}