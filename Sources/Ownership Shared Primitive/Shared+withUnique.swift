import Buffer
import Cardinal
import Carrier
import Index
import Memory_Allocator_Protocol
import Ordinal
public import Ownership
import Property
import Store
import Tagged

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
