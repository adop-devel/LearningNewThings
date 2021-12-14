//
//  ContentView.swift
//  LearningNewThings
//
//  Created by ADOP_Mac on 2021/11/17.
//


// TODO: Learn what blendMode is. and WHAT IS .destinationOut
// TODO: Learn what compositingGroup is.

import SwiftUI
import Combine
import UIKit

struct ContentView: View {
    
    @EnvironmentObject var UIState: UIStateModelForVerticalCarousel
    
    @State var articles: [EachArticleForCarouselView] = [] 
    @GestureState var isUserLongPressing = false
    
    @State var basePosition: CGFloat = 0.0
    
    @State var showDetailedArticleSheet: Bool = false
    
    let screenSize: CGSize
    let cardSizeWidth: CGFloat
    let cardSizeHeight: CGFloat
    
    let inBetweenCardSpace: CGFloat
    
    init() {
        screenSize = UIScreen.main.bounds.size
        cardSizeWidth = screenSize.width * 0.8
        cardSizeHeight = cardSizeWidth * 0.67
        inBetweenCardSpace = 20
    }
    
    // futura, Hoefler Text, Phosphate, Trebuchet MS
    var body: some View {
        ZStack {
            UserNameView(userName: "Markus Oh", cardSizeHeight: cardSizeHeight)
            CarouselView(articles: $articles,
                         inBetweenCardSpace: inBetweenCardSpace,
                         cardSizeWidth: cardSizeWidth,
                         cardSizeHeight: cardSizeHeight,
                         contentForEachArticleView: {
                DetailedArticleSheet(articles: articles)
            })
        }
        .ignoreSafeArea()
        .onAppear {
            ArticleFetcher.getArticle { articles in
                self.articles = Array(articles[0..<5].enumerated().map {
                    EachArticleForCarouselView(carouselID: $0.0,
                                               article: $0.1)
                })
            }
        }
    }
}

struct UserNameView: View {
    let userName: String
    let cardSizeHeight: CGFloat
    
    var body: some View {
        VStack {
            Spacer().frame(height: UIScreen.main.bounds.height - (UIScreen.main.bounds.height / 2 + cardSizeHeight * 1.2))
            Text(LocalizedStringKey("app-greet-title \(userName)"))
                .frame(height: cardSizeHeight, alignment: .center)
            Spacer().frame(height: UIScreen.main.bounds.height / 2 + cardSizeHeight * 1.2)
        }
    }
}

struct EachArticleForCarouselView: Equatable {
    static func == (lhs: EachArticleForCarouselView, rhs: EachArticleForCarouselView) -> Bool {
        return lhs.carouselID == rhs.carouselID
    }
    
    let carouselID: Int
    let article: Article
}

struct CarouselView<EachSheetView : View>: View {
    @EnvironmentObject var UIState: UIStateModelForVerticalCarousel
    @State var showDetailedArticleSheet: Bool = false
    @GestureState var isUserLongPressing: Bool = false
    
    @Binding var articles: [EachArticleForCarouselView]
    
    @State var basePosition: CGFloat = 0.0
    let inBetweenCardSpace: CGFloat
    let cardSizeWidth: CGFloat
    let cardSizeHeight: CGFloat
    let eachArticleTapSheetView: EachSheetView
    
    init(articles: Binding<[EachArticleForCarouselView]>, inBetweenCardSpace: CGFloat, cardSizeWidth: CGFloat, cardSizeHeight: CGFloat, @ViewBuilder contentForEachArticleView: () -> EachSheetView) {
        self._articles = articles
        self.inBetweenCardSpace = inBetweenCardSpace
        self.cardSizeWidth = cardSizeWidth
        self.cardSizeHeight = cardSizeHeight
        self.eachArticleTapSheetView = contentForEachArticleView()
    }
    
