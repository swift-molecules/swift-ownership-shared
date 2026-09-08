public import Cardinal
public import Cardinal_Tagged
public import Cardinal
public import Ordinal_Protocol
public import Ordinal_Cardinal
public import Ordinal_Tagged
public import Ordinal
public import Index
public import Tagged
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
    public init(
        _ buffer:
            consuming Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear
    )
    where B == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear {
        self.init(box: Ownership.Box(buffer, drain: { $0.removeAll(keepingCapacity: true) }))
    }
}

extension Ownership.Shared where Element: Copyable, B: ~Copyable {

    @inlinable
    public init(
        _ buffer:
            consuming Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear
    )
    where B == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear {
        self.init(
            box: Ownership.Box(
                buffer,
                drain: { $0.removeAll(keepingCapacity: true) },
                clone: { $0.clone() }
            )
        )
    }
}

extension Ownership.Shared where Element: Copyable, B: ~Copyable {

    @inlinable
    public var isUnique: Bool {
        mutating get { box.isUnique }
    }
}

extension Ownership.Shared where Element: ~Copyable, B: ~Copyable {

    @inlinable
    @discardableResult
    public mutating func ensureUnique() -> Bool {

        box.ensureUnique()
    }
}

extension Ownership.Shared where Element: ~Copyable, B: ~Copyable {

    @inlinable
    public mutating func append(_ element: consuming Element)
    where
        B == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear,
        Element: Copyable
    {
        ensureUnique()
        unsafe box.unguarded.append(element)
    }

    @inlinable
    public mutating func appendAssumingUnique(_ element: consuming Element)
    where B == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear {
        assert(box.isUnique, "AssumingUnique on a shared box")
        unsafe box.unguarded.append(element)
    }

    @inlinable
    public mutating func removeLast()
        -> Element
    where
        B == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear,
        Element: Copyable
    {
        ensureUnique()
        return unsafe box.unguarded.removeLast()
    }

    @inlinable
    public mutating func removeLastAssumingUnique()
        -> Element
    where B == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear {
        assert(box.isUnique, "AssumingUnique on a shared box")
        return unsafe box.unguarded.removeLast()
    }

    @inlinable
    public mutating func reserveCapacity(_ minimumCapacity: Tagged<Element, Cardinal>)
    where
        B == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear,
        Element: Copyable
    {
        ensureUnique()
        unsafe box.unguarded.reserveCapacity(minimumCapacity)
    }

    @inlinable
    public mutating func reallocate(capacity newCapacity: Tagged<Element, Cardinal>)
    where
        B == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear,
        Element: Copyable
    {
        ensureUnique()
        unsafe box.unguarded.reallocate(capacity: newCapacity)
    }
}
