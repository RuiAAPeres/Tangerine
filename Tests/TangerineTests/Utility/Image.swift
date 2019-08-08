import CoreGraphics
import UIKit

let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
let image = renderer .image { context in
    context.cgContext.setFillColor(UIColor.red.cgColor)
    context.cgContext.addEllipse(in: CGRect(x: 0, y: 0, width: 1, height: 1))
    context.cgContext.drawPath(using: .fillStroke)
}
