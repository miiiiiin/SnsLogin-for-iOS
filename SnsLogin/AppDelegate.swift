//
//  AppDelegate.swift
//  SnsLogin
//
//  Created by GlobalHumanism on 2018. 12. 7..
//  Copyright © 2018년 GlobalHumanism. All rights reserved.
//

import UIKit
import NaverThirdPartyLogin
import FacebookCore
import FacebookLogin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        // MARK: Naver Login
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        //instance?.isNaverAppOauthEnable = true //네이버 앱으로 인증(앱 설치)
        instance?.isInAppOauthEnable = true //사파리 뷰 컨트롤러에서 인증(앱 미설치)
        //네이버 앱이 없다면 사파리를 통해 인증 진행. 앱 인증과 사파리 인증이 둘 다 활성화되어 있다면 네이버 앱이 있는지 먼저 검사를 후 네이버 앱이 있다면 네이버 앱으로, 없으면 사파리를 통해 인증 진행
        instance?.isOnlyPortraitSupportedInIphone() //인증화면 세로 모드로만 사용
        //NaverThirdPartyConstantsForApp.h의 client id, secret, url scheme 적용
        instance?.serviceUrlScheme = kServiceAppUrlScheme
        instance?.consumerKey = kConsumerKey
        instance?.consumerSecret = kConsumerSecret
        instance?.appName = kServiceAppName
        
        //MARK: FB Login
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }

    // Mark: Kakao, Naver Login
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if KOSession.handleOpen(url) {
            return KOSession.handleOpen(url)
        }else {
            let result = NaverThirdPartyLoginConnection.getSharedInstance().receiveAccessToken(url)
            print("\(result)")
            return false
        }
    }
    
    // Mark: Kakao, FB Login
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if KOSession.handleOpen(url) {
            return KOSession.handleOpen(url)
        }else {

            guard let scheme = url.scheme else {

                return false
            }

            if scheme.hasPrefix("fb\(SDKSettings.appId)") {

                return SDKApplicationDelegate.shared.application(app, open: url, options: options)

                }
            return false
        }
    }
        
    func applicationDidEnterBackground(_ application: UIApplication) {
        KOSession.handleDidEnterBackground()
    }
        
    func applicationDidBecomeActive(_ application: UIApplication) {
        KOSession.handleDidBecomeActive() //kakao
        AppEventsLogger.activate(application) //facebook
    }
}

