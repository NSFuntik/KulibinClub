//
//  Product.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 26.05.2024.
//

import FirebaseFirestore
import SwiftUI

// MARK: - Product

/// Представляет продукт, доступный для покупки.
struct Product: Identifiable, Codable {
	@DocumentID var id: String? = UUID().uuidString
	var title: String = " "
	var description: String = " "
	var price: String = " "
	var image: [String] = []
	var characteristics: [String: String] = [:]
	var detailedDescription: String = " "
	var specifications: [String] = []
}

let exampleProducts: [Product] = [
	Product(
		title: "Робототехнический набор для младшего возраста Matatalab PRO Set",
		description: "Полный набор для начинающих",
		price: "44 389,00 ₽",
		image: [
			"https://kulibin.bokus.ru/upload/iblock/ba9/mw1y5cwmpj98lgrxr547m8bq9yati7qg.jpeg",
		],
		characteristics: ["Производитель": "Matatalab", "Комплектация": "Полный комплект"],
		detailedDescription: "Полный набор для начинающих, включающий всё необходимое для старта.",
		specifications: ["Комплект включает: робот, пульт, зарядное устройство", "Подходит для детей от 6 лет"]
	),
	Product(
		title: "Расширенный набор Робот+. Уровень 2 (контроллеры Ардуино)",
		description: "Расширенные возможности для профессионалов",
		price: "18 000,00 ₽",
		image: [
			"https://kulibin.bokus.ru/upload/iblock/18d/50cbp7eg6nbgx8lp81svj26957wxjcs9.jpeg",
			"https://kulibin.bokus.ru/upload/iblock/77a/b9evqzc220g6asgp9kqhzpxsdvs1oqt3.jpg",
			"https://kulibin.bokus.ru/upload/iblock/504/wzbnfj3kn9ac9xrfdbpogmgulj12d5if.jpg",
		],
		characteristics: [
			"Производитель": "Робот+",
			"Комплектация": "Расширенный комплект",
			"Размер упаковки":
				"354*339*93mm",
			"Вес":
				"~3.5kg",
			"Материал":
				"ABS+PP Plastic",
			"Основной чип":
				"Sochip S3, NRF51822",
			"Сенсор картинки":
				"GC2023",
			"Разъем USB":
				"Type-C*2",
			"Аккумулятор":
				"2000mAh, 500mAh Li-ion (встроенный)",
			"Потребляемая мощность":
				"USB 5V/2A, 5V/500mA",
			"Срок работы от одной зарядки":
				"3 часа",

		],
		detailedDescription:
		"""
		Принцип работы:
		В состав набора входит модуль со специальным полем, на котором располагаются управляющая башня с встроенной камерой и большая кнопка запуска программы. Программа составляется с помощью пластмассовых блоков, на которые нанесены интуитивно понятные символы (стрелки, ноты и т.п.). Блоки располагаются на специальном поле в зоне видимости камеры.

		Программа исполняется небольшим роботом, входящим в комплект. Этот робот перед выполнением программы располагается на специальном поле с заданием.

		При нажатии на кнопку старта, камера в управляющей башне считывает составленную программу с помощью камеры. После этого, с задержкой в 3 секунды, робот начинает выполнять действия по программе.

		Управляющая башня и робот оснащены аккумуляторами, которые заряжаются через интерфейс USB (5 Вольт). Кабели для зарядки входят в комплект поставки.
		""",
		specifications: [
			"Управляющий блок: 1",
			"Блок питания: 1",
			"Датчики: 5",
			"Моторы: 4",
			"Кабели: 5",
		]
	),
]

// MARK: - ProductView

#Preview(body: {
	ProductListView()
})

// MARK: - ProductView

struct ProductView: View {
	var product: Product

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			RemoteImage(imageURL: product.image.first, size: CGSize(width: .screenWidth - 88, height: 160)) {
				$0
					.scaledToFit()
					.frame(width: .screenWidth - 88, height: 160, alignment: .center)
			}
			.roundedContentShape()
			.itemPreviewLayout(cornerRadius: 12, strokeColor: .accent.opacity(0.5))

