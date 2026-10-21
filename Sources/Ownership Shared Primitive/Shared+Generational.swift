import Buffer
public import Cardinal
import Carrier
import Index
public import Memory
public import Memory_Allocator
public import Memory_Allocator_Pool
import Memory_Allocator_Protocol
import Memory_Small
import Ordinal
public import Ownership
import Property
public import Storage
public import Store
public import Tagged

extension Ownership.Shared where Element: ~Copyable, B: ~Copyable {

    @inlinable
    public init(
        _ store: consuming Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Element>
    )
    where B == Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Element> {
        self.init(box: Ownership.Box(store, drain: { $0.removeAll() }))
    }
}

extension Ownership.Shared where Element: Copyable, B: ~Copyable {

    @inlinable
    public init(
        _ store: consuming Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Element>
    )
    where B == Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Element> {
        self.init(
            box: Ownership.Box(
                store,
                drain: { $0.removeAll() },
                clone: { $0.clone() }
            )
        )
    }
}

extension Ownership.Shared where Element: ~Copyable, B: ~Copyable {

    @inlinable
    public mutating func insert(_ element: consuming Element) -> Store.Generational.Handle
    where B == Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Element> {
        ensureUnique()
        return unsafe box.unguarded.insert(element)
    }

    @inlinable
    public mutating func remove(_ handle: Store.Generational.Handle) -> Element?
    where B == Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Element> {
        ensureUnique()
        return unsafe box.unguarded.remove(handle)
    }

    @inlinable
    public subscript(_ handle: Store.Generational.Handle) -> Element
    where B == Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Element> {
        _read { yield unsafe box.unguarded[handle] }
        _modify {
            ensureUnique()
            yield unsafe &box.unguarded[handle]
        }
    }

    @inlinable
    public func contains(_ handle: Store.Generational.Handle) -> Bool
    where B == Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Element> {
        unsafe box.unguarded.contains(handle)
    }

    @inlinable
    public mutating func grow(to slotCapacity: Tagged<Element, Cardinal>)
    where B == Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Element> {
        ensureUnique()
        unsafe box.unguarded.grow(to: slotCapacity)
    }
}
