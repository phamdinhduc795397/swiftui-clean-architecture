# SwiftUI-Clean-Architectures
A SwiftUI project implements Clean Architecture, MVVM & Coordinator pattern.

# Layers
- Domain Layer: Entities + Use Cases + Repositories Protocols
- Data Layer: Repositories Implementations + Data Sources(API Network, DB)
- Presentation Layer (MVVM): ViewModels + Views

![alt text](Images/Clean.png?raw=true)

# MVVM & Coordinator

The Coordinator pattern reduces direct dependencies between scenes, alowing groups to use a particalure flow to visualize transition between views

![alt text](Images/MVVM-C.png?raw=true)

## MVVM implementation

The `ViewModel` protocol has two relelated types. While `Input` defines as input that can be triggered using the trigger method, `State` refers to a scence's specific state.

```swift
protocol ViewModel: ObservableObject where ObjectWillChangePublisher.Output == Void {
    associatedtype State
    associatedtype Input

    var state: State { get set }
    func trigger(_ input: Input)
}
```

The `AnyViewModel` is a type erasure and wrapper that conforming to the `ViewModel` protocol, with the associated types being the given generic types `State` and `Input`.
Making state settable, which goes against `MVVM`. However, it serves many typical SwiftUI situations that require Binding as input, such as `TextField`, `TextEditor`, ect.

```swift
@dynamicMemberLookup
final class AnyViewModel<State, Input>: ViewModel {

    private let wrappedObjectWillChange: () -> AnyPublisher<Void, Never>
    private var wrappedState: () -> State
    private let wrappedTrigger: (Input) -> Void
    private let updateWrappedState: (State) -> Void
    
    var objectWillChange: AnyPublisher<Void, Never> {
        wrappedObjectWillChange()
    }
    
    var state: State {
        get { wrappedState() }
        set { updateWrappedState(newValue) }
    }
    
    func trigger(_ input: Input) {
        wrappedTrigger(input)
    }

    subscript<Value>(dynamicMember keyPath: WritableKeyPath<State, Value>) -> Value {
        get { state[keyPath: keyPath] }
        set { state[keyPath: keyPath] = newValue }
    }
    
    init<V: ViewModel>(_ viewModel: V) where V.State == State, V.Input == Input {
        self.updateWrappedState = { viewModel.state = $0 }
        self.wrappedState = { viewModel.state }
        self.wrappedTrigger = viewModel.trigger
        self.wrappedObjectWillChange = { viewModel.objectWillChange.eraseToAnyPublisher() }
    }
}
```

## View implementation
Define a separate `State` and `Input` for each view. 

```swift
struct EverythingState {
    var keyword: String = ""
    var articles: [Article] = []
}

enum EverythingInput {
    case fetchData
    case showDetail(Article)
}

class EverythingViewModel: ViewModel {
    
    @Published
    var state: EverythingState = .init()
    
    let fetchDataStream = PassthroughRelay<Void>()
    private var cancellables = Set<AnyCancellable>()
    
    @RouterObject
    var router: EverythingCoordinator.Router?
    
    @Injected(\.fetchEverythingUseCase)
    var fetchEverythingUseCase
    
    init() {
        initData()
    }
    
    func initData() {
        let fetchingArticles = fetchDataStream
            .prefix(1)
            .withUnretained(self)
            .flatMap { base, _ in
                base.fetchEverything(keyword: "Apple")
            }
        
        let searchingArticles = $state
            .map(\.keyword)
            .removeDuplicates()
            .dropFirst()
            .withUnretained(self)
            .flatMap { base, keyword in
                base.fetchEverything(keyword: keyword)
            }
        
        Publishers.Merge(fetchingArticles, searchingArticles)
            .assign(to: \.state.articles, on: self, ownership: .weak)
            .store(in: &cancellables)
    }
    
    private func fetchEverything(keyword: String) -> AnyPublisher<[Article], Never> {
        fetchEverythingUseCase
            .execute(.init(keyword: keyword, page: 1, pageSize: 20))
            .map { $0.articles }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    func trigger(_ input: EverythingInput) {
        switch input {
        case .fetchData:
            fetchDataStream.accept()
        case .showDetail(let article):
            router?.route(to: \.detail, article)
        }
    }
}

```

```swift
struct EverythingScreen: View {
    @ObservedObject var viewModel: AnyViewModel<EverythingState, EverythingInput>
    
    var body: some View {
        List {
            ForEach(viewModel.state.articles) { article in
                ArticleCell(article: article)
                    .onTapGesture {
                        viewModel.trigger(.showDetail(article))
                    }
            }
        }
        .onAppear {
            viewModel.trigger(.fetchData)
        }
        .searchable(text: $viewModel.keyword)
    }
}
```

We can use `Never` as input type.
```swift
import SwiftUI

struct EverythingDetailScreen: View {
    @ObservedObject var viewModel: AnyViewModel<EverythingDetailState, Never>

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                if let urlToImage = viewModel.article.urlToImage {
                    AsyncImage(url: .init(string: urlToImage)) { phase in
                        if let image = phase.image {
                            image.resizable()
                                .aspectRatio(1, contentMode: .fill)
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(width: 100, height: 100)
                }
                Text(viewModel.article.title)
                    .font(.title)
            }
            Text(viewModel.article.content ?? "")
                .font(.body)
            Spacer()
        }
    }
}
```

## Coordinator implementation

```swift
struct EverythingCoordinator: View {
    enum Screen: Hashable {
        case detail(Article)
    }
    
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            rootView()
                .navigationDestination(for: Screen.self) { screen in
                    switch screen {
                    case .detail(let article):
                        EverythingDetailScreen(viewModel: AnyViewModel(EverythingDetailViewModel(article: article)))
                    }
                }
        }
    }
    
    
    @ViewBuilder
    func rootView() -> some View {
        let viewModel = EverythingViewModel(onShowingDetail: showDetail)
        EverythingScreen(viewModel: AnyViewModel(viewModel))
    }
    
    func showDetail(_ article: Article) {
        path.append(Screen.detail(article))
    }
}

```

## DI implementation

```swift
import Factory

// Service
extension Container {
    var networkService: Factory<NetworkServiceType> {
        Factory(self) { NetworkService() }.singleton
    }
}

// Repository
extension Container {
    var articleRepository: Factory<ArticleRepositoryType> {
        Factory(self) { ArticleRepository(networkService: self.networkService()) }
    }
}

// Use case
extension Container {
    var fetchEverythingUseCase: Factory<FetchEverythingUseCase> {
        Factory(self) { FetchEverythingUseCase(repository: self.articleRepository()) }
    }
    
    var fetchTopHeadlinesUseCase: Factory<FetchTopHeadlinesUseCase> {
        Factory(self) { FetchTopHeadlinesUseCase(repository: self.articleRepository()) }
    }
}
```

## Concepts and References:
- Clean Architecture https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
- SwiftUI-Architectures https://github.com/quickbirdeng/SwiftUI-Architectures

## Author

Duc Pham, phamdinhduc795397@gmail.com

## License

Coordinator is available under the MIT license. See the LICENSE file for more info.