			VStack(alignment: .leading, spacing: 8) {
				Text(product.title)
					.font(.headline)
					.multilineTextAlignment(.leading)
				Text(product.description)
					.font(.subheadline)
					.foregroundColor(.secondary)

				HStack {
					Text(product.price)
						.font(.title3)
						.foregroundStyle(.primary)
					Spacer()
					Button(action: {
						// Действие для кнопки "Купить"
					}) {
						Text("Купить").font(.headline.monospaced().weight(.medium))
							.padding(12, 32)
							.background(Color.orange)
							.foregroundStyle(.white)
							.clipShape(.capsule)
					}
				}
			}
		}
		.padding(8, 16)
		.background(Color.white)
		.cornerRadius(10)
	}
}

// MARK: - ProductListView

struct ProductListView: View {
	@State var products: [Product] = []
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			List {
				ForEach(products) { product in
					Section {
						NavigationLink(destination: ProductDetailView(product: product)) {
							ProductView(product: product)
						}
					}
				}
			}
		}
		.listStyle(.insetGrouped)
		.background(.background)
		.navigationTitle("Каталог")
		.onAppear {
			products = exampleProducts
		}
	}
}

// MARK: - ItemPreviewModifier

struct ItemPreviewModifier: ViewModifier {
	var cornerRadius: Double
	var strokeColor: Color
	func body(content: Content) -> some View {
		let roundedRectangle = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
		content
			.contentShape(roundedRectangle)
			.clipShape(roundedRectangle)
			.cornerRadius(cornerRadius)
			.overlay(
				roundedRectangle
					.inset(by: 0.46)
					.stroke(strokeColor, lineWidth: 0.93)
			)
	}
}

extension View {
	func itemPreviewLayout(cornerRadius: Double = 9.48, strokeColor: Color = .secondary) -> some View {
		modifier(ItemPreviewModifier(cornerRadius: cornerRadius, strokeColor: strokeColor))
	}

	@inlinable
	func roundedContentShape(radius: CGFloat = 12) -> some View {
		contentShape(RoundedRectangle(cornerRadius: radius)).clipShape(RoundedRectangle(cornerRadius: radius)).clipped()
	}
}

// MARK: - ProductDetailView

struct ProductDetailView: View {
	var product: Product
	@State private var scrollableTabOffset: CGFloat = 0

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {
				Text(product.title)
					.font(.title2.bold())
					.foregroundStyle(.primary)
					.padding(.horizontal, 12)
				Divider().tint(.accent)
				TabView {
					ForEach(product.image, id: \.self) { link in
						RemoteImage(imageURL: link, size: CGSize(width: .screenWidth - 16, height: 260)) {
							$0
								.scaledToFit()
								.frame(width: .screenWidth, height: 260)
						}
					}
				}
				.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
				.indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
				.frame(width: .screenWidth - 16, height: 260)
				.background(Rectangle().fill(.white))
				.clipped(antialiased: true)
				.offset(y: -($scrollableTabOffset.animation(.linear).wrappedValue * 0.45).rounded())

				Text(product.price)
					.font(.title.bold())
					.foregroundStyle(.primary)

				Button(action: {
					// Действие для кнопки "Оставить заявку"
				}) {
					Text("Оставить заявку")
						.padding()
						.frame(maxWidth: .infinity)
						.background(Color.accentColor.opacity(0.88))
						.foregroundStyle(.white)
						.clipShape(.capsule)
				}.shadow(.sticker)

				Section(content: {
					VStack(alignment: .leading, spacing: 12) {
						ForEach(product.characteristics.sorted(by: >), id: \.key) { key, value in
							HStack {
								Text(key)
									.font(.subheadline.weight(.medium))
								Spacer()
								Text(value)
									.font(.subheadline)
									.foregroundStyle(.secondary)
							}
							Divider()
						}
					}
					.padding(8)
					.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
				}, header: {
					Text("Характеристики")
						.font(.headline).foregroundStyle(.primary)
				})

				Text("Описание")
					.font(.headline)
				Text(product.detailedDescription)
					.font(.body)
					.multilineTextAlignment(.leading)
				Section("Спецификации") {
					ForEach(product.specifications, id: \.self) { spec in
						Text("• \(spec)")
							.font(.subheadline)
							.foregroundStyle(.secondary)
					}
				}
				Spacer()
			}
			.padding(16)
		}
	}
}

// MARK: - RemoteImage

struct RemoteImage<ImageView: View>: View {
	let imageURL: String?
	@State var size: CGSize

