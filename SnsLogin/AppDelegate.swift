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
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    

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
        
        //MARK: Google Login
        GIDSignIn.sharedInstance().clientID = "388154442856-lbludmamso5kr7j9obd2nq55ot6o8q35.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
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
    
    // Mark: Kakao, FB, Google Login
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
//            return false
            return GIDSignIn.sharedInstance().handle(url as URL?,
                                                     sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        }
    }
    
    // Mark: Google Login
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // [START_EXCLUDE]
            
            print("Sign-in Success \(user.profile.email)")

            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                object: nil,
                userInfo: ["statusText": "Signed in user:\n\(fullName)"])
            // [END_EXCLUDE]
        }
    }
    
    // [START disconnect_handler]
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }
        
    func applicationDidEnterBackground(_ application: UIApplication) {
        KOSession.handleDidEnterBackground()
    }
        
    func applicationDidBecomeActive(_ application: UIApplication) {
        KOSession.handleDidBecomeActive() //kakao
        AppEventsLogger.activate(application) //facebook
    }
}

