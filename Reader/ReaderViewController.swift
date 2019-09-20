import UIKit

final class ReaderViewController: UIViewController {

  private let contentView = UIScrollView()
  private var textViews: [UITextView] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    navigationItem.title = "Reader"
    
    setupContentView()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setupReader()
  }
  
  private func fullContent() -> String {
    let url = Bundle.main.url(forResource: "Diamond Sutra", withExtension: "txt")!
    return try! String(contentsOf: url, encoding: .utf8)
  }
  
  private func setupContentView() {
    contentView.backgroundColor = .white
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.showsVerticalScrollIndicator = false
    contentView.showsHorizontalScrollIndicator = false
    contentView.isPagingEnabled = true
    view.addSubview(contentView)
    
    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
    ])
  }
  
  private func setupReader() {
    // 1
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.2
    
    let attributedString = NSAttributedString(
      string: fullContent(),
      attributes: [
        .font: UIFont.preferredFont(forTextStyle: .body),
        .paragraphStyle: paragraphStyle
      ]
    )

    // 2
    let textStorage = NSTextStorage(attributedString: attributedString)

    // 3
    let textLayout = NSLayoutManager()
    textStorage.addLayoutManager(textLayout)

    let viewSize = contentView.bounds.size
    let textInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    // 1
    var index: Int = 0
    var glyphRange: Int = 0
    var numberOfGlyphs: Int = 0

    repeat {
      // 2
      let textContainer = NSTextContainer(size: viewSize)
      textLayout.addTextContainer(textContainer)
      
      // 3
      let textViewFrame = CGRect(
        x: CGFloat(index) * viewSize.width,
        y: 0,
        width: viewSize.width,
        height: viewSize.height
      )
      
      // 4
      let textView = UITextView(
        frame: textViewFrame,
        textContainer: textContainer
      )
      
      // 5
      textView.backgroundColor = .white
      textView.isEditable = false
      textView.isSelectable = false
      textView.textContainerInset = textInsets
      textView.showsVerticalScrollIndicator = false
      textView.showsHorizontalScrollIndicator = false
      textView.isScrollEnabled = false
      textView.bounces = false
      textView.bouncesZoom = false
      
      // 6
      textViews.append(textView)
      contentView.addSubview(textView)
      
      // 7
      index += 1
      glyphRange = NSMaxRange(textLayout.glyphRange(for: textContainer))
      numberOfGlyphs = textLayout.numberOfGlyphs
    } while glyphRange < numberOfGlyphs - 1 // 8
    
    contentView.contentSize = CGSize(
      width: viewSize.width * CGFloat(textViews.count),
      height: viewSize.height
    )
  }
  
}
