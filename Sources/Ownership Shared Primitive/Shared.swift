import Cardinal
import Tagged
import Carrier
import Ordinal
import Property
import Index
import Memory_Allocator_Protocol
public import Store
public import Buffer
public import Ownership

extension Ownership {

    @frozen
    public struct Shared<
        Element: ~Copyable,
        B: Store.`Protocol` & Buffer.`Protocol` & ~Copyable
    >: ~Copyable where B.Element == Element {

        @usableFromInline
        internal var box: Ownership.Box<B>

        @usableFromInline
        internal init(box: consuming Ownership.Box<B>) {
            self.box = box
        }
    }
}

extension Ownership.Shared where Element: ~Copyable, B: ~Copyable {
    @usableFromInline
    package var _boxID: ObjectIdentifier { box.identity }
}

extension Ownership.Shared: Copyable where Element: Copyable, B: ~Copyable {}

extension Ownership.Shared: Sendable where Element: ~Copyable, B: Sendable & ~Copyable {}
