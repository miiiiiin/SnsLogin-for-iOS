//
//  ViewController.swift
//  SnsLogin
//
//  Created by GlobalHumanism on 2018. 12. 7..
//  Copyright © 2018년 GlobalHumanism. All rights reserved.
//

import UIKit
import NaverThirdPartyLogin
import SnapKit

class ViewController: UIViewController, NaverThirdPartyLoginConnectionDelegate {

    let naverLoginBtn : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "naverlogin"), for: .normal)
        return button
    }()

    let ktLoginBtn : UIButton = {
        let button = UIButton()
        button.setTitle("카카오톡 로그인", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    

    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        UserDefaults.standard.set(true, forKey: "kakaologin")
        UserDefaults.standard.set(true, forKey: "naverlogin")
        self.view.backgroundColor = .white
        self.setButtonSelectors()
        self.setupLayout()

    }


    private func setButtonSelectors() {

        self.naverLoginBtn.addTarget(self, action: #selector(touchUpNaverloginBtn(_:)), for: .touchUpInside)
        self.ktLoginBtn.addTarget(self, action: #selector(touchUpKtLoginBtn(_:)), for: .touchUpInside)
    }


    //MARK: AutoLayout
    func setupLayout() {

        view.addSubview(naverLoginBtn)
        view.addSubview(ktLoginBtn)

        naverLoginBtn.snp.makeConstraints { (const) in
            const.top.equalToSuperview().offset(160)
            const.centerX.equalToSuperview()
            const.width.equalToSuperview().multipliedBy(0.4)
            const.height.equalToSuperview().multipliedBy(0.08)
        }
        
        ktLoginBtn.snp.makeConstraints { (const) in
            const.top.equalTo(naverLoginBtn).offset(100)
            const.centerX.equalToSuperview()
            const.width.equalToSuperview().multipliedBy(0.4)
            const.height.equalToSuperview().multipliedBy(0.08)
        }

    }

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
        naverLogin()
    }//로그인 성공 시 accessToken 메서드로 접근 토큰 정보 얻어옴

    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        loginInstance?.isValidAccessTokenExpireTimeNow() // 접근 토큰 유효한지 확인
        print("접근 토큰 재발급 요청")
//        naverLogin()
    }

    func oauth20ConnectionDidFinishDeleteToken() {
        print("토큰 삭제")
        
    }

    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print(error)
    }


    @objc func touchUpNaverloginBtn(_ sender : UIButton) {

        print("네이버")
        
        if UserDefaults.standard.bool(forKey: "naverlogin") {
            UserDefaults.standard.set(false, forKey: "naverlogin")
            self.naverLoginBtn.setImage(#imageLiteral(resourceName: "naverlogout"), for: .normal)
            naverLogin()
        } else {
            
            UserDefaults.standard.set(true, forKey: "naverlogin")
            self.naverLoginBtn.setImage(#imageLiteral(resourceName: "naverlogin"), for: .normal)
            loginInstance?.requestDeleteToken()
        }
    }
    
    @objc func touchUpKtLoginBtn(_ sender : UIButton) {
        
            if UserDefaults.standard.bool(forKey: "kakaologin") {
                UserDefaults.standard.set(false, forKey: "kakaologin")
           
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
                            self.ktLoginBtn.setTitle("카카오톡 로그아웃", for: .normal)
                            print("카카오 로그인")
                            self.dismiss(animated: true, completion: nil)
                            }
                        }
                    })
                }
            }
        } else {
            
            UserDefaults.standard.set(true, forKey: "kakaologin")
            self.ktLoginBtn.setTitle("카카오톡 로그인", for: .normal)
            print("카카오 로그아웃")
        }
    }//카톡로그인
}

