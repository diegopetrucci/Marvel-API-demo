// Various little helpers

// To avoid having to type `.compactMap { $0 }
// in favour of `.compactMap(identity)`, therefore keeping
// the style more pointfree-like https://wiki.haskell.org/Pointfree
// It is 100% not necessary but I find it nice to read.
func identity<T>(_ t: T) -> T { t }

// To avoid having to type `!=`
extension Optional {
    var isNotNil: Bool {
        self != nil
    }
}

// `myArray[1]` is not safe
extension Array {
    var second: Element? {
        self.count > 1
            ? self[1]
            : nil
    }
}

// Swift reads left to right, while the negation operator
// reads right to left
extension Bool {
    var isFalse: Bool {
        !self
    }
}
