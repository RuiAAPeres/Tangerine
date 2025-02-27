# Tangerine 🍊

Tangerine is a Swift µframework for fetching Images. 


## Installation 

### Swift Package Manager

Swift Package Manager is integrated within Xcode 11, so using Tangerine in your project is a piece of cake:

1. File → Swift Packages → Add Package Dependency...
2. Paste the repository URL (`https://github.com/RuiAAPeres/Tangerine`) and click Next.
3. For Rules, either select version, branch or commit.
4. Select the Target where you would like to add Tangerine. The correct one should be already selected for you. 
5. Click Finish.

### Manual Installation
Drag the `Tangerine.swift` file into your project. 🍊

## Usage

Typically a view should have a single `ImageFetcher`, and as such it’s not possible for one to fetch different images with only one instance of a `ImageFetcher`. From a code point of view:


```swift 
let tangerines = URL(string: "https://www.strongertogether.coop/sites/default/files/Tangerines.jpg")!
let fetcher = ImageFetcher(urL: tangerines)
let example = ExampleView(fetcher: fetcher)
```

```swift 
struct ExampleView: View {
  @ObservedObject var fetcher: ImageFetcher
  
  init(fetcher: ImageFetcher) {
    self.fetcher = fetcher
  }
  
  var body: some View {
    VStack {
      fetcher.image.map {
        Image(uiImage: $0)
          .resizable()
          .aspectRatio(contentMode: .fit)
      }
    }
    .onAppear(perform: fetcher.refresh)
  }
}
``` 

The actual HTTP request is done not when the `ImageFetcher` is created, but when the `refresh` method is called.  

Tangerine also supports caching via `NSCache`. You can either supply yours, or use the default one. 