    var body: some View {
        let cardHeightToShift = cardSizeHeight * 1.2 * CGFloat(UIState.activeCard)
        let spaceInBetweenToShift = inBetweenCardSpace * CGFloat(UIState.activeCard)
        let yOffset = basePosition - cardHeightToShift + spaceInBetweenToShift + CGFloat(UIState.screenDrag)
        
        return VStack(alignment: .center, spacing: inBetweenCardSpace) {
            ForEach(articles, id: \.carouselID.self) { eachArticle in
                CardItem(_id: eachArticle.carouselID,
                         spacing: inBetweenCardSpace,
                         widthOfUnselectedCards: cardSizeWidth) {
                    ScalingTextViewWhenAppear(_id: eachArticle.carouselID, textToAppear: eachArticle.article.subject, imageURL: eachArticle.article.imageUrls!.first!, cardWidth: cardSizeWidth, cardHeight: cardSizeHeight)
                }.gesture(TapGesture().onEnded({ _ in
                    showDetailedArticleSheet.toggle()
                })).shadow(radius: eachArticle.carouselID == UIState.activeCard ? 10 : 0)
            }
        }
        .offset(x: 0, y: yOffset)
        .gesture(DragGesture().updating($isUserLongPressing) { currentState, gestureState, transaction in
            UIState.screenDrag = Float(currentState.translation.height)
        }.onEnded{ dragValue in
            withAnimation(.spring()) {
                let draggedHeight = dragValue.translation.height
                if draggedHeight < -cardSizeHeight - 50 {
                    UIState.activeCard += abs(Int(draggedHeight / cardSizeHeight))
                } else if dragValue.translation.height < -50 {
                    UIState.activeCard += 1
                } else if dragValue.translation.height > cardSizeHeight + 50 {
                    UIState.activeCard -= abs(Int(draggedHeight / cardSizeHeight))
                } else if dragValue.translation.height > +50 {
                    UIState.activeCard -= 1
                }
                
                if UIState.activeCard < 0 {
                    UIState.activeCard = 0
                } else if UIState.activeCard >= articles.count {
                    UIState.activeCard = articles.count - 1
                }
                
                UIState.screenDrag = 0
            }
        })
        .sheet(isPresented: $showDetailedArticleSheet) {
            
        } content: {
            eachArticleTapSheetView
        }
        .valueChanged(value: articles) { newValue in
            let inBetweenSpaceTotal = inBetweenCardSpace * CGFloat(articles.count - 1)
            let cardsHeightTotal = cardSizeHeight * CGFloat(articles.count)
            let carouselTotalHeight = cardsHeightTotal + inBetweenSpaceTotal
            basePosition = carouselTotalHeight / 2 - cardSizeHeight / 2
        }
    }
}

struct DetailedArticleSheet: View {
    @EnvironmentObject var CarouselMenuState: UIStateModelForVerticalCarousel
    
    let articles: [EachArticleForCarouselView]
    
    var body: some View {
        Text("\( articles.filter{ $0.carouselID == CarouselMenuState.activeCard }.first!.article.content! )")
    }
}

public class UIStateModelForVerticalCarousel: ObservableObject {
    @Published var activeCard: Int = 0
    @Published var screenDrag: Float = 0.0
}

struct CardItem<Content: View>: View {
    @EnvironmentObject var UIState: UIStateModelForVerticalCarousel
    let cardWidth: CGFloat
    let cardHeight: CGFloat

    var _id: Int
    var content: Content

    @inlinable public init(
        _id: Int,
        spacing: CGFloat,
        widthOfUnselectedCards: CGFloat,
        @ViewBuilder _ content: () -> Content
    ) {
        self.content = content()
        self.cardWidth = widthOfUnselectedCards * 1.2
        self.cardHeight = cardWidth * 0.67
        self._id = _id
    }

    var body: some View {
        content
            .frame(width: _id == UIState.activeCard ? cardWidth : cardWidth / 1.2,
                   height: _id == UIState.activeCard ? cardHeight : cardHeight / 1.2, alignment: .center)
            .clipped()
    }
}

struct ScalingTextViewWhenAppear: View {
    @EnvironmentObject var UIState: UIStateModelForVerticalCarousel
    
    let _id: Int
    let textToAppear: String
    let imageURL: URL
    
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    
    @State var textScale: CGFloat = 1.0
    
    var body: some View {
        ZStack(alignment: .center, content: {
            ImageView(width: cardWidth, height: cardHeight, imageURL: imageURL)
                .padding(0)
            ZStack{
                Text("\(textToAppear)")
                    .frame(maxWidth: .infinity, maxHeight: 30)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 20, weight: .regular, design: .rounded))
                    .foregroundColor(.white)
            }
        })
        .clipped()
        .padding(0)
    }
}

struct ImageView: View {
    @State var isLoaded: Bool = false
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    @ObservedObject var imageLoader: ImageLoader
    
    @State var loadedImage: UIImage = UIImage()
    
    init(width: CGFloat, height: CGFloat, imageURL: URL) {
        self.cardWidth = width
        self.cardHeight = height
        imageLoader = ImageLoader(url: imageURL)
    }
    
