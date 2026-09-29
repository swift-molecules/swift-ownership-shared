public import Cardinal
public import Tagged
public import Carrier
public import Ordinal
public import Property
public import Memory_Allocator_Protocol
public import Buffer
public import Store
import Affine
public import Index
import Ordinal

extension Ownership.Shared: Equatable where Element: Equatable, B: ~Copyable {

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.count == rhs.count else { return false }
        var slot: Index<Element> = .zero
        let end = lhs.count.map(Ordinal.init)
        while slot < end {
            guard lhs[slot] == rhs[slot] else { return false }
            slot += .one
        }
        return true
    }
}
