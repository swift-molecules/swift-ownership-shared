import Affine
public import Buffer
public import Buffer_Linear_Primitive
import Cardinal
import Carrier
import Index
public import Memory
public import Memory_Allocator
import Memory_Allocator_Protocol
import Ordinal
public import Ownership
import Property
public import Storage
import Store
import Tagged

extension Ownership.Shared where Element: ~Copyable, B: ~Copyable {

    @inlinable
    public func withSpan<Resource: Memory.Region & ~Copyable, R, Failure: Swift::Error>(
        _ body: (Swift::Span<Element>) throws(Failure) -> R
    ) throws(Failure) -> R
    where B == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Linear {
        try unsafe Self._withSpan(box.unguarded, body)
    }

    @inlinable
    public mutating func withMutableSpan<Resource: Memory.Region & ~Copyable, R, Failure: Swift::Error>(
        _ body: (inout Swift::MutableSpan<Element>) throws(Failure) -> R
    ) throws(Failure) -> R
    where
        B == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Linear,
        Element: Copyable
    {
        ensureUnique()
        return try unsafe Self._withMutableSpan(&box.unguarded, body)
    }

    @inlinable
    public mutating func withMutableSpanAssumingUnique<Resource: Memory.Region & ~Copyable, R, Failure: Swift::Error>(
        _ body: (inout Swift::MutableSpan<Element>) throws(Failure) -> R
    ) throws(Failure) -> R
    where B == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Linear {
        assert(box.isUnique, "AssumingUnique on a shared box")
        return try unsafe Self._withMutableSpan(&box.unguarded, body)
    }

    @inlinable
    package static func _withSpan<Resource: Memory.Region & ~Copyable, R, Failure: Swift::Error>(
        _ buffer:
            borrowing Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Linear,
        _ body: (Swift::Span<Element>) throws(Failure) -> R
    ) throws(Failure) -> R {
        try body(buffer.span)
    }

    @inlinable
    package static func _withMutableSpan<Resource: Memory.Region & ~Copyable, R, Failure: Swift::Error>(
        _ buffer: inout Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Linear,
        _ body: (inout Swift::MutableSpan<Element>) throws(Failure) -> R
    ) throws(Failure) -> R {
        var span = buffer.mutableSpan()
        return try body(&span)
    }
}

extension Ownership.Shared: Equatable where Element: Equatable, B: ~Copyable {

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.count == rhs.count else { return false }
        var slot: Index<Element> = .zero
        let end = lhs.count.map(Ordinal.init)
        while slot < end {
            guard lhs[slot] == rhs[slot] else { return false }
            slot += .one
        }
        return true
    }
}

extension Ownership.Shared: Hashable where Element: Hashable, B: ~Copyable {

    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(Int(bitPattern: count.underlying))
        var slot: Index<Element> = .zero
        let end = count.map(Ordinal.init)
        while slot < end {
            hasher.combine(self[slot])
            slot += .one
        }
    }
}

extension Ownership.Shared where Element: ~Copyable, B: ~Copyable {

    @inlinable
    public mutating func withUnique<R: ~Copyable, Failure: Swift::Error>(
        _ body: (inout B) throws(Failure) -> R
    ) throws(Failure) -> R {
        ensureUnique()
        return try unsafe body(&box.unguarded)
    }

    @inlinable
    public mutating func withUnique<T: ~Copyable, R: ~Copyable, Failure: Swift::Error>(
        consuming payload: consuming T,
        _ body: (inout B, consuming T) throws(Failure) -> R
    ) throws(Failure) -> R {
        ensureUnique()
        return try unsafe body(&box.unguarded, payload)
    }

    @inlinable
    public func withColumn<R: ~Copyable, Failure: Swift::Error>(
        _ body: (borrowing B) throws(Failure) -> R
    ) throws(Failure) -> R {
        try unsafe body(box.unguarded)
    }
}
