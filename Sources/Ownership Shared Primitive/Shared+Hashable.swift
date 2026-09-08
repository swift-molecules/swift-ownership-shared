public import Cardinal
public import Cardinal_Tagged
public import Cardinal
public import Ordinal_Protocol
public import Ordinal_Cardinal
public import Ordinal_Tagged
public import Ordinal
public import Tagged
public import Memory_Allocator_Protocol
public import Buffer
public import Store
import Affine
public import Index
import Ordinal

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
