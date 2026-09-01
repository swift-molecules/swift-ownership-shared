public import Cardinal_Standard_Library_Integration
public import Cardinal_Carrier
public import Cardinal_Tagged
public import Cardinal
public import Ordinal_Protocol
public import Ordinal_Cardinal
public import Ordinal_Tagged
public import Ordinal
public import Index
public import Tagged
public import Memory_Allocator_Protocol
public import Buffer_Protocol
public import Store_Protocol
public import Store
public import Ownership_Box
public import Span_Protocol

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