	@State var loadedImage: (Image) -> ImageView
	public init(
		imageURL: String?,
		size: CGSize,
		@ViewBuilder loadedImage: @escaping (Image) -> ImageView
	) {
		self.imageURL = imageURL
		_size = State(wrappedValue: size)
		self.loadedImage = loadedImage
	}

	@ViewBuilder
	var body: some View {
		Group {
			if let imageURL, let url = URL(string: imageURL) {
				CachedAsyncImage(url: url) {
					loadedImage($0.resizable()).layoutPriority(1)
				} placeholder: {
					ProgressView().progressViewStyle(.circular)
						.scaledToFill()
						.padding()
				}
			} else {
				ProgressView().progressViewStyle(.circular)
					.scaledToFill()
					.padding()
			}
		}.fixedSize().saveSize(in: $size)
	}
	//        RoundedRectangle(Color.White, radius: 9.48)
	//            .overlay(alignment: .center) {
	//
	//            }
}

import SwiftUI

// MARK: - CachedAsyncImage

/// A view that asynchronously loads, cache and displays an image.
///
/// This view uses a custom default
/// <doc://com.apple.documentation/documentation/Foundation/URLSession>
/// instance to load an image from the specified URL, and then display it.
/// For example, you can display an icon that's stored on a server:
///
///     CachedAsyncImage(url: URL(string: "https://example.com/icon.png"))
///         .frame(width: 200, height: 200)
///
/// Until the image loads, the view displays a standard placeholder that
/// fills the available space. After the load completes successfully, the view
/// updates to display the image. In the example above, the icon is smaller
/// than the frame, and so appears smaller than the placeholder.
///
/// ![A diagram that shows a grey box on the left, the SwiftUI icon on the
/// right, and an arrow pointing from the first to the second. The icon
/// is about half the size of the grey box.]
///
/// You can specify a custom placeholder using
/// `init(url:urlCache:scale:content:placeholder:)`. With this initializer, you can
/// also use the `content` parameter to manipulate the loaded image.
/// For example, you can add a modifier to make the loaded image resizable:
///
///     CachedAsyncImage(url: URL(string: "https://example.com/icon.png")) { image in
///         image.resizable()
///     } placeholder: {
///         ProgressView()
///     }
///     .frame(width: 50, height: 50)
///
/// For this example, SwiftUI shows a `ProgressView` first, and then the
/// image scaled to fit in the specified frame:
///
///
/// > Important: You can't apply image-specific modifiers, like
/// `.resizable(capInsets:resizingMode:)`, directly to a `CachedAsyncImage`.
/// Instead, apply them to the `Image` instance that your `content`
/// closure gets when defining the view's appearance.
///
/// To gain more control over the loading process, use the
/// `.init(url:urlCache:scale:transaction:content:)` initializer, which takes a
/// `content` closure that receives an `AsyncImagePhase` to indicate
/// the state of the loading operation. Return a view that's appropriate
/// for the current phase:
///
///     CachedAsyncImage(url: URL(string: "https://example.com/icon.png")) { phase in
///         if let image = phase.image {
///             image // Displays the loaded image.
///         } else if phase.error != nil {
///             Color.red // Indicates an error.
///         } else {
///             Color.blue // Acts as a placeholder.
///         }
///     }
///
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct CachedAsyncImage<Content>: View where Content: View {
	@State private var phase: AsyncImagePhase

	private let urlRequest: URLRequest?

	private let urlSession: URLSession

	private let scale: CGFloat

	private let transaction: SwiftUI.Transaction

	private let content: (AsyncImagePhase) -> Content

	public var body: some View {
		content(phase)
			.task(id: urlRequest, load)
	}

	// Loads and displays an image from the specified URL.
	//
	// Until the image loads, SwiftUI displays a default placeholder. When
	// the load operation completes successfully, SwiftUI updates the
	// view to show the loaded image. If the operation fails, SwiftUI
	// continues to display the placeholder. The following example loads
	// and displays an icon from an example server:
	//
	//     CachedAsyncImage(url: URL(string: "https://example.com/icon.png"))
	//
	// If you want to customize the placeholder or apply image-specific
	// modifiers --- like `.resizable(capInsets:resizingMode:)` ---
	// to the loaded image, use the `.init(url:scale:content:placeholder:)`
	// initializer instead.
	//
	// - Parameters:
	//   - url: The URL of the image to display.
	//   - urlCache: The URL cache for providing cached responses to requests within the session.
	//   - scale: The scale to use for the image. The default is `1`. Set a
	//     different value when loading images designed for higher resolution
	//     displays. For example, set a value of `2` for an image that you
	//     would name with the `@2x` suffix if stored in a file on disk.

	public init(url: URL?, urlCache: URLCache = .shared, scale: CGFloat = 1) where Content == Image {
		let urlRequest = url == nil ? nil : URLRequest(url: url!)
		self.init(urlRequest: urlRequest, urlCache: urlCache, scale: scale)
	}

	/// Loads and displays an image from the specified URL.
	///
	/// Until the image loads, SwiftUI displays a default placeholder. When
	/// the load operation completes successfully, SwiftUI updates the
	/// view to show the loaded image. If the operation fails, SwiftUI
	/// continues to display the placeholder. The following example loads
	/// and displays an icon from an example server:
	///
	///     CachedAsyncImage(url: URL(string: "https://example.com/icon.png"))
	///
	/// If you want to customize the placeholder or apply image-specific
	/// modifiers --- like `.resizable(capInsets:resizingMode:)` ---
	/// to the loaded image, use the `init(url:scale:content:placeholder:)`
	/// initializer instead.
	///
	/// - Parameters:
	///   - urlRequest: The URL request of the image to display.
	///   - urlCache: The URL cache for providing cached responses to requests within the session.
	///   - scale: The scale to use for the image. The default is `1`. Set a
	///     different value when loading images designed for higher resolution
	///     displays. For example, set a value of `2` for an image that you
	///     would name with the `@2x` suffix if stored in a file on disk.
	public init(urlRequest: URLRequest?, urlCache: URLCache = .shared, scale: CGFloat = 1) where Content == Image {
		self.init(urlRequest: urlRequest, urlCache: urlCache, scale: scale) { phase in
			#if os(macOS)
				phase.image ?? Image(nsImage: .init())
			#else
				phase.image ?? Image(uiImage: .init())
			#endif
		}
	}

	// Loads and displays a modifiable image from the specified URL using
	// a custom placeholder until the image loads.
	//
	// Until the image loads, SwiftUI displays the placeholder view that
	// you specify. When the load operation completes successfully, SwiftUI
	// updates the view to show content that you specify, which you
	// create using the loaded image. For example, you can show a green
	// placeholder, followed by a tiled version of the loaded image:
	//
	//     CachedAsyncImage(url: URL(string: "https://example.com/icon.png")) { image in
	//         image.resizable(resizingMode: .tile)
	//     } placeholder: {
	//         Color.green
	//     }
	//
	// If the load operation fails, SwiftUI continues to display the
	// placeholder. To be able to display a different view on a load error,
	// use the `init(url:scale:transaction:content:)` initializer instead.
	//
	// - Parameters:
	//   - url: The URL of the image to display.
	//   - urlCache: The URL cache for providing cached responses to requests within the session.
	//   - scale: The scale to use for the image. The default is `1`. Set a
	//     different value when loading images designed for higher resolution
	//     displays. For example, set a value of `2` for an image that you
	//     would name with the `@2x` suffix if stored in a file on disk.
	//   - content: A closure that takes the loaded image as an input, and
	//     returns the view to show. You can return the image directly, or
	//     modify it as needed before returning it.
	//   - placeholder: A closure that returns the view to show until the
	//     load operation completes successfully.

	public init<I, P>(url: URL?, urlCache: URLCache = .shared, scale: CGFloat = 1, @ViewBuilder content: @escaping (Image) -> I, @ViewBuilder placeholder: @escaping () -> P) where Content == _ConditionalContent<I, P>, I: View, P: View {
		let urlRequest = url == nil ? nil : URLRequest(url: url!)
		self.init(urlRequest: urlRequest, urlCache: urlCache, scale: scale, content: content, placeholder: placeholder)
	}

	/// Loads and displays a modifiable image from the specified URL using
	/// a custom placeholder until the image loads.
	///
	/// Until the image loads, SwiftUI displays the placeholder view that
	/// you specify. When the load operation completes successfully, SwiftUI
	/// updates the view to show content that you specify, which you
	/// create using the loaded image. For example, you can show a green
	/// placeholder, followed by a tiled version of the loaded image:
	///
	///     CachedAsyncImage(url: URL(string: "https://example.com/icon.png")) { image in
	///         image.resizable(resizingMode: .tile)
	///     } placeholder: {
	///         Color.green
	///     }
	///
	/// If the load operation fails, SwiftUI continues to display the
	/// placeholder. To be able to display a different view on a load error,
	/// use the `init(url:scale:transaction:content:)` initializer instead.
	///
	/// - Parameters:
	///   - urlRequest: The URL request of the image to display.
	///   - urlCache: The URL cache for providing cached responses to requests within the session.
	///   - scale: The scale to use for the image. The default is `1`. Set a
	///     different value when loading images designed for higher resolution
	///     displays. For example, set a value of `2` for an image that you
	///     would name with the `@2x` suffix if stored in a file on disk.
	///   - content: A closure that takes the loaded image as an input, and
	///     returns the view to show. You can return the image directly, or
	///     modify it as needed before returning it.
	///   - placeholder: A closure that returns the view to show until the
	///     load operation completes successfully.
	public init<I, P>(urlRequest: URLRequest?, urlCache: URLCache = .shared, scale: CGFloat = 1, @ViewBuilder content: @escaping (Image) -> I, @ViewBuilder placeholder: @escaping () -> P) where Content == _ConditionalContent<I, P>, I: View, P: View {
		self.init(urlRequest: urlRequest, urlCache: urlCache, scale: scale) { phase in
			if let image = phase.image {
				content(image)
			} else {
				placeholder()
			}
		}
	}

	/// Loads and displays a modifiable image from the specified URL in phases.
	///
	///     CachedAsyncImage(url: URL(string: "https://example.com/icon.png")) { phase in
	///         if let image = phase.image {
	///             image // Displays the loaded image.
	///         } else if phase.error != nil {
	///             Color.red // Indicates an error.
	///         } else {
	///             Color.blue // Acts as a placeholder.
	///         }
	///     }
	///
	/// To add transitions when you change the URL, apply an identifier to the
	/// `CachedAsyncImage`.
	///
	/// - Parameters:
	///   - url: The URL of the image to display.
	///   - urlCache: The URL cache for providing cached responses to requests within the session.
	///   - scale: The scale to use for the image. The default is `1`. Set a
	///     different value when loading images designed for higher resolution
	///     displays. For example, set a value of `2` for an image that you
	///     would name with the `@2x` suffix if stored in a file on disk.
	///   - transaction: The transaction to use when the phase changes.
	///   - content: A closure that takes the load phase as an input, and
	///     returns the view to display for the specified phase.
	public init(url: URL?, urlCache: URLCache = .shared, scale: CGFloat = 1, transaction: SwiftUI.Transaction = Transaction(), @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
		let urlRequest = url == nil ? nil : URLRequest(url: url!)
		self.init(urlRequest: urlRequest, urlCache: urlCache, scale: scale, transaction: transaction, content: content)
	}

	public init(imageURL: String?,
	            urlCache: URLCache = .shared,
	            scale: CGFloat = 1,
	            transaction: SwiftUI.Transaction = Transaction(),
	            @ViewBuilder content: @escaping (AsyncImagePhase) -> Content)
	{
		var urlRequest: URLRequest?
		if let url = imageURL,
		   let url = URL(string: url)
		{
			urlRequest = URLRequest(url: url)
		}
		self.init(urlRequest: urlRequest, urlCache: urlCache, scale: scale, transaction: transaction, content: content)
	}

	/// Loads and displays a modifiable image from the specified URL in phases.
	/// To add transitions when you change the URL, apply an identifier to the
	/// `CachedAsyncImage`.
	///
	/// - Parameters:
	///   - urlRequest: The URL request of the image to display.
	///   - urlCache: The URL cache for providing cached responses to requests within the session.
	///   - scale: The scale to use for the image. The default is `1`. Set a
	///     different value when loading images designed for higher resolution
	///     displays. For example, set a value of `2` for an image that you
	///     would name with the `@2x` suffix if stored in a file on disk.
	///   - transaction: The transaction to use when the phase changes.
	///   - content: A closure that takes the load phase as an input, and
	///     returns the view to display for the specified phase.
	public init(urlRequest: URLRequest?, urlCache: URLCache = .shared, scale: CGFloat = 1, transaction: SwiftUI.Transaction = Transaction(), @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
		let configuration = URLSessionConfiguration.default
		configuration.urlCache = urlCache
		self.urlRequest = urlRequest
		self.urlSession = URLSession(configuration: configuration)
		self.scale = scale
		self.transaction = transaction
		self.content = content

		_phase = State(wrappedValue: .empty)
		do {
			if let urlRequest, let image = try cachedImage(from: urlRequest, cache: urlCache) {
				_phase = State(wrappedValue: .success(image))
			}
		} catch {
			_phase = State(wrappedValue: .failure(error))
		}
	}

	@Sendable
	private func load() async {
		do {
			if let urlRequest {
				let (image, metrics) = try await remoteImage(from: urlRequest, session: urlSession)
				if metrics.transactionMetrics.last?.resourceFetchType == .localCache {
					// WARNING: This does not behave well when the url is changed with another
					phase = .success(image)
				} else {
					withAnimation(transaction.animation) {
						phase = .success(image)
					}
				}
			} else {
				withAnimation(transaction.animation) {
					phase = .empty
				}
			}
		} catch {
			withAnimation(transaction.animation) {
				phase = .failure(error)
			}
		}
	}
}

