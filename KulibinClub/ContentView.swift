import Firebase
import FirebaseAuth
import SwiftUI

struct ContentView: View {
@State private var isLoggedIn: Bool
@State var sideMenu: Bool = false
@StateObject var notificationService = NotificationService()
@State var path: NavigationPath = NavigationPath()

var body: some View {
    NavigationStack(path: $path) {
        ZStack {
            if isLoggedIn {
                /// Начальная страница приложения
                MainView()
            } else {
                /// Авторизация
                AuthView(isLoggedIn: $isLoggedIn)
            }

            /// Боковое меню навигационных разделов
            SideMenu(
                isShowing: $sideMenu, edgeTransition: .move(edge: .leading),
                content: SideMenuContent(
                    isLoggedIn: $isLoggedIn, isShowing: $sideMenu,
                    path: $path,
                    notificationService: NotificationService())
            )
        }
        .toolbar(content: { ToolbarItem(placement: .navigation) { HeaderView(sideMenu: $sideMenu) } })
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
            }
        }
    }
    .animation(.smooth, value: sideMenu).animation(.smooth, value: path).animation(.smooth, value: isLoggedIn)
    }
    
    init() {
        let firebaseAuth = Auth.auth()
        do {
            firebaseAuth.signInAnonymously()
            self.isLoggedIn = true
        }
    }
}

#Preview(body: {
    ContentView()
})
