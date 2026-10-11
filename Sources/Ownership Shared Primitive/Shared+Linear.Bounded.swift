import Cardinal
import Tagged
import Carrier
import Ordinal
import Property
import Index
import Memory_Small
public import Memory_Allocator_Protocol
public import Buffer
import Store
public import Buffer_Linear_Bounded_Primitive
public import Buffer_Linear_Primitive
public import Memory_Allocator
public import Memory
public import Ownership
public import Storage

extension Ownership.Shared where Element: ~Copyable, B: ~Copyable {

    @inlinable
    public init<Resource: Memory.Growable & SendableMetatype & ~Copyable>(
        _ buffer:
            consuming Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Linear
            .Bounded
    )
    where B == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Linear.Bounded {
        self.init(box: Ownership.Box(buffer, drain: { $0.remove.all() }))
    }
}

extension Ownership.Shared where Element: Copyable, B: ~Copyable {

    @inlinable
    public init<Resource: Memory.Growable & SendableMetatype & ~Copyable>(
        _ buffer:
            consuming Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Linear
            .Bounded
    )
    where B == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Linear.Bounded {
        self.init(
            box: Ownership.Box(
                buffer,
                drain: { $0.remove.all() },
                clone: { $0.clone() }
            )
        )
    }
}