// MARK: - AsyncImage.LoadingError

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private extension AsyncImage {
	struct LoadingError: Error {}
}

// MARK: - Helpers

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private extension CachedAsyncImage {
	private func remoteImage(from request: URLRequest, session: URLSession) async throws -> (Image, URLSessionTaskMetrics) {
		let (data, _, metrics) = try await session.data(for: request)
		if metrics.redirectCount > 0, let lastResponse = metrics.transactionMetrics.last?.response {
			let requests = metrics.transactionMetrics.map(\.request)
			requests.forEach(session.configuration.urlCache!.removeCachedResponse)
			let lastCachedResponse = CachedURLResponse(response: lastResponse, data: data)
			session.configuration.urlCache!.storeCachedResponse(lastCachedResponse, for: request)
		}
		return try (image(from: data), metrics)
	}

	private func cachedImage(from request: URLRequest, cache: URLCache) throws -> Image? {
		guard let cachedResponse = cache.cachedResponse(for: request) else {
			return nil
		}
		return try image(from: cachedResponse.data)
	}

	private func image(from data: Data) throws -> Image {
		#if os(macOS)
			if let nsImage = NSImage(data: data) {
				return Image(nsImage: nsImage)
			} else {
				throw AsyncImage<Content>.LoadingError()
			}
		#else
			if let uiImage = UIImage(data: data, scale: scale) {
				return Image(uiImage: uiImage)
			} else {
				throw AsyncImage<Content>.LoadingError()
			}
		#endif
	}
}

