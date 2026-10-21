public import Buffer
public import Buffer_Ring_Bounded_Primitive
public import Buffer_Ring_Primitive
import Cardinal
import Carrier
import Index
public import Memory
public import Memory_Allocator
public import Memory_Allocator_Protocol
import Memory_Small
import Ordinal
public import Ownership
import Property
public import Storage
import Store
import Tagged

extension Ownership.Shared where Element: ~Copyable, B: ~Copyable {

    @inlinable
    public init<Resource: Memory.Growable & SendableMetatype & ~Copyable>(
        _ buffer: consuming Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring
    )
    where B == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring {
        self.init(box: Ownership.Box(buffer, drain: { $0.removeAll() }))
    }

    @inlinable
    public init<Resource: Memory.Growable & SendableMetatype & ~Copyable>(
        _ buffer:
            consuming Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring
            .Bounded
    )
    where B == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring.Bounded {
        self.init(box: Ownership.Box(buffer, drain: { $0.remove.all() }))
    }
}

extension Ownership.Shared where Element: Copyable, B: ~Copyable {

    @inlinable
    public init<Resource: Memory.Growable & SendableMetatype & ~Copyable>(
        _ buffer: consuming Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring
    )
    where B == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring {
        self.init(
            box: Ownership.Box(
                buffer,
                drain: { $0.removeAll() },
                clone: { $0.clone() }
            )
        )
    }

    @inlinable
    public init<Resource: Memory.Growable & SendableMetatype & ~Copyable>(
        _ buffer:
            consuming Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring
            .Bounded
    )
    where B == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Ring.Bounded {
        self.init(
            box: Ownership.Box(
                buffer,
                drain: { $0.remove.all() },
                clone: { $0.clone() }
            )
        )
    }
}
