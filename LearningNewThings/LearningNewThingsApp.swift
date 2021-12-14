//
//  LearningNewThingsApp.swift
//  LearningNewThings
//
//  Created by ADOP_Mac on 2021/11/17.
//

import SwiftUI
import UIKit

@main
struct LearningNewThingsAppWrapper {
    static func main() {
        if #available(iOS 14.0, *) {
            LearningNewThingsApp.main()
        } else {
            UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(SceneDelegate.self))
        }
    }
}

@available(iOS 14.0, *)
struct LearningNewThingsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UIStateModelForVerticalCarousel())
        }
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = ContentView().environmentObject(UIStateModelForVerticalCarousel())

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