// MARK: - URLSessionTaskController

/// A class for managing URLSession tasks and collecting task metrics for AsyncImage loading.
final class URLSessionTaskController: NSObject, URLSessionTaskDelegate {
	/// The collected URLSessionTaskMetrics for a URLSession task.
	var metrics: URLSessionTaskMetrics?

	/// A delegate method called when URLSession task metrics have been collected.
	///
	/// - Parameters:
	///   - session: The URLSession object that collected the metrics.
	///   - task: The URLSessionTask that the metrics are associated with.
	///   - metrics: The collected URLSessionTaskMetrics.
	func urlSession(_: URLSession, task _: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
		self.metrics = metrics
	}
}

/// An extension on URLSession to provide asynchronous data fetching with task metrics.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private extension URLSession {
	/// Fetches data asynchronously for a given URLRequest and collects URLSessionTaskMetrics.
	///
	/// - Parameters:
	///   - request: The URLRequest to fetch data for.
	/// - Returns: A tuple containing the fetched Data, URLResponse, and URLSessionTaskMetrics.
	/// - Throws: An error if data fetching or metric collection fails.
	func data(for request: URLRequest) async throws -> (Data, URLResponse, URLSessionTaskMetrics) {
		let controller = URLSessionTaskController()
		let (data, response) = try await data(for: request, delegate: controller)
		return (data, response, controller.metrics!)
	}
}

// MARK: - RemoteImage
