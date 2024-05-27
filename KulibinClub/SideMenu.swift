//
//  SideMenu.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 26.05.2024.
//

import FirebaseAuth
import SwiftUI

struct SideMenu<Content: View>: View {
    @Binding var isLoggedIn: Bool
    @Binding var isShowing: Bool
    var content: Content
    var edgeTransition: AnyTransition = .move(edge: .leading)

    var body: some View {
        ZStack(alignment: .bottom) {
            if isShowing {
                Color.black.opacity(0.3).ignoresSafeArea()
                    .onTapGesture { isShowing.toggle() }
                content .transition(edgeTransition)
                    .background(.clear)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea().animation(.interactiveSpring, value: isShowing)
    }
    init(
        isShowing: Binding<Bool>,
        edgeTransition: AnyTransition,
        isLoggedIn: Binding<Bool> = .constant(true),
        content: Content
    ) {
        self._isShowing = isShowing
        self.content = content
        self.edgeTransition = edgeTransition
        self._isLoggedIn = isLoggedIn
    }
}

struct SideMenuContent: View {
    @Binding var isLoggedIn: Bool
    @Binding var isShowing: Bool
    @Binding var path: NavigationPath
    @ObservedObject var notificationService: NotificationService

    var body: some View {
        HStack {
            ZStack {
                Rectangle().fill(.ultraThinMaterial).frame(width: 270).shadow(color: .accentColor.opacity(0.33), radius: 13, x: 0, y: 1)
                VStack(alignment: .leading, spacing: 0) {
                    TopTitle
                    SiteRoutesList
                    BottomRobot
                }
                .padding(.top, 77) .frame(width: 270)
                .background( LinearGradient(colors: [ .white,.accentColor.opacity(0.66), .accentColor.opacity(0.66), .white, ],
                        startPoint: .topTrailing, endPoint: .bottomLeading
                    ).blur(radius: 44).opacity(0.13))
            }
            Spacer()
        }
        .background(.clear)
    }
    fileprivate typealias Route = SideMenuTab
    var SiteRoutesList: some View {
        List {
            Button("Главная") { isShowing.toggle() }.listRowBackground(Color.clear)
            DisclosureGroup("Курсы") {
                NavigationLink("Робототехника", value: Route.Робототехника)
                NavigationLink("Программирование", value: Route.Программирование)
                NavigationLink("Компьютерная графика и 3D", value: Route.КомпьютернаяГрафикаи3D)
                NavigationLink("Курсы для взрослых", value: Route.КурсыДляВзрослых)
            }.listRowBackground(Color.clear)
            NavigationLink("Уведомления", value: Route.Уведомления).listRowBackground(Color.clear)
            DisclosureGroup("О клубе") {
                NavigationLink("История создания", value: Route.ИсторияСоздания)
                NavigationLink("Новости", value: Route.Новости)
                NavigationLink("Фотогалерея", value: Route.Фотогалерея)
                NavigationLink("Календарь событий", value: Route.КалендарьСобытий)
                NavigationLink("Бонусная программа", value: Route.БонуснаяПрограмма)
                NavigationLink("Вопросы и ответы", value: Route.ВопросыИответы)
            }.listRowBackground(Color.clear)
            NavigationLink("Каталог", value: Route.Каталог).listRowBackground(Color.clear)
            DisclosureGroup("Документы") {
                NavigationLink("Договор-оферта", value: Route.Документы)
                NavigationLink("Сведения об образовательной организации", value: Route.СведенияОбОбразовательнойОрганизации)
                NavigationLink("Договор-Оферта", value: Route.ДоговорОферта)
                NavigationLink("Соглашение о конфиденциальности", value: Route.СоглашениеоКонфиденциальности)
                NavigationLink("Обработчики персональных данных", value: Route.ОбработчикиПерсональныхДанных)
            }.listRowBackground(Color.clear)
            DisclosureGroup("Партнеры") {
                NavigationLink("Общественный фонд", value: Route.ОбщественныйФонд)
                NavigationLink("Наши партнеры", value: Route.НашиПартнеры)
            }.listRowBackground(Color.clear)
            NavigationLink("Настройки", value: Route.Настройки).listRowBackground(Color.clear)
            Button(action: handleLogout) { Text("Выйти") }.listRowBackground(Color.clear)
            Spacer(minLength: 222).listRowBackground(Color.clear)
        }
        .listRowBackground(Color.clear).listStyle(SidebarListStyle()).scrollContentBackground(.hidden).backgroundStyle(.clear)
        .scrollIndicators(.visible)
    }

    let BottomRobot: some View = {
        Image(.infoRobot)
            .resizable(capInsets: .init(top: 0, leading: 0, bottom: 44, trailing: 0), resizingMode: .stretch) // .rotationEffect(.degrees(90.0))
            .scaledToFill()
            .frame(height: 44)
            .padding(.bottom, 66)
            .shadow(radius: 3)
            .padding(.leading, 44)
            .padding(.trailing, 13)
    }()

    let TopTitle: some View = {
        VStack(alignment: .leading, spacing: 6, content: {
            Text("Kulibin.club")
                .font(.title.weight(.medium).monospaced()).minimumScaleFactor(0.7)
                .foregroundStyle(.accent)
                .shadow(radius: 1)
                .lineLimit(1)
            Text("Клуб научно-технического творчества")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }).padding()
            .background(.thinMaterial,
                        in: RoundedRectangle(cornerRadius: 14)).clipped()
            .shadow(color: .secondary.opacity(0.6), radius: 4, x: 0, y: 3).padding()

    }()

    private func handleLogout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch {
            print("Ошибка выхода: \(error.localizedDescription)")
        }
    }
}

enum SideMenuTab: String {
    case Главная
    case Курсы
    case Робототехника
    case Программирование
    case КомпьютернаяГрафикаи3D = "Компьютерная графика и 3D"
    case КурсыДляВзрослых = "Курсы для взрослых"
    case Уведомления
    case оКлубе = "О клубе"
    case ИсторияСоздания = "История создания"
    case Новости
    case Фотогалерея
    case КалендарьСобытий = "Календарь событий"
    case БонуснаяПрограмма = "Бонусная программа"
    case ВопросыИответы = "Вопросы и ответы"
    case Каталог
    case Документы
    case СведенияОбОбразовательнойОрганизации = "Сведения об образовательной организации"
    case ДоговорОферта = "Договор-оферта"
    case СоглашениеоКонфиденциальности = "Соглашение о конфиденциальности"
    case ОбработчикиПерсональныхДанных = "Обработчики персональных данных"
    case Партнеры
    case ОбщественныйФонд = "Общественный фонд"
    case НашиПартнеры = "Наши партнеры"
    case Настройки
}
