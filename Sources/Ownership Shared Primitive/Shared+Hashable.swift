public import Cardinal
public import Tagged
import Carrier
public import Ordinal
import Property
import Memory_Allocator_Protocol
import Buffer
import Store
import Affine
public import Index

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
