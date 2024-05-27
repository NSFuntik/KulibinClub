import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseMessaging
import SwiftUI
import UIKit
import UserNotifications
@main
struct KulibinClubApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView().tint(.accent).preferredColorScheme(.light)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    var window: UIWindow?
    lazy var notificationService = NotificationService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()

//        application.registerForRemoteNotifications()

        Messaging.messaging().delegate = self

        // Подписка на темы
        Messaging.messaging().subscribe(toTopic: "events") { error in
            if let error = error {
                print("Ошибка подписки на тему событий: \(error.localizedDescription)")
            } else {
                print("Успешно подписан на тему событий")
            }
        }

        Messaging.messaging().subscribe(toTopic: "news") { error in
            if let error = error {
                print("Ошибка подписки на тему новостей: \(error.localizedDescription)")
            } else {
                print("Успешно подписан на тему новостей")
            }
        }

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")

        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: NSNotification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([[.alert, .sound, .badge]])

        let content = notification.request.content
        let newNotification = Notification(id: UUID().uuidString, title: content.title, body: content.body, date: Date())
        notificationService.addNotification(newNotification)

        // Сохранение уведомления в Firestore
        saveNotificationToFirestore(newNotification)
    }

    private func saveNotificationToFirestore(_ notification: Notification) {
        let db = Firestore.firestore()
        let notificationData: [String: Any] = [
            "id": notification.id,
            "title": notification.title,
            "body": notification.body,
            "date": notification.date,
        ]
        db.collection("notifications").document(notification.id).setData(notificationData) { error in
            if let error = error {
                print("Ошибка сохранения уведомления: \(error.localizedDescription)")
            } else {
                print("Уведомление успешно сохранено")
            }
        }
    }
}


import Network

class NetworkMonitor: ObservableObject {
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    @Published var isConnected: Bool = false

    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}

import SwiftUI

struct ScreenEnvironmentKey: EnvironmentKey {
    static var defaultValue: UIScreen = UIScreen.main
}

extension EnvironmentValues {
    var screen: UIScreen {
        get { self[ScreenEnvironmentKey.self] }
        set { self[ScreenEnvironmentKey.self] = newValue }
    }
}

struct ScreenModifier: ViewModifier {
    @State private var screen: UIScreen = UIScreen.main
    
    func body(content: Content) -> some View {
        content
            .environment(\.screen, screen)
            .background(
                WindowReader { window in
                    if let windowScene = window?.windowScene {
                        self.screen = windowScene.screen
                    }
                }
            )
    }
}

struct WindowReader: UIViewControllerRepresentable {
    var callback: (UIWindow?) -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        WindowReaderViewController(callback: callback)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    
    class WindowReaderViewController: UIViewController {
        var callback: (UIWindow?) -> Void
        
        init(callback: @escaping (UIWindow?) -> Void) {
            self.callback = callback
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            callback(view.window)
        }
    }
}

extension View {
    func withScreen() -> some View {
        self.modifier(ScreenModifier())
    }
}
