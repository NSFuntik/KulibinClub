import Firebase
import FirebaseAuth
import SwiftUI
import FlomniChat

// MARK: - ContentView

struct ContentView: View {
	@State private var isLoggedIn: Bool
	@State var sideMenu: Bool = false
	@StateObject var notificationService = NotificationService()
	@State var path: NavigationPath = .init()
	@State var popover: Bool = false
	var body: some View {
		NavigationStack(path: $path) {
			ZStack {
				if isLoggedIn {
					// Начальная страница приложения
					MainView().blur(radius: sideMenu ? 2 : 0)
				} else {
					// Авторизация
					AuthView(isLoggedIn: $isLoggedIn)
				}
				// Боковое меню навигационных разделов
				SideMenu(isShowing: $sideMenu, path: $path, edgeTransition: .move(edge: .leading))
			}.ignoresSafeArea()
				.toolbar(content: { SidebarButton(sideMenu: $sideMenu) })
				.navigationDestination(for: SideMenuTab.self) { tab in
					switch tab {
					case .Главная: Button("Главная") { sideMenu.toggle() }
					case .Курсы: Text(tab.rawValue)
					case .Робототехника: CourseListView(
							courses: exampleCourses, category: "Робототехника"
						)
					case .Программирование: CourseListView(
							courses: exampleCourses, category: "Программирование"
						)
					case .КомпьютернаяГрафикаи3D: CourseListView(
							courses: exampleCourses, category: "Компьютерная графика и 3D"
						)
					case .КурсыДляВзрослых: CourseListView(
							courses: exampleCourses, category: "Курсы для взрослых"
						)
					case .Уведомления: NotificationView(notificationService: notificationService)
					case .оКлубе: Text(tab.rawValue)
					case .ИсторияСоздания: HistoryView()
					case .Новости: NewsListView()
					case .Фотогалерея: Text(tab.rawValue)
					case .КалендарьСобытий: EventListView()
					case .БонуснаяПрограмма: BonusListView()
					case .ВопросыИответы: FAQListView()
					case .Каталог: ProductListView()
					case .Документы: Text(tab.rawValue)
					case .СведенияОбОбразовательнойОрганизации: Text(tab.rawValue)
					case .СоглашениеоКонфиденциальности: Text(tab.rawValue)
					case .ОбработчикиПерсональныхДанных: Text(tab.rawValue)
					case .Партнеры: Text(tab.rawValue)
					case .ОбщественныйФонд: Text(tab.rawValue)
					case .НашиПартнеры: Text(tab.rawValue)
					case .Настройки: SettingsView()
					case .ДоговорОферта: Text(tab.rawValue)
					case .Поддержка:
						ChatModule.makeChat(session: .productThread)
//						ChatModule.Content(theme: .default) {
//								Image("logo-2")
//							}
						
						case .Выход:
						AuthView(isLoggedIn: $isLoggedIn)
					}
				}
//				.toolbarBackground(.ultraThinMaterial, for: .navigationBar)
		}.toolbarBackground(.hidden, for: .navigationBar)
			.animation(.smooth, value: sideMenu).animation(.smooth, value: path).animation(.smooth, value: isLoggedIn).animation(.smooth, value: sideMenu)
			.environment(\.sideBar, $sideMenu)
	}

	init() {
		let firebaseAuth = Auth.auth()
		do {
			UserDefaults.standard.set(firebaseAuth.currentUser?.uid, forKey: "uid")
			self.isLoggedIn = true
		}
	}
}

#Preview(body: {
	ContentView()
})

// MARK: - SidebarButton

public struct SidebarButton: ToolbarContent {
	@Binding var sideMenu: Bool

	@ToolbarContentBuilder
	public var body: some ToolbarContent {
		ToolbarItem(placement: .navigation) {
			Button(action: {
				sideMenu.toggle()
			}) {
				Image(systemName: "sidebar.squares.leading")
					.symbolRenderingMode(.hierarchical)
					.font(.title3.italic())
					.imageScale(.large)
					.background(Image(systemName: "rectangle.fill").symbolRenderingMode(.hierarchical).imageScale(.large).foregroundStyle(.accent.opacity(0.13)))
					.symbolEffect(.disappear, isActive: sideMenu)
			}.foregroundStyle(.ultraThickMaterial).padding(.leading, -13).vibrantForeground(thick: true)
				.environment(\.sideBar, $sideMenu)
		}
	}
}

// var flomni: some View {
//    FlomniChatProvider.defaultValue = Container.shared.flomniChat.register(factory: {
//        FlomniChat(
//            apiKey: "5d0cd1707741de0009e061cb",
//            appGroup: "group.com.flomni.chat",
//            userId: "c79f58b0-527d-4e75-ba58-6fbc32c6c81a"
//        )
//    }).resolve()
//    return FlomniChatList(theme: .default, route: [], placement: .navigation) {
//        TrialButton()
//    }.content
// }
// }
// struct TrialButton: View {
// @State var popover: Bool = false
// var body: some View {
//    Button(action: {
//        popover.toggle()
//    }, label: {
//        Label("Записаться", systemImage: "pencil.and.outline")
//            .symbolRenderingMode(.hierarchical)
//            .vibrantForeground(thick: true).labelStyle(.titleAndIcon)
//            .font(.title2.weight(.semibold).monospaced())
//            .padding(8, 24)
//            .materialBackground(with: .systemUltraThinMaterial, blur: 1, clipped: Capsule(), filled: .accentColor.opacity(0.44), bordered: .accent, width: 0.5)
//
//    }).frame(width: .screenWidth, alignment: .center)
//        .padding(12)
// }
// }
