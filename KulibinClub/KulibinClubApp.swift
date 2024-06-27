import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseMessaging
import FlomniChat
import SwiftUI
import UIKit
import UserNotifications

// MARK: - KulibinClubApp

@main
struct KulibinClubApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	var body: some Scene {
		WindowGroup {
			//            { () -> CommonContentView in
			//                FlomniChatProvider.defaultValue = Container.shared.flomniChat.register(factory: {
			//                    FlomniChat(
			//                        apiKey: "5d0cd1707741de0009e061cb",
			//                        appGroup: "group.com.flomni.chat",
			//                        userId: "c79f58b0-527d-4e75-ba58-6fbc32c6c81a"
			//                    )
			//                }).resolve()
			//                return CommonContentView()
			//            }()
			ContentView().tint(.accent).preferredColorScheme(.light)
		}
//		.environment(\.managedObjectContext, (appDelegate.flomniChat?.persistence.modelExecutor.context)!)
		.commands {
			ToolbarCommands() // <- Turns on the toolbar customization
		}
	}
}

// MARK: - SideBarBindingKey

struct SideBarBindingKey: EnvironmentKey {
	static var defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
	var sideBar: Binding<Bool> {
		get { self[SideBarBindingKey.self] }
		set { self[SideBarBindingKey.self] = newValue }
	}
}

// MARK: - FSBoolBindingKey

struct FSBoolBindingKey: EnvironmentKey {
	static var defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
	var fsBoolBinding: Binding<Bool> {
		get { self[FSBoolBindingKey.self] }
		set { self[FSBoolBindingKey.self] = newValue }
	}
}

// MARK: - AppDelegate

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
	var window: UIWindow?
	/// Экземпляр `FlomniChat`, предоставляемый `AppDelegate`
	var flomniChat: ChatModule?

	lazy var notificationService = NotificationService()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Create and configure the `FlomniChat` instance
		flomniChat = ChatModule(
			companyID: "5d0cd1707741de0009e061cb",
			appGroup: "group.com.flomni.chat",
			baseURL: .development,
			contour: .production,
			userId: UIDevice.deviceId,
			visitorAttributes: "{\"test\":\"testData\",\"environment\":\"iOS_Client\"}"
		)
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
			if let error {
				print("Ошибка подписки на тему событий: \(error.localizedDescription)")
			} else {
				print("Успешно подписан на тему событий")
			}
		}

		Messaging.messaging().subscribe(toTopic: "news") { error in
			if let error {
				print("Ошибка подписки на тему новостей: \(error.localizedDescription)")
			} else {
				print("Успешно подписан на тему новостей")
			}
		}

		return true
	}

	func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		Messaging.messaging().apnsToken = deviceToken
	}

	func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
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

	func userNotificationCenter(_: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
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
			if let error {
				print("Ошибка сохранения уведомления: \(error.localizedDescription)")
			} else {
				print("Уведомление успешно сохранено")
			}
		}
	}
}

import Network

// MARK: - NetworkMonitor

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

// MARK: - ScreenEnvironmentKey

struct ScreenEnvironmentKey: EnvironmentKey {
	static var defaultValue: UIScreen = .main
}

extension EnvironmentValues {
	var screen: UIScreen {
		get { self[ScreenEnvironmentKey.self] }
		set { self[ScreenEnvironmentKey.self] = newValue }
	}
}

// MARK: - ScreenModifier

struct ScreenModifier: ViewModifier {
	@State private var screen: UIScreen = .main

	func body(content: Content) -> some View {
		content
			.environment(\.screen, screen)
			.background(
				WindowReader { window in
					if let windowScene = window?.windowScene {
						screen = windowScene.screen
					}
				}
			)
	}
}

// MARK: - WindowReader

struct WindowReader: UIViewControllerRepresentable {
	var callback: (UIWindow?) -> Void

	func makeUIViewController(context _: Context) -> UIViewController {
		WindowReaderViewController(callback: callback)
	}

	func updateUIViewController(_: UIViewController, context _: Context) {}

	class WindowReaderViewController: UIViewController {
		var callback: (UIWindow?) -> Void

		init(callback: @escaping (UIWindow?) -> Void) {
			self.callback = callback
			super.init(nibName: nil, bundle: nil)
		}

		@available(*, unavailable)
		required init?(coder _: NSCoder) {
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
		modifier(ScreenModifier())
	}
}
