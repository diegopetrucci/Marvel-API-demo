import class UIKit.UIImage
import class Foundation.Bundle

#if DEBUG
extension UIImage {
    static func fixture(for bundle: Bundle? = nil) -> UIImage {
        UIImage(named: "thumbnail_fixture", in: bundle, compatibleWith: nil)!
    }
}
#endif
