public import Cardinal
public import Tagged
public import Carrier
public import Ordinal
public import Property
public import Index
public import Memory_Small
public import Memory_Allocator_Protocol
public import Buffer
public import Store
public import Buffer_Linear_Primitive
public import Memory_Allocator
public import Memory
public import Ownership
public import Storage

extension Ownership.Shared where Element: ~Copyable, B: ~Copyable {

    @inlinable
    public func withSpan<R, Failure: Swift.Error>(
        _ body: (Swift.Span<Element>) throws(Failure) -> R
    ) throws(Failure) -> R
    where B == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear {
        try unsafe Self._withSpan(box.unguarded, body)
    }

    @inlinable
    public mutating func withMutableSpan<R, Failure: Swift.Error>(
        _ body: (inout Swift.MutableSpan<Element>) throws(Failure) -> R
    ) throws(Failure) -> R
    where
        B == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear,
        Element: Copyable
    {
        ensureUnique()
        return try unsafe Self._withMutableSpan(&box.unguarded, body)
    }

    @inlinable
    public mutating func withMutableSpanAssumingUnique<R, Failure: Swift.Error>(
        _ body: (inout Swift.MutableSpan<Element>) throws(Failure) -> R
    ) throws(Failure) -> R
    where B == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear {
        assert(box.isUnique, "AssumingUnique on a shared box")
        return try unsafe Self._withMutableSpan(&box.unguarded, body)
    }

    @inlinable
    package static func _withSpan<R, Failure: Swift.Error>(
        _ buffer:
            borrowing Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear,
        _ body: (Swift.Span<Element>) throws(Failure) -> R
    ) throws(Failure) -> R {
        try body(buffer.span)
    }

    @inlinable
    package static func _withMutableSpan<R, Failure: Swift.Error>(
        _ buffer: inout Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear,
        _ body: (inout Swift.MutableSpan<Element>) throws(Failure) -> R
    ) throws(Failure) -> R {
        var span = buffer.mutableSpan()
        return try body(&span)
    }
}
