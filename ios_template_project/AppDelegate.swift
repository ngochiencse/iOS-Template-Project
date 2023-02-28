//
//  AppDelegate.swift
//  ios_template_project
//
//  Created by Hien Pham on 11/11/19.
//  Copyright © 2019 BraveSoft Vietnam. All rights reserved.
//

import UIKit
#if FLEX_ENABLED
import FLEX
#endif
import CocoaLumberjack
import Firebase
import FirebaseCore
import FirebaseMessaging
import RxSwift
import SwiftDate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: AppCoordinator!
    var updateDeviceTokenService: UpdateDeviceTokenService!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 13, *) { } else {
            window = UIWindow(frame: UIScreen.main.bounds)
            setUp(window)

            if let remoteNotification = launchOptions?[.remoteNotification] as? [String: Any] {
                coordinator.didStartAppWithPushContent(remoteNotification)
            }
        }

        return true
    }

    func setUp(_ window: UIWindow?) {
        setUpWindow(window)
        setUpFirebase()
        setUpPush()
        setUpOthers(window)
    }

    func setUpWindow(_ window: UIWindow?) {
        let appCoordinator = AppCoordinatorImpl(window: window)
        coordinator = appCoordinator
        coordinator.start()
    }

    func setUpAppFlow() {
        let appCoordinator = AppCoordinatorImpl(window: window)

        coordinator = appCoordinator
        coordinator.start()
    }

    func setUpOthers(_ window: UIWindow?) {
        // Setup SwiftDate region
        Date.setupDefautRegion()

        // Set up cocoalumberjack
        DDLog.add(DDOSLogger.sharedInstance) // Uses os_log

        #if FLEX_ENABLED
        #if DEBUG
        FLEXManager.shared.showExplorer()
        #endif
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(handleFingerQuadrupleTap(_:)))
        tap.numberOfTouchesRequired = 4
        window?.addGestureRecognizer(tap)
        #endif

        // Print config infos
        Environment.shared.logEnvironmentInfos()
        AppSecretsManager.shared.logAppSecretInfos()

        // Update device token service
        setUpUpdateDeviceToken()
    }

    func setUpFirebase() {
        // Set up firebase
        FirebaseApp.configure()

        Messaging.messaging().delegate = self

        Messaging.messaging().token { (token, error) in
            if let error = error {
                DDLogError("Error firebase token: \(error)")
            } else if let token = token {
                DDLogDebug("Firebase registration token: \(token)")
            }
        }
    }

    func setUpPush() {
        coordinator.flowObservable.filter({ (flow: AppFlow?) -> Bool in
            if let flow = flow, flow == .main {
                return true
            } else {
                return false
            }
        }).observeOn(MainScheduler.instance).take(1).subscribe(onNext: { (flow: AppFlow?) in
            guard let flow = flow, flow == .main else { return }

            let application: UIApplication = UIApplication.shared
            if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = self

                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_, _ in })
            } else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
            }

            application.registerForRemoteNotifications()
        }).disposed(by: rx.disposeBag)
    }

    func setUpUpdateDeviceToken() {
        updateDeviceTokenService = UpdateDeviceTokenServiceImpl()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleLoginSuccessNotification),
                                               name: .LoginSuccess, object: nil)
    }

    @objc func handleLoginSuccessNotification() {
        updateDeviceTokenService.events.onNext(.loginSuccess)
    }

    @objc fileprivate func handleFingerQuadrupleTap(_ tapRecognizer: UITapGestureRecognizer) {
        #if FLEX_ENABLED
        if tapRecognizer.state == .recognized {
            FLEXManager.shared.showExplorer()
        }
        #endif
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        DDLogDebug("didReceiveRemoteNotification: \(userInfo)")

        coordinator.didReceivePushContent(userInfo, isAppActive: application.applicationState == .active)

        completionHandler(UIBackgroundFetchResult.newData)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        //        NotificationCenter.default.post(name: .ApplicationWillResignActive, object: nil)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        //        NotificationCenter.default.post(name: .ApplicationDidBecomeActive, object: nil)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //        NotificationCenter.default.post(name: .ApplicationDidEnterBackground, object: nil)
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running,
        // this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        DDLogDebug("Firebase registration token: \(String(describing: fcmToken))")
        guard let fcmToken = fcmToken, fcmToken.isEmpty == false else { return }
        updateDeviceTokenService.events.onNext(.receive(fcmToken))
    }
}

extension Date {
    static func setupDefautRegion(_ region: Region = Region.appDefautRegion) {
        SwiftDate.defaultRegion = region
    }
}

extension Region {
    static let appDefautRegion = Region(calendar: Calendars.gregorian, zone: Zones.current, locale: Locales.current)
}
