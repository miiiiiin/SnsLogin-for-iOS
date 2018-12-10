//
//  SnsLogin.swift
//  SnsLogin
//
//  Created by GlobalHumanism on 2018. 12. 7..
//  Copyright © 2018년 GlobalHumanism. All rights reserved.
//

import UIKit
import NaverThirdPartyLogin
import FacebookLogin
import FacebookCore


class SnsLogin : UIViewController, NaverThirdPartyLoginConnectionDelegate{
    
   static let shared = SnsLogin()
   
    //Mark: 네이버 로그인
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
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

    //Mark: 카카오톡 로그인
    func ktLogin() {
        
        let session: KOSession = KOSession.shared()
        if session.isOpen() {
            session.close()
        }
        session.presentingViewController = self
        session.open { (error) in
            
            if error != nil {
                print(error!)
            } else if session.isOpen() {
                KOSessionTask.userMeTask(completion: { (error, me) in
                    if let me = me as KOUserMe? {
                        print("카톡비번id: \(String(describing: me.id))")
                        UserDefaults.standard.set(me.id, forKey: "kakao")
                        
                        if let error = error {
                            print(error)
                        } else {
                            guard let token = KOSession.shared().accessToken else { return }
                            //                        self.sendToken(token, type: .kakao)
                            print("카카오 로그인")
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                })
            }
        }
    }

     //Mark: 페이스북 로그인
    func fbLogin() {
        
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(readPermissions: [.publicProfile], viewController: self) { (result) in
            print("페북 : \(result)")
            
            switch result {
            case .failed(let error): print(error.localizedDescription)
                
                //                self.presentSimpleAlert(title: "Facebook Error", message: "페이스북 서버에서 로그인이 실패했습니다.\n에러메세지:\(error.localizedDescription)", nil)
                
            case .cancelled: print("User cancelled login.")
            case .success(grantedPermissions: let grantedPermission, declinedPermissions: let declinedPermissions, token: let accessToken):
                print("grantedPermission:", grantedPermission)
                print("declinedPermissions:", declinedPermissions)
                //                self.sendToken(accessToken.authenticationToken, type: .facebook)
                
                if let id = accessToken.userId {
                    print("페북id: \(String(describing: id))")
                    UserDefaults.standard.set(id, forKey: "facebook")
                }
            }
        }
    }
}
