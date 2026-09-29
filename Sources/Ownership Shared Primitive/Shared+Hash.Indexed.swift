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
public import Hash_Indexed_Primitive
public import Hash_Table_Primitive
public import Memory_Allocator
public import Memory
public import Ownership
public import Storage

extension Ownership.Shared where Element: ~Copyable, B: ~Copyable {

    @inlinable
    public init<Resource: Memory.Growable & ~Copyable>(
        _ column:
            consuming Hash.Indexed<
                Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Linear
            >
    )
    where
        B == Hash.Indexed<
            Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Linear
        >, Element: Swift.Hashable & SendableMetatype
    {
        self.init(box: Ownership.Box(column, drain: { $0.removeAll(keepingCapacity: true) }))
    }
}

extension Ownership.Shared where Element: Copyable, B: ~Copyable {

    @inlinable
    public init<Resource: Memory.Growable & ~Copyable>(
        _ column:
            consuming Hash.Indexed<
                Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Linear
            >
    )
    where
        B == Hash.Indexed<
            Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<Element>>.Linear
        >, Element: Swift.Hashable & SendableMetatype
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
