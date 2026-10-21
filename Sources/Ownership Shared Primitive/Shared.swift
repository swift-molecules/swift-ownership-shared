public import Buffer
import Cardinal
import Carrier
import Index
import Memory_Allocator_Protocol
import Ordinal
public import Ownership
import Property
public import Store
import Tagged

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
