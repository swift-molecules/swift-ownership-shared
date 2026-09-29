public import Cardinal
public import Tagged
public import Carrier
public import Ordinal
public import Property
public import Index
public import Memory_Allocator_Protocol
public import Buffer
public import Store
public import Ownership
public import Span

extension Ownership.Shared where Element: ~Copyable, B: ~Copyable {

    @inlinable
    package static func _window(
        of column: borrowing B
    ) -> (base: UnsafeRawPointer?, count: Int) where B: Span.`Protocol`, B.Element == Element {
        column.span.withUnsafeBufferPointer { ptr in
            unsafe (UnsafeRawPointer(ptr.baseAddress), ptr.count)
        }
    }
}

extension Ownership.Shared: Span.`Protocol` where B: Span.`Protocol`, B: ~Copyable {

    @inlinable
    public var span: Swift.Span<Element> {
        @_lifetime(borrow self)
        borrowing get {
            let raw = unsafe Self._window(of: box.unguarded)
            let typed =
                unsafe (raw.base?.assumingMemoryBound(to: Element.self))
                ?? UnsafePointer<Element>(bitPattern: MemoryLayout<Element>.alignment)
                .unsafelyUnwrapped
            let laundered = unsafe Swift.Span(
                _unsafeStart: typed,
                count: raw.base == nil ? 0 : raw.count
            )
            return unsafe _overrideLifetime(laundered, borrowing: self)
        }
    }
}
