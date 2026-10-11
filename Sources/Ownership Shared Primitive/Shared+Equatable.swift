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
