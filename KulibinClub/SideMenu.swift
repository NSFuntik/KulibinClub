//
//  SideMenu.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 26.05.2024.
//

import FirebaseAuth
//import SwiftPro
import SwiftUI

#Preview(body: {
	ZStack {
		MainView()
		SideMenu(isShowing: .constant(true), isLoggedIn: .constant(true), path: .constant(NavigationPath()), edgeTransition: .slide, content: SideMenuContent(isLoggedIn: .constant(true), isShowing: .constant(true), path: .constant(NavigationPath()), notificationService: NotificationService()))
	}
})

// MARK: - SideMenu

/// Боковое меню навигационных разделов
struct SideMenu<Content: View>: View {
	@Binding var isLoggedIn: Bool
	@Binding var isShowing: Bool
	@Binding var path: NavigationPath

	var content: Content
	var edgeTransition: AnyTransition = .move(edge: .leading).animation(.snappy)

	var body: some View {
		ZStack(alignment: .bottom) {
			if isShowing {
				Color.secondary.opacity(0.33).ignoresSafeArea()
					.onTapGesture { isShowing.toggle() }
				content.transition(edgeTransition)
					.background(.clear)
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
		.ignoresSafeArea().animation(.snappy, value: isShowing)
	}

	init(
		isShowing: Binding<Bool>,
		isLoggedIn: Binding<Bool> = .constant(true),
		path: Binding<NavigationPath>,
		edgeTransition: AnyTransition = .move(edge: .leading),
		content: Content? = nil
	) where Content == SideMenuContent {
		self._isShowing = isShowing
		if let content {
			self.content = content
		} else {
			self.content = SideMenuContent(isLoggedIn: isLoggedIn, isShowing: isShowing, path: path, notificationService: NotificationService())
		}
		self.edgeTransition = edgeTransition
		self._isLoggedIn = isLoggedIn
		self._path = path
	}
}

// MARK: - SideMenuContent

struct SideMenuContent: View {
	@Binding var isLoggedIn: Bool
	@Binding var isShowing: Bool
	@Binding var path: NavigationPath

	@ObservedObject var notificationService: NotificationService

	var body: some View {
		HStack {
			ZStack {
				Rectangle().fill(.thinMaterial).frame(width: 270)
					.shadow(color: .accentColor.opacity(0.33), radius: 13, x: 0, y: 1)
				VStack(alignment: .leading, spacing: 0) {
					TopTitle
					SiteRoutesList.padding(.trailing, -16)
				}
				.safeAreaPadding(.top, 44).frame(width: 270)
				.background(
					LinearGradient(colors: [.white, .accentColor.opacity(0.66), .accentColor.opacity(0.66), .white],
					               startPoint: .topTrailing, endPoint: .bottomLeading).blur(radius: 44).opacity(0.13)
				)
				VStack {
					Spacer()
					BottomRobot
				}.frame(width: 270)
			}
			Spacer()
		}
		.background(.clear)
	}

	/// A custom view representing a cell in the side bar.
	/// This view contains information about a specific route and provides a NavigationLink.
	/// - Parameters:
	///    - route: The route associated with the cell.
	fileprivate struct SideBarCell: View {
		var route: Route
		@State private var selected: Bool = false
		/// Initializes a new instance of `SideBarCell`.
		/// - Parameter route: The route associated with the cell.
		init(for route: Route) {
			self.route = route
		}

		var body: some View {
			NavigationLink(value: route) {
				label
			}.listRowBackground(Color.clear)
		}

		public var label: some View {
			Label(route.rawValue, systemImage: route.MenuIcon)
				.labelStyle(SideBarCellStyle())
				.foregroundStyle(.foreground/*accent.secondary.opacity(0.88)*/).vibrantForeground()
				.listRowBackground(Color.clear).padding(.leading, -16)
		}

		//        var symbol: Image {
		//            Image(systemName: )
		//        }
	}

	/// A custom label style for the side bar cell.
	struct SideBarCellStyle: LabelStyle {
		public func makeBody(configuration: Configuration) -> some View {
			HStack(alignment: .center, spacing: 8) {
				configuration.icon.font(.headline.weight(.medium)).symbolRenderingMode(.palette).foregroundStyle(.accent)
					.frame(width: 22, alignment: .center).colorMultiply(.white).clipped().shadow(.sticker)
				configuration.title.font(.headline.weight(.regular)).shadow(.none).foregroundStyle(.foreground)
				Spacer()
			}
		}
	}

	fileprivate typealias Route = SideMenuTab
	var SiteRoutesList: some View {
		List {
			Button { isShowing.toggle() } label: {
				SideBarCell(for: .Главная).label
			}.listRowBackground(Color.clear)
			DisclosureGroup {
				SideBarCell(for: .Робототехника)
				SideBarCell(for: .Программирование)
				SideBarCell(for: .КомпьютернаяГрафикаи3D)
				SideBarCell(for: .КурсыДляВзрослых)
			} label: {
				SideBarCell(for: .Курсы).label
			}.listRowBackground(Color.clear)
			SideBarCell(for: .Уведомления)
				.listRowBackground(Color.clear)
			DisclosureGroup {
				SideBarCell(for: .ИсторияСоздания)
				SideBarCell(for: .Новости)
				SideBarCell(for: .Фотогалерея)
				SideBarCell(for: .КалендарьСобытий)
				SideBarCell(for: .БонуснаяПрограмма)
				SideBarCell(for: .ВопросыИответы)
			} label: {
				SideBarCell(for: .оКлубе).label
			}.listRowBackground(Color.clear)
			SideBarCell(for: .Каталог)
				.listRowBackground(Color.clear)
			DisclosureGroup {
				SideBarCell(for: .Документы)
				SideBarCell(for: .СведенияОбОбразовательнойОрганизации)
				SideBarCell(for: .ДоговорОферта)
				SideBarCell(for: .СоглашениеоКонфиденциальности)
				SideBarCell(for: .ОбработчикиПерсональныхДанных)
			} label: {
				SideBarCell(for: .Документы).label
			}.listRowBackground(Color.clear)
			DisclosureGroup {
				SideBarCell(for: .ОбщественныйФонд)
				SideBarCell(for: .НашиПартнеры)
			} label: {
				SideBarCell(for: .Партнеры).label
			}.listRowBackground(Color.clear)
			SideBarCell(for: .Настройки)
			SideBarCell(for: .Поддержка)
			Button(action: handleLogout) { SideBarCell(for: .Выход).label }.listRowBackground(Color.clear)
			Spacer(minLength: 222).listRowBackground(Color.clear)
		}
		.listRowBackground(Color.clear)
		.listStyle(SidebarListStyle())
		.scrollContentBackground(.hidden)
		.backgroundStyle(.clear)
		.scrollIndicators(.visible)
	}

	let BottomRobot: some View = Image(.infoRobot)
		.resizable() // .rotationEffect(.degrees(90.0))
		.scaledToFit()
		.frame(height: .screenHeight / 5)
		.padding(.bottom, -16)
		.shadow(radius: 3)
		.padding(.leading, 44)
		.padding(.trailing, 13)

	let TopTitle: some View = VStack(alignment: .leading, spacing: 6, content: {
		Image(.logo2)
			.resizable().renderingMode(.template).shadow(.sticker)
			.aspectRatio(contentMode: .fit)
			.frame(height: 66)
			.spacing()
		//            Text("Kulibin.club")
		//                .font(.title.weight(.black).monospaced()).minimumScaleFactor(0.7).fixedSize(horizontal: true, vertical: true)
		//                .foregroundStyle(.accent).blendMode(.plusDarker).vibrantForeground(thick: true)
		//                .shadow(.elevated).shadow(.sticker)
		//                .lineLimit(1)
		Text("Клуб научно-технического творчества")
			.font(.caption.weight(.medium))
			.foregroundStyle(.tertiary)
	}).vibrantForeground(thick: true)
		.padding([.horizontal, .top])
		//        .background(.ultraThinMaterial)
		.background(content: { Image(.line).resizable().scaledToFit().opacity(0.33) })
		//        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

		.shadow(.elevated)

	private func handleLogout() {
		do {
			try Auth.auth().signOut()
			isLoggedIn = false
		} catch {
			print("Ошибка выхода: \(error.localizedDescription)")
		}
	}
}

// MARK: - SideMenuTab

enum SideMenuTab: String, CaseIterable {
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
	case Поддержка
	case Выход
	var systemValue: String {
		switch self {
		case .Главная: "homekit"
		case .Курсы: "Courses"
		case .Робототехника: "Robotics"
		case .Программирование: "Programming"
		case .КомпьютернаяГрафикаи3D: "Computer Graphics 3D"
		case .КурсыДляВзрослых: "CoursesForAdults"
		case .Уведомления: "Notifications"
		case .оКлубе: "About the club"
		case .ИсторияСоздания: "History of creation"
		case .Новости: "News"
		case .Фотогалерея: "Photo gallery"
		case .КалендарьСобытий: "Calendar of events"
		case .БонуснаяПрограмма: "Bonus program"
		case .ВопросыИответы: "Questions and answers"
		case .Каталог: "Catalog"
		case .Документы: "Documentation"
		case .СведенияОбОбразовательнойОрганизации: "Information About the Educational Organization"
		case .ДоговорОферта: "AgreementOffer"
		case .СоглашениеоКонфиденциальности: "Privacy agreement"
		case .ОбработчикиПерсональныхДанных: "Processors of Personal Data"
		case .Партнеры: "Partners"
		case .ОбщественныйФонд: "Public fund"
		case .НашиПартнеры: "Our partners"
		case .Настройки: "Settings"
		case .Выход: "Logout"
		case .Поддержка: "Задать вопрос"
		}
	}

	var MenuIcon: String {
		switch self {
		case .Главная: "homekit"
		case .Курсы: "book"
		case .Робототехника: "gearshape.fill"
		case .Программирование: "terminal.fill"
		case .КомпьютернаяГрафикаи3D: "cube.fill"
		case .КурсыДляВзрослых: "person.2.fill"
		case .Уведомления: "bell"
		case .оКлубе: "suit.club"
		case .ИсторияСоздания: "clock.fill"
		case .Новости: "newspaper.fill"
		case .Фотогалерея: "photo.fill"
		case .КалендарьСобытий: "calendar.badge.clock"
		case .БонуснаяПрограмма: "gift.fill"
		case .ВопросыИответы: "person.fill.questionmark"
		case .Каталог: "cart"
		case .Документы: "books.vertical"
		case .СведенияОбОбразовательнойОрганизации: "building.columns.fill"
		case .ДоговорОферта: "doc.text.fill"
		case .СоглашениеоКонфиденциальности: "bolt.shield"
		case .ОбработчикиПерсональныхДанных: "person.crop.circle.fill.badge.exclam"
		case .Партнеры: "figure.wave"
		case .ОбщественныйФонд: "shareplay"
		case .НашиПартнеры: "briefcase"
		case .Настройки: "gearshape"
		case .Поддержка: "questionmark.bubble"
		case .Выход: "door.right.hand.open"
		}
	}
}
