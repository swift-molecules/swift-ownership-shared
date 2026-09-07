public import Cardinal_Standard_Library_Integration
public import Cardinal_Carrier
public import Ordinal_Protocol
public import Ordinal_Cardinal
public import Memory_Allocator_Protocol
public import Cardinal
public import Cardinal_Tagged
public import Ordinal
public import Ordinal_Tagged
public import Tagged
public import Store
public import Buffer
public import Index
public import Ownership

extension Ownership.Shared: Store.`Protocol` where Element: ~Copyable, B: ~Copyable {

    @inlinable
    public var capacity: Tagged<Element, Cardinal> { box.unguarded.capacity }

    @inlinable
    public subscript(slot: Index<Element>) -> Element {
        _read { yield box.unguarded[slot] }
        _modify {
            ensureUnique()
            yield &box.unguarded[slot]
        }
    }

    @inlinable
    public mutating func initialize(at slot: Index<Element>, to element: consuming Element) {
        ensureUnique()
        box.unguarded.initialize(at: slot, to: element)
    }

    @inlinable
    public mutating func move(at slot: Index<Element>) -> Element {
        ensureUnique()
        return box.unguarded.move(at: slot)
    }

    @inlinable
    public mutating func swapAt(_ i: Index<Element>, _ j: Index<Element>) {
        ensureUnique()
        box.unguarded.swapAt(i, j)
    }

    @inlinable
    public mutating func unshare() {
        ensureUnique()
    }
}

extension Ownership.Shared: Buffer.`Protocol` where Element: ~Copyable, B: ~Copyable {

    @inlinable
    public var count: Tagged<Element, Cardinal> { box.unguarded.count }
}