    var body: some View {
        ZStack {
            if !isLoaded {
                LoadingView()
            }
            Image(uiImage: loadedImage)
                .onReceive(imageLoader.didChange) { data in
                    let uiImage = UIImage(data: data) ?? UIImage()
                    
                    let originalImageSize = uiImage.size
                    
                    var transformedImageSizeWidth: CGFloat = 0.0
                    var transformedImageSizeHeight: CGFloat = 0.0
                    var trasnformedXOffset:CGFloat = 0.0
                    var trasnformedYOffset:CGFloat = 0.0
                    
                    // IF Image is longer horizontally
                    if (originalImageSize.width / originalImageSize.height) > (cardWidth / cardHeight) {
                        transformedImageSizeHeight = originalImageSize.height
                        transformedImageSizeWidth = transformedImageSizeHeight / (cardHeight / cardWidth)
                        trasnformedYOffset = 0.0
                        trasnformedXOffset = (originalImageSize.width - transformedImageSizeWidth) / 2.0
                    }
                    
                    // IF Image is longer vertically
                    else {
                        transformedImageSizeWidth = originalImageSize.width
                        transformedImageSizeHeight = transformedImageSizeWidth * (cardHeight / cardWidth)
                        trasnformedXOffset = 0.0
                        trasnformedYOffset = (originalImageSize.height - transformedImageSizeHeight) / 2.0
                    }
                    
                    let cropRect = CGRect(
                        x: trasnformedXOffset,
                        y: trasnformedYOffset,
                        width: transformedImageSizeWidth,
                        height: transformedImageSizeHeight).integral
                    
                    let sourceCGImage = uiImage.cgImage!
                    let croppedCGImage = sourceCGImage.cropping(to: cropRect)!
                    let croppedUIImage = UIImage(
                            cgImage: croppedCGImage,
                            scale: uiImage.imageRendererFormat.scale,
                            orientation: uiImage.imageOrientation)
                    
                    DispatchQueue.main.async {
                        self.loadedImage = croppedUIImage
                        self.isLoaded = true
                    }
                }
        }
    }
}

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(url:URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}

struct LoadingView: View {
    
    @State private var shouldAnimate = false
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 20, height: 20)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever())
            Circle()
                .fill(Color.blue)
                .frame(width: 20, height: 20)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.3))
            Circle()
                .fill(Color.blue)
                .frame(width: 20, height: 20)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.6))
        }
        .onAppear {
            self.shouldAnimate = true
        }
    }
    
}

struct Article: Decodable, Identifiable {
    let id: UUID
    let articleID: Int
    let subject: String
    let articleWebpageURL: URL
    let content: String?
    var imageUrls: [URL]?
    
    enum RootKeys: String, CodingKey {
        case articleID = "id"
        case subject = "title"
        case articleWebpageURL = "contentURL"
        case content = "content"
        case files = "files"
    }
    
    enum FilesKeys: String, CodingKey {
        case imageUrl = "filePath"
    }
    
    init(from decoder: Decoder) throws {
        id = UUID()
        
        let rootContainer = try! decoder.container(keyedBy: RootKeys.self)
        articleID = try! rootContainer.decode(Int.self, forKey: .articleID)
        subject = try! rootContainer.decode(String.self, forKey: .subject)
        let articleWebpageURLString = try! rootContainer.decode(String.self, forKey: .articleWebpageURL)
        articleWebpageURL = URL(string: articleWebpageURLString)!
        content = try? rootContainer.decode(String.self, forKey: .content)
        
        guard
            var filesContainer = try? rootContainer.nestedUnkeyedContainer(forKey: .files) else {
                return
            }
        
        var imageUrls: Array<URL>?
        while !filesContainer.isAtEnd {
            guard let filesNestedContainer = try? filesContainer.nestedContainer(keyedBy: FilesKeys.self) else {
                return
            }
            
            guard let urlString = try? filesNestedContainer.decode(String.self, forKey: .imageUrl),
                  let url = URL(string: urlString) else { return }
            
            if imageUrls == nil {
                imageUrls = Array<URL>()
                imageUrls!.append(url)
            } else {
                imageUrls!.append(url)
            }
        }
        
        self.imageUrls = imageUrls
    }
}

class ArticleFetcher {
    static func getArticle(afterFetchingArticles: @escaping ([Article]) -> ()) {
        guard let url = URL(string: "http://52.78.54.195:3000/contents") else {
            fatalError("Learning New Things: INVALID URL")
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else {
                fatalError("Learning New Things: Error while fetching articles - \(error!.localizedDescription)")
            }
            
            guard let newArticles = try? JSONDecoder().decode([Article].self, from: data!) else {
                fatalError("Learning New Things: Error while decoding")
            }
            
            afterFetchingArticles(newArticles)
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UIStateModelForVerticalCarousel())
            .environment(\.locale, .init(identifier: "ko"))
    }
}

extension UIColor {
    func convertUIColor() -> Color {
        return Color(
            red: Double(self.cgColor.components![0]),
            green: Double(self.cgColor.components![1]),
            blue: Double(self.cgColor.components![2])
        )
    }
}

extension View {
    /// A backwards compatible wrapper for iOS 14 `onChange`
    @ViewBuilder func valueChanged<T: Equatable>(value: T, onChange: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: onChange)
        } else {
            self.onReceive(Just(value)) { (value) in
                onChange(value)
            }
        }
    }
}

extension View {
    /// A backwards compatible warpper for iOS 14 'ignoresSafeArea()'
    @ViewBuilder func ignoreSafeArea() -> some View {
        if #available(iOS 14.0, *) {
            self.ignoresSafeArea()
        } else {
            self.edgesIgnoringSafeArea(.all)
        }
    }
}
