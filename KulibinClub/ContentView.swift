import Firebase
import FirebaseAuth
import SwiftPro
import SwiftUI
struct ContentView: View {
    @State private var isLoggedIn: Bool
    @State var sideMenu: Bool = false
    @StateObject var notificationService = NotificationService()
    @State var path: NavigationPath = NavigationPath()
    @State var popover: Bool = false
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                if isLoggedIn {
                    /// Начальная страница приложения
                    MainView().blur(radius: sideMenu ? 2 : 0)
                } else {
                    /// Авторизация
                    AuthView(isLoggedIn: $isLoggedIn)
                }
                /// Боковое меню навигационных разделов
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
                case .Выход:
                    AuthView(isLoggedIn: $isLoggedIn)
                }
            }
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
        .animation(.smooth, value: sideMenu).animation(.smooth, value: path).animation(.smooth, value: isLoggedIn).animation(.smooth, value: sideMenu)

       
        .environment(\.sideBar, $sideMenu)
    }

    init() {
        let firebaseAuth = Auth.auth()
        do {
            firebaseAuth.signInAnonymously()
            self.isLoggedIn = false
        }
    }
}

#Preview(body: {
    ContentView()
})

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
