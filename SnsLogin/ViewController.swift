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
import FacebookLogin
import FacebookCore
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {

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
    
    let fbLoginBtn : UIButton = {
        let button = UIButton()
        button.setTitle("페이스북 로그인", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    let googleLoginBtn : GIDSignInButton = {
        let button = GIDSignInButton()
//        button.setTitle("구글 로그인", for: .normal)
//        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    let googleLogoutBtn : UIButton = {
        let button = UIButton()
        button.setTitle("구글 로그아웃", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.isHidden = true
        return button
    }()

    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        UserDefaults.standard.set(true, forKey: "kakaologin")
        UserDefaults.standard.set(true, forKey: "naverlogin")
        UserDefaults.standard.set(true, forKey: "fblogin")
        UserDefaults.standard.set(true, forKey: "googlelogin")
        self.view.backgroundColor = .white
        self.setButtonSelectors()
        self.setupLayout()
    }

    private func setButtonSelectors() {

        self.naverLoginBtn.addTarget(self, action: #selector(touchUpNaverloginBtn(_:)), for: .touchUpInside)
        self.ktLoginBtn.addTarget(self, action: #selector(touchUpKtLoginBtn(_:)), for: .touchUpInside)
        self.fbLoginBtn.addTarget(self, action: #selector(touchUpFbLoginBtn(_:)), for: .touchUpInside)
        self.googleLoginBtn.addTarget(self, action: #selector(touchUpGoogleLoginBtn(_:)), for: .touchUpInside)
        self.googleLogoutBtn.addTarget(self, action: #selector(touchUpGoogleLogoutBtn(_:)), for: .touchUpInside)
    }

    //MARK: AutoLayout
    func setupLayout() {

        view.addSubview(naverLoginBtn)
        view.addSubview(ktLoginBtn)
        view.addSubview(fbLoginBtn)
        view.addSubview(googleLoginBtn)
        view.addSubview(googleLogoutBtn)

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
        
        fbLoginBtn.snp.makeConstraints { (const) in
            const.top.equalTo(ktLoginBtn).offset(100)
            const.centerX.equalToSuperview()
            const.width.equalToSuperview().multipliedBy(0.4)
            const.height.equalToSuperview().multipliedBy(0.08)
        }
        
        googleLoginBtn.snp.makeConstraints { (const) in
            const.top.equalTo(fbLoginBtn).offset(100)
            const.centerX.equalToSuperview()
            const.width.equalToSuperview().multipliedBy(0.4)
            const.height.equalToSuperview().multipliedBy(0.08)
        }
        
        googleLogoutBtn.snp.makeConstraints { (const) in
            const.top.equalTo(fbLoginBtn).offset(100)
            const.centerX.equalToSuperview()
            const.width.equalToSuperview().multipliedBy(0.4)
            const.height.equalToSuperview().multipliedBy(0.08)
        }
    }
    
    @objc func touchUpNaverloginBtn(_ sender : UIButton) {

        print("네이버")
        
        if UserDefaults.standard.bool(forKey: "naverlogin") {
            UserDefaults.standard.set(false, forKey: "naverlogin")
           
            SnsLogin.shared.naverLogin()
            self.naverLoginBtn.setImage(#imageLiteral(resourceName: "naverlogout"), for: .normal)
        } else {
            UserDefaults.standard.set(true, forKey: "naverlogin")
            self.naverLoginBtn.setImage(#imageLiteral(resourceName: "naverlogin"), for: .normal)
            loginInstance?.requestDeleteToken()
            print("토큰삭제")
        }
    }
    
    @objc func touchUpKtLoginBtn(_ sender : UIButton) {
        
        if UserDefaults.standard.bool(forKey: "kakaologin") {
            UserDefaults.standard.set(false, forKey: "kakaologin")
            SnsLogin.shared.ktLogin()
            self.ktLoginBtn.setTitle("카카오톡 로그아웃", for: .normal)
        } else {
            UserDefaults.standard.set(true, forKey: "kakaologin")
            self.ktLoginBtn.setTitle("카카오톡 로그인", for: .normal)
            print("카카오 로그아웃")
        }
    }//카톡로그인
    
    @objc func touchUpFbLoginBtn(_ sender : UIButton) {

        if UserDefaults.standard.bool(forKey: "fblogin") {
            UserDefaults.standard.set(false, forKey: "fblogin")
            SnsLogin.shared.fbLogin()
            self.fbLoginBtn.setTitle("페이스북 로그아웃", for: .normal)
        } else {
            UserDefaults.standard.set(true, forKey: "fblogin")
            self.fbLoginBtn.setTitle("페이스북 로그인", for: .normal)
            print("페이스북 로그아웃")
        }
    }//페북로그인
    
    @objc func touchUpGoogleLoginBtn(_ sender : UIButton) {
        
        if  UserDefaults.standard.bool(forKey: "googlelogin") {
            UserDefaults.standard.set(false, forKey: "googlelogin")
            GIDSignIn.sharedInstance().hasAuthInKeychain()
//            print(GIDSignIn.sharedInstance().hasAuthInKeychain())
            
            googleLoginBtn.isHidden = true
            googleLogoutBtn.isHidden = false
        }
        
    }//구글로그인
    
    @objc func touchUpGoogleLogoutBtn(_ sender : UIButton) {
        UserDefaults.standard.set(true, forKey: "googlelogin")
            GIDSignIn.sharedInstance().signOut()
            googleLoginBtn.isHidden = false
            googleLogoutBtn.isHidden = true
    }//구글로그아웃
}

