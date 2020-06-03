// Little helper to avoid having to type `.compactMap { $0 }
// in favour of `.compactMap(identity)`, therefore keeping
// the style more pointfree-like https://wiki.haskell.org/Pointfree
// It is 100% not necessary but I find it nice to read.
func identity<T>(_ t: T) -> T { t }
