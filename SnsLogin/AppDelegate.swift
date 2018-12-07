//
//  AppDelegate.swift
//  SnsLogin
//
//  Created by GlobalHumanism on 2018. 12. 7..
//  Copyright © 2018년 GlobalHumanism. All rights reserved.
//

import UIKit
import NaverThirdPartyLogin

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
        
        
        return true
    }

    // Mark: Kakao, Naver Login
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        if KOSession.handleOpen(url) {
//            return KOSession.handleOpen(url)
//        }else {
//
            let result = NaverThirdPartyLoginConnection.getSharedInstance().receiveAccessToken(url)
            print("\(result)")
            return false
//        }
    }
        
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

