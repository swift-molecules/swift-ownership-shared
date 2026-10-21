public import Buffer
public import Buffer_Linear_Primitive
import Cardinal
import Carrier
public import Hash_Indexed_Primitive
public import Hash_Table_Primitive
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
        _ column:
            consuming Hash.Indexed<
                Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Linear
            >
    )
    where
        B == Hash.Indexed<
            Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Linear
        >,
        Element: Swift::Hashable & SendableMetatype
    {
        self.init(box: Ownership.Box(column, drain: { $0.removeAll(keepingCapacity: true) }))
    }
}

extension Ownership.Shared where Element: Copyable, B: ~Copyable {

    @inlinable
    public init<Resource: Memory.Growable & SendableMetatype & ~Copyable>(
        _ column:
            consuming Hash.Indexed<
                Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Linear
            >
    )
    where
        B == Hash.Indexed<
            Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Linear
        >,
        Element: Swift::Hashable & SendableMetatype
    {
        self.init(
            box: Ownership.Box(
                column,
                drain: { $0.removeAll(keepingCapacity: true) },
                clone: { $0.clone() }
            )
        )
    }
}
