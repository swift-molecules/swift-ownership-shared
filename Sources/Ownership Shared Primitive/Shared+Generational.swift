public import Memory_Allocator_Pool
public import Cardinal_Standard_Library_Integration
public import Cardinal_Carrier
public import Cardinal_Tagged
public import Cardinal
public import Ordinal_Protocol
public import Ordinal_Cardinal
public import Ordinal_Tagged
public import Ordinal
public import Tagged
public import Memory_Small
public import Memory_Allocator_Protocol
public import Buffer_Protocol
public import Store_Protocol
public import Index
public import Memory_Allocator
public import Memory
public import Ownership_Box
public import Storage_Generational
public import Storage
public import Store

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
        return box.unguarded.insert(element)
    }

    @inlinable
    public mutating func remove(_ handle: Store.Generational.Handle) -> Element?
    where B == Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Element> {
        ensureUnique()
        return box.unguarded.remove(handle)
    }

    @inlinable
    public subscript(_ handle: Store.Generational.Handle) -> Element
    where B == Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Element> {
        _read { yield box.unguarded[handle] }
        _modify {
            ensureUnique()
            yield &box.unguarded[handle]
        }
    }

    @inlinable
    public func contains(_ handle: Store.Generational.Handle) -> Bool
    where B == Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Element> {
        box.unguarded.contains(handle)
    }

    @inlinable
    public mutating func grow(to slotCapacity: Tagged<Element, Cardinal>)
    where B == Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Element> {
        ensureUnique()
        box.unguarded.grow(to: slotCapacity)
    }
}
