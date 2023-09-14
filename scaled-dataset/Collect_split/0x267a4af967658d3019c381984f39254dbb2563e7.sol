// SPDX-License-Identifier: MIT



pragma solidity 0.8.14;



abstract contract Context {

    function _msgSender() internal view virtual returns (address) {

        return msg.sender;

    }



    function _msgData() internal view virtual returns (bytes calldata) {

        this;

        // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}



// File: @openzeppelin/contracts/introspection/IERC165.sol



interface IERC165 {



    function supportsInterface(bytes4 interfaceId) external view returns (bool);

}



// File: @openzeppelin/contracts/token/ERC721/IERC721.sol



interface IERC721 is IERC165 {



    event Transfer(

        address indexed from,

        address indexed to,

        uint256 indexed tokenId

    );



    event Approval(

        address indexed owner,

        address indexed approved,

        uint256 indexed tokenId

    );



    event ApprovalForAll(

        address indexed owner,

        address indexed operator,

        bool approved

    );



    function balanceOf(address owner) external view returns (uint256 balance);



    function ownerOf(uint256 tokenId) external view returns (address owner);



    function safeTransferFrom(

        address from,

        address to,

        uint256 tokenId

    ) external;



    function transferFrom(

        address from,

        address to,

        uint256 tokenId

    ) external;



    function approve(address to, uint256 tokenId) external;



    function getApproved(uint256 tokenId)

        external

        view

        returns (address operator);



    function setApprovalForAll(address operator, bool _approved) external;



    function isApprovedForAll(address owner, address operator)

        external

        view

        returns (bool);



    function safeTransferFrom(

        address from,

        address to,

        uint256 tokenId,

        bytes calldata data

    ) external;

}



// File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol



interface IERC721Metadata is IERC721 {



    function name() external view returns (string memory);





    function symbol() external view returns (string memory);





    function tokenURI(uint256 tokenId) external view returns (string memory);

}



// File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol



interface IERC721Enumerable is IERC721 {



    function totalSupply() external view returns (uint256);



    function tokenOfOwnerByIndex(address owner, uint256 index)

        external

        view

        returns (uint256 tokenId);



    function tokenByIndex(uint256 index) external view returns (uint256);

}



// File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol



interface IERC721Receiver {



    function onERC721Received(

        address operator,

        address from,

        uint256 tokenId,

        bytes calldata data

    ) external returns (bytes4);

}



// File: @openzeppelin/contracts/introspection/ERC165.sol



abstract contract ERC165 is IERC165 {



    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;



    mapping(bytes4 => bool) private _supportedInterfaces;



    constructor() {

        // Derived contracts need only register support for their own interfaces,

        // we register support for ERC165 itself here

        _registerInterface(_INTERFACE_ID_ERC165);

    }



    function supportsInterface(bytes4 interfaceId)

        public

        view

        virtual

        override

        returns (bool)

    {

        return _supportedInterfaces[interfaceId];

    }



    function _registerInterface(bytes4 interfaceId) internal virtual {

        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");

        _supportedInterfaces[interfaceId] = true;

    }

}



// File: @openzeppelin/contracts/math/SafeMath.sol



library SafeMath {



    function tryAdd(uint256 a, uint256 b)

        internal

        pure

        returns (bool, uint256)

    {

        uint256 c = a + b;

        if (c < a) return (false, 0);

        return (true, c);

    }



    function trySub(uint256 a, uint256 b)

        internal

        pure

        returns (bool, uint256)

    {

        if (b > a) return (false, 0);

        return (true, a - b);

    }



    function tryMul(uint256 a, uint256 b)

        internal

        pure

        returns (bool, uint256)

    {



        if (a == 0) return (true, 0);

        uint256 c = a * b;

        if (c / a != b) return (false, 0);

        return (true, c);

    }



    function tryDiv(uint256 a, uint256 b)

        internal

        pure

        returns (bool, uint256)

    {

        if (b == 0) return (false, 0);

        return (true, a / b);

    }



    function tryMod(uint256 a, uint256 b)

        internal

        pure

        returns (bool, uint256)

    {

        if (b == 0) return (false, 0);

        return (true, a % b);

    }



    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "SafeMath: addition overflow");

        return c;

    }



    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b <= a, "SafeMath: subtraction overflow");

        return a - b;

    }



    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        if (a == 0) return 0;

        uint256 c = a * b;

        require(c / a == b, "SafeMath: multiplication overflow");

        return c;

    }



    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b > 0, "SafeMath: division by zero");

        return a / b;

    }



    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b > 0, "SafeMath: modulo by zero");

        return a % b;

    }



    function sub(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

        require(b <= a, errorMessage);

        return a - b;

    }



    function div(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

        require(b > 0, errorMessage);

        return a / b;

    }



    function mod(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

        require(b > 0, errorMessage);

        return a % b;

    }

}



// File: @openzeppelin/contracts/utils/Address.sol



library Address {



    function isContract(address account) internal view returns (bool) {



        uint256 size;

        // solhint-disable-next-line no-inline-assembly

        assembly {

            size := extcodesize(account)

        }

        return size > 0;

    }



    function sendValue(address payable recipient, uint256 amount) internal {

        require(

            address(this).balance >= amount,

            "Address: insufficient balance"

        );



        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value

        (bool success, ) = recipient.call{value: amount}("");

        require(

            success,

            "Address: unable to send value, recipient may have reverted"

        );

    }



    function functionCall(address target, bytes memory data)

        internal

        returns (bytes memory)

    {

        return functionCall(target, data, "Address: low-level call failed");

    }



    function functionCall(

        address target,

        bytes memory data,

        string memory errorMessage

    ) internal returns (bytes memory) {

        return functionCallWithValue(target, data, 0, errorMessage);

    }



    function functionCallWithValue(

        address target,

        bytes memory data,

        uint256 value

    ) internal returns (bytes memory) {

        return

            functionCallWithValue(

                target,

                data,

                value,

                "Address: low-level call with value failed"

            );

    }



    function functionCallWithValue(

        address target,

        bytes memory data,

        uint256 value,

        string memory errorMessage

    ) internal returns (bytes memory) {

        require(

            address(this).balance >= value,

            "Address: insufficient balance for call"

        );

        require(isContract(target), "Address: call to non-contract");



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = target.call{value: value}(

            data

        );

        return _verifyCallResult(success, returndata, errorMessage);

    }



    function functionStaticCall(address target, bytes memory data)

        internal

        view

        returns (bytes memory)

    {

        return

            functionStaticCall(

                target,

                data,

                "Address: low-level static call failed"

            );

    }



    function functionStaticCall(

        address target,

        bytes memory data,

        string memory errorMessage

    ) internal view returns (bytes memory) {

        require(isContract(target), "Address: static call to non-contract");



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = target.staticcall(data);

        return _verifyCallResult(success, returndata, errorMessage);

    }



    function functionDelegateCall(address target, bytes memory data)

        internal

        returns (bytes memory)

    {

        return

            functionDelegateCall(

                target,

                data,

                "Address: low-level delegate call failed"

            );

    }



    function functionDelegateCall(

        address target,

        bytes memory data,

        string memory errorMessage

    ) internal returns (bytes memory) {

        require(isContract(target), "Address: delegate call to non-contract");



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = target.delegatecall(data);

        return _verifyCallResult(success, returndata, errorMessage);

    }



    function _verifyCallResult(

        bool success,

        bytes memory returndata,

        string memory errorMessage

    ) private pure returns (bytes memory) {

        if (success) {

            return returndata;

        } else {

            // Look for revert reason and bubble it up if present

            if (returndata.length > 0) {

                // The easiest way to bubble the revert reason is using memory via assembly



                // solhint-disable-next-line no-inline-assembly

                assembly {

                    let returndata_size := mload(returndata)

                    revert(add(32, returndata), returndata_size)

                }

            } else {

                revert(errorMessage);

            }

        }

    }

}



// File: @openzeppelin/contracts/utils/EnumerableSet.sol



library EnumerableSet {





    struct Set {

        // Storage of set values

        bytes32[] _values;

        mapping(bytes32 => uint256) _indexes;

    }



    function _add(Set storage set, bytes32 value) private returns (bool) {

        if (!_contains(set, value)) {

            set._values.push(value);

            set._indexes[value] = set._values.length;

            return true;

        } else {

            return false;

        }

    }



    function _remove(Set storage set, bytes32 value) private returns (bool) {

        // We read and store the value's index to prevent multiple reads from the same storage slot

        uint256 valueIndex = set._indexes[value];



        if (valueIndex != 0) {





            uint256 toDeleteIndex = valueIndex - 1;

            uint256 lastIndex = set._values.length - 1;





            bytes32 lastvalue = set._values[lastIndex];



            // Move the last value to the index where the value to delete is

            set._values[toDeleteIndex] = lastvalue;

            // Update the index for the moved value

            set._indexes[lastvalue] = toDeleteIndex + 1;



            set._values.pop();



            // Delete the index for the deleted slot

            delete set._indexes[value];



            return true;

        } else {

            return false;

        }

    }



    function _contains(Set storage set, bytes32 value)

        private

        view

        returns (bool)

    {

        return set._indexes[value] != 0;

    }



    function _length(Set storage set) private view returns (uint256) {

        return set._values.length;

    }



    function _at(Set storage set, uint256 index)

        private

        view

        returns (bytes32)

    {

        require(

            set._values.length > index,

            "EnumerableSet: index out of bounds"

        );

        return set._values[index];

    }



    // Bytes32Set



    struct Bytes32Set {

        Set _inner;

    }



    function add(Bytes32Set storage set, bytes32 value)

        internal

        returns (bool)

    {

        return _add(set._inner, value);

    }



    function remove(Bytes32Set storage set, bytes32 value)

        internal

        returns (bool)

    {

        return _remove(set._inner, value);

    }



    function contains(Bytes32Set storage set, bytes32 value)

        internal

        view

        returns (bool)

    {

        return _contains(set._inner, value);

    }



    function length(Bytes32Set storage set) internal view returns (uint256) {

        return _length(set._inner);

    }



    function at(Bytes32Set storage set, uint256 index)

        internal

        view

        returns (bytes32)

    {

        return _at(set._inner, index);

    }



    // AddressSet



    struct AddressSet {

        Set _inner;

    }



    function add(AddressSet storage set, address value)

        internal

        returns (bool)

    {

        return _add(set._inner, bytes32(uint256(uint160(value))));

    }



    function remove(AddressSet storage set, address value)

        internal

        returns (bool)

    {

        return _remove(set._inner, bytes32(uint256(uint160(value))));

    }



    function contains(AddressSet storage set, address value)

        internal

        view

        returns (bool)

    {

        return _contains(set._inner, bytes32(uint256(uint160(value))));

    }



    function length(AddressSet storage set) internal view returns (uint256) {

        return _length(set._inner);

    }



    function at(AddressSet storage set, uint256 index)

        internal

        view

        returns (address)

    {

        return address(uint160(uint256(_at(set._inner, index))));

    }



    // UintSet



    struct UintSet {

        Set _inner;

    }



    function add(UintSet storage set, uint256 value) internal returns (bool) {

        return _add(set._inner, bytes32(value));

    }



    function remove(UintSet storage set, uint256 value)

        internal

        returns (bool)

    {

        return _remove(set._inner, bytes32(value));

    }



    function contains(UintSet storage set, uint256 value)

        internal

        view

        returns (bool)

    {

        return _contains(set._inner, bytes32(value));

    }



    function length(UintSet storage set) internal view returns (uint256) {

        return _length(set._inner);

    }



    function at(UintSet storage set, uint256 index)

        internal

        view

        returns (uint256)

    {

        return uint256(_at(set._inner, index));

    }

}



// File: @openzeppelin/contracts/utils/EnumerableMap.sol



library EnumerableMap {





    struct MapEntry {

        bytes32 _key;

        bytes32 _value;

    }



    struct Map {

        // Storage of map keys and values

        MapEntry[] _entries;



        mapping(bytes32 => uint256) _indexes;

    }



    function _set(

        Map storage map,

        bytes32 key,

        bytes32 value

    ) private returns (bool) {

        // We read and store the key's index to prevent multiple reads from the same storage slot

        uint256 keyIndex = map._indexes[key];



        if (keyIndex == 0) {

            // Equivalent to !contains(map, key)

            map._entries.push(MapEntry({_key: key, _value: value}));



            map._indexes[key] = map._entries.length;

            return true;

        } else {

            map._entries[keyIndex - 1]._value = value;

            return false;

        }

    }



    function _remove(Map storage map, bytes32 key) private returns (bool) {

        // We read and store the key's index to prevent multiple reads from the same storage slot

        uint256 keyIndex = map._indexes[key];



        if (keyIndex != 0) {



            uint256 toDeleteIndex = keyIndex - 1;

            uint256 lastIndex = map._entries.length - 1;



            MapEntry storage lastEntry = map._entries[lastIndex];



            // Move the last entry to the index where the entry to delete is

            map._entries[toDeleteIndex] = lastEntry;

            // Update the index for the moved entry

            map._indexes[lastEntry._key] = toDeleteIndex + 1;

            // All indexes are 1-based



            // Delete the slot where the moved entry was stored

            map._entries.pop();



            // Delete the index for the deleted slot

            delete map._indexes[key];



            return true;

        } else {

            return false;

        }

    }



    function _contains(Map storage map, bytes32 key)

        private

        view

        returns (bool)

    {

        return map._indexes[key] != 0;

    }



    function _length(Map storage map) private view returns (uint256) {

        return map._entries.length;

    }



    function _at(Map storage map, uint256 index)

        private

        view

        returns (bytes32, bytes32)

    {

        require(

            map._entries.length > index,

            "EnumerableMap: index out of bounds"

        );



        MapEntry storage entry = map._entries[index];

        return (entry._key, entry._value);

    }



    function _tryGet(Map storage map, bytes32 key)

        private

        view

        returns (bool, bytes32)

    {

        uint256 keyIndex = map._indexes[key];

        if (keyIndex == 0) return (false, 0);

        // Equivalent to contains(map, key)

        return (true, map._entries[keyIndex - 1]._value);

        // All indexes are 1-based

    }



    function _get(Map storage map, bytes32 key) private view returns (bytes32) {

        uint256 keyIndex = map._indexes[key];

        require(keyIndex != 0, "EnumerableMap: nonexistent key");

        // Equivalent to contains(map, key)

        return map._entries[keyIndex - 1]._value;

        // All indexes are 1-based

    }



    function _get(

        Map storage map,

        bytes32 key,

        string memory errorMessage

    ) private view returns (bytes32) {

        uint256 keyIndex = map._indexes[key];

        require(keyIndex != 0, errorMessage);

        // Equivalent to contains(map, key)

        return map._entries[keyIndex - 1]._value;

        // All indexes are 1-based

    }



    // UintToAddressMap



    struct UintToAddressMap {

        Map _inner;

    }



    function set(

        UintToAddressMap storage map,

        uint256 key,

        address value

    ) internal returns (bool) {

        return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));

    }



    function remove(UintToAddressMap storage map, uint256 key)

        internal

        returns (bool)

    {

        return _remove(map._inner, bytes32(key));

    }



    function contains(UintToAddressMap storage map, uint256 key)

        internal

        view

        returns (bool)

    {

        return _contains(map._inner, bytes32(key));

    }



    function length(UintToAddressMap storage map)

        internal

        view

        returns (uint256)

    {

        return _length(map._inner);

    }



    function at(UintToAddressMap storage map, uint256 index)

        internal

        view

        returns (uint256, address)

    {

        (bytes32 key, bytes32 value) = _at(map._inner, index);

        return (uint256(key), address(uint160(uint256(value))));

    }



    function tryGet(UintToAddressMap storage map, uint256 key)

        internal

        view

        returns (bool, address)

    {

        (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));

        return (success, address(uint160(uint256(value))));

    }



    function get(UintToAddressMap storage map, uint256 key)

        internal

        view

        returns (address)

    {

        return address(uint160(uint256(_get(map._inner, bytes32(key)))));

    }



    function get(

        UintToAddressMap storage map,

        uint256 key,

        string memory errorMessage

    ) internal view returns (address) {

        return

            address(

                uint160(uint256(_get(map._inner, bytes32(key), errorMessage)))

            );

    }

}



// File: @openzeppelin/contracts/utils/Strings.sol



library Strings {

    /**

     * @dev Converts a `uint256` to its ASCII `string` representation.

     */

    function toString(uint256 value) internal pure returns (string memory) {



        if (value == 0) {

            return "0";

        }

        uint256 temp = value;

        uint256 digits;

        while (temp != 0) {

            digits++;

            temp /= 10;

        }

        bytes memory buffer = new bytes(digits);

        while (value != 0) {

            digits -= 1;

            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));

            value /= 10;

        }

        return string(buffer);

    }

}



// File: @openzeppelin/contracts/token/ERC721/ERC721.sol



contract ERC721 is

    Context,

    ERC165,

    IERC721,

    IERC721Metadata,

    IERC721Enumerable

{

    using SafeMath for uint256;

    using Address for address;

    using EnumerableSet for EnumerableSet.UintSet;

    using EnumerableMap for EnumerableMap.UintToAddressMap;

    using Strings for uint256;



    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;



    // Mapping from holder address to their (enumerable) set of owned tokens

    mapping(address => EnumerableSet.UintSet) private _holderTokens;



    // Enumerable mapping from token ids to their owners

    EnumerableMap.UintToAddressMap private _tokenOwners;



    // Mapping from token ID to approved address

    mapping(uint256 => address) private _tokenApprovals;



    // Mapping from owner to operator approvals

    mapping(address => mapping(address => bool)) private _operatorApprovals;



    // Token name

    string private _name;



    // Token symbol

    string private _symbol;



    // Optional mapping for token URIs

    mapping(uint256 => string) private _tokenURIs;



    // Base URI

    string private _baseURI;



    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;



    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;



    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;



    constructor(string memory name_, string memory symbol_) {

        _name = name_;

        _symbol = symbol_;



        // register the supported interfaces to conform to ERC721 via ERC165

        _registerInterface(_INTERFACE_ID_ERC721);

        _registerInterface(_INTERFACE_ID_ERC721_METADATA);

        _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);

    }



    function balanceOf(address owner)

        public

        view

        virtual

        override

        returns (uint256)

    {

        require(

            owner != address(0),

            "ERC721: balance query for the zero address"

        );

        return _holderTokens[owner].length();

    }



    function ownerOf(uint256 tokenId)

        public

        view

        virtual

        override

        returns (address)

    {

        return

            _tokenOwners.get(

                tokenId,

                "ERC721: owner query for nonexistent token"

            );

    }



    function name() public view virtual override returns (string memory) {

        return _name;

    }



    function symbol() public view virtual override returns (string memory) {

        return _symbol;

    }



    function tokenURI(uint256 tokenId)

        public

        view

        virtual

        override

        returns (string memory)

    {

        require(

            _exists(tokenId),

            "ERC721Metadata: URI query for nonexistent token"

        );



        string memory _tokenURI = _tokenURIs[tokenId];

        string memory base = baseURI();



        // If there is no base URI, return the token URI.

        if (bytes(base).length == 0) {

            return _tokenURI;

        }

        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).

        if (bytes(_tokenURI).length > 0) {

            return string(abi.encodePacked(base, _tokenURI));

        }

        // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.

        return string(abi.encodePacked(base, tokenId.toString()));

    }



    function baseURI() public view virtual returns (string memory) {

        return _baseURI;

    }



    function tokenOfOwnerByIndex(address owner, uint256 index)

        public

        view

        virtual

        override

        returns (uint256)

    {

        return _holderTokens[owner].at(index);

    }



    function totalSupply() public view virtual override returns (uint256) {

        // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds

        return _tokenOwners.length();

    }



    function tokenByIndex(uint256 index)

        public

        view

        virtual

        override

        returns (uint256)

    {

        (uint256 tokenId, ) = _tokenOwners.at(index);

        return tokenId;

    }



    function approve(address to, uint256 tokenId) public virtual override {

        address owner = ERC721.ownerOf(tokenId);

        require(to != owner, "ERC721: approval to current owner");



        require(

            _msgSender() == owner ||

                ERC721.isApprovedForAll(owner, _msgSender()),

            "ERC721: approve caller is not owner nor approved for all"

        );



        _approve(to, tokenId);

    }



    function getApproved(uint256 tokenId)

        public

        view

        virtual

        override

        returns (address)

    {

        require(

            _exists(tokenId),

            "ERC721: approved query for nonexistent token"

        );



        return _tokenApprovals[tokenId];

    }



    function setApprovalForAll(address operator, bool approved)

        public

        virtual

        override

    {

        require(operator != _msgSender(), "ERC721: approve to caller");



        _operatorApprovals[_msgSender()][operator] = approved;

        emit ApprovalForAll(_msgSender(), operator, approved);

    }



    function isApprovedForAll(address owner, address operator)

        public

        view

        virtual

        override

        returns (bool)

    {

        return _operatorApprovals[owner][operator];

    }



    function transferFrom(

        address from,

        address to,

        uint256 tokenId

    ) public virtual override {

        //solhint-disable-next-line max-line-length

        require(

            _isApprovedOrOwner(_msgSender(), tokenId),

            "ERC721: transfer caller is not owner nor approved"

        );



        _transfer(from, to, tokenId);

    }



    function safeTransferFrom(

        address from,

        address to,

        uint256 tokenId

    ) public virtual override {

        safeTransferFrom(from, to, tokenId, "");

    }



    function safeTransferFrom(

        address from,

        address to,

        uint256 tokenId,

        bytes memory _data

    ) public virtual override {

        require(

            _isApprovedOrOwner(_msgSender(), tokenId),

            "ERC721: transfer caller is not owner nor approved"

        );

        _safeTransfer(from, to, tokenId, _data);

    }



    function _safeTransfer(

        address from,

        address to,

        uint256 tokenId,

        bytes memory _data

    ) internal virtual {

        _transfer(from, to, tokenId);

        require(

            _checkOnERC721Received(from, to, tokenId, _data),

            "ERC721: transfer to non ERC721Receiver implementer"

        );

    }



    function _exists(uint256 tokenId) internal view virtual returns (bool) {

        return _tokenOwners.contains(tokenId);

    }



    function _isApprovedOrOwner(address spender, uint256 tokenId)

        internal

        view

        virtual

        returns (bool)

    {

        require(

            _exists(tokenId),

            "ERC721: operator query for nonexistent token"

        );

        address owner = ERC721.ownerOf(tokenId);

        return (spender == owner ||

            getApproved(tokenId) == spender ||

            ERC721.isApprovedForAll(owner, spender));

    }



    function _safeMint(address to, uint256 tokenId) internal virtual {

        _safeMint(to, tokenId, "");

    }



    function _safeMint(

        address to,

        uint256 tokenId,

        bytes memory _data

    ) internal virtual {

        _mint(to, tokenId);

        require(

            _checkOnERC721Received(address(0), to, tokenId, _data),

            "ERC721: transfer to non ERC721Receiver implementer"

        );

    }



    function _mint(address to, uint256 tokenId) internal virtual {

        require(to != address(0), "ERC721: mint to the zero address");

        require(!_exists(tokenId), "ERC721: token already minted");



        _beforeTokenTransfer(address(0), to, tokenId);



        _holderTokens[to].add(tokenId);



        _tokenOwners.set(tokenId, to);



        emit Transfer(address(0), to, tokenId);

    }



    function _burn(uint256 tokenId) internal virtual {

        address owner = ERC721.ownerOf(tokenId);

        // internal owner



        _beforeTokenTransfer(owner, address(0), tokenId);



        // Clear approvals

        _approve(address(0), tokenId);



        // Clear metadata (if any)

        if (bytes(_tokenURIs[tokenId]).length != 0) {

            delete _tokenURIs[tokenId];

        }



        _holderTokens[owner].remove(tokenId);



        _tokenOwners.remove(tokenId);



        emit Transfer(owner, address(0), tokenId);

    }



    function _transfer(

        address from,

        address to,

        uint256 tokenId

    ) internal virtual {

        require(

            ERC721.ownerOf(tokenId) == from,

            "ERC721: transfer of token that is not own"

        );

        // internal owner

        require(to != address(0), "ERC721: transfer to the zero address");



        _beforeTokenTransfer(from, to, tokenId);



        // Clear approvals from the previous owner

        _approve(address(0), tokenId);



        _holderTokens[from].remove(tokenId);

        _holderTokens[to].add(tokenId);



        _tokenOwners.set(tokenId, to);



        emit Transfer(from, to, tokenId);

    }



    function _setTokenURI(uint256 tokenId, string memory _tokenURI)

        internal

        virtual

    {

        require(

            _exists(tokenId),

            "ERC721Metadata: URI set of nonexistent token"

        );

        _tokenURIs[tokenId] = _tokenURI;

    }



    function _setBaseURI(string memory baseURI_) internal virtual {

        _baseURI = baseURI_;

    }



    function _checkOnERC721Received(

        address from,

        address to,

        uint256 tokenId,

        bytes memory _data

    ) private returns (bool) {

        if (!to.isContract()) {

            return true;

        }

        bytes memory returndata = to.functionCall(

            abi.encodeWithSelector(

                IERC721Receiver(to).onERC721Received.selector,

                _msgSender(),

                from,

                tokenId,

                _data

            ),

            "ERC721: transfer to non ERC721Receiver implementer"

        );

        bytes4 retval = abi.decode(returndata, (bytes4));

        return (retval == _ERC721_RECEIVED);

    }



    function _approve(address to, uint256 tokenId) internal virtual {

        _tokenApprovals[tokenId] = to;

        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);

        // internal owner

    }



    function _beforeTokenTransfer(

        address from,

        address to,

        uint256 tokenId

    ) internal virtual {}

}



// File: @openzeppelin/contracts/access/Ownable.sol



abstract contract Ownable is Context {

    address private _owner;



    event OwnershipTransferred(

        address indexed previousOwner,

        address indexed newOwner

    );



    constructor() {

        address msgSender = _msgSender();

        _owner = msgSender;

        emit OwnershipTransferred(address(0), msgSender);

    }



    function owner() public view virtual returns (address) {

        return _owner;

    }



    modifier onlyOwner() {

        require(owner() == _msgSender(), "Ownable: caller is not the owner");

        _;

    }



    function renounceOwnership() public virtual onlyOwner {

        emit OwnershipTransferred(_owner, address(0));

        _owner = address(0);

    }



    function transferOwnership(address newOwner) public virtual onlyOwner {

        require(

            newOwner != address(0),

            "Ownable: new owner is the zero address"

        );

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

    }

}



// File: contracts/TheLostKids.sol



contract TheLostKids is ERC721, Ownable {

    using SafeMath for uint256;

    using Strings for uint256;



    uint256 public startingIndexBlock;

    uint256 public startingIndex;

    uint256 public privateMintPrice = 0 ether;

    uint256 public publicMintPrice = 1 ether;

    uint256 public MAX_MINT_WHITELIST = 2;

    uint256 public MAX_ELEMENTS = 200;

    uint256 public REVEAL_TIMESTAMP;



    bool public revealed = false;



    string public notRevealedUri = "";



    string public PROVENANCE_HASH = "";

    bool public saleIsActive = false;

    bool public privateSaleIsActive = true;



    struct Whitelist {

        address addr;

        uint256 claimAmount;

        uint256 hasMinted;

    }



    mapping(address => Whitelist) public whitelist;

    mapping(address => Whitelist) public winnerlist;



    address[] whitelistAddr;

    address[] winnerlistAddr;



    constructor(

        string memory _name,

        string memory _symbol,

        string memory _initBaseURI,

        string memory _initNotRevealedUri

    ) ERC721(_name, _symbol) {

        REVEAL_TIMESTAMP = block.timestamp;

        _setBaseURI(_initBaseURI);

        setNotRevealedURI(_initNotRevealedUri);

    }



    function tokensOfOwner(address _owner)

        external

        view

        returns (uint256[] memory)

    {

        uint256 tokenCount = balanceOf(_owner);

        if (tokenCount == 0) {

            return new uint256[](0);

        } else {

            uint256[] memory result = new uint256[](tokenCount);

            for (uint256 index; index < tokenCount; index++) {

                result[index] = tokenOfOwnerByIndex(_owner, index);

            }

            return result;

        }

    }



    function exists(uint256 _tokenId) public view returns (bool) {

        return _exists(_tokenId);

    }



    function setPublicMintPrice(uint256 _price) external onlyOwner {

        publicMintPrice = _price;

    }



    function reserve(uint256 _count) public onlyOwner {

        uint256 total = totalSupply();

        require(total + _count <= MAX_ELEMENTS, "Exceeded");

        for (uint256 i = 0; i < _count; i++) {

            _safeMint(msg.sender, total + i);

        }

    }



    function setRevealTimestamp(uint256 _revealTimeStamp) external onlyOwner {

        REVEAL_TIMESTAMP = _revealTimeStamp;

    }



    function setProvenanceHash(string memory _provenanceHash)

        external

        onlyOwner

    {

        PROVENANCE_HASH = _provenanceHash;

    }



    function setBaseURI(string memory baseURI) external onlyOwner {

        _setBaseURI(baseURI);

    }



    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {

        notRevealedUri = _notRevealedURI;

    }



    //only owner

    function reveal() public onlyOwner {

        revealed = true;

    }



    function tokenURI(uint256 tokenId)

        public

        view

        virtual

        override

        returns (string memory)

    {

        require(

            _exists(tokenId),

            "ERC721Metadata: URI query for nonexistent token"

        );

        require(tokenId <= totalSupply(), "URI query for nonexistent token");

        if (revealed == false) {

            return notRevealedUri;

        }

        string memory base = baseURI();

        return string(abi.encodePacked(base, "/", tokenId.toString(), ".json"));

    }



    function flipSaleState() public onlyOwner {

        saleIsActive = !saleIsActive;

    }



    function flipPrivateSaleState() public onlyOwner {

        privateSaleIsActive = !privateSaleIsActive;

    }



    function mint(uint256 _count) public payable {

        uint256 total = totalSupply();

        require(saleIsActive, "Sale must be active to mint");

        require((total + _count) <= MAX_ELEMENTS, "Max limit");



        if (privateSaleIsActive) {

            require(

                (privateMintPrice * _count) <= msg.value,

                "Value below price"

            );

            require(_count <= MAX_MINT_WHITELIST, "Minting too Many");

            require(isWhitelisted(msg.sender), "Is not whitelisted");

            require(

                whitelist[msg.sender].hasMinted.add(_count) <=

                    MAX_MINT_WHITELIST,

                "Can only mint 2 Free Kids"

            );

            whitelist[msg.sender].hasMinted = whitelist[msg.sender]

                .hasMinted

                .add(_count);

        } else {

            require(

                (publicMintPrice * _count) <= msg.value,

                "Value below price"

            );

        }



        for (uint256 i = 0; i < _count; i++) {

            uint256 mintIndex = totalSupply() + 1;

            if (totalSupply() < MAX_ELEMENTS) {

                _safeMint(msg.sender, mintIndex);

            }

        }



        // If we haven't set the starting index and this is either

        // 1) the last saleable token or

        // 2) the first token to be sold after the end of pre-sale, set the starting index block

        if (

            startingIndexBlock == 0 &&

            (totalSupply() == MAX_ELEMENTS ||

                block.timestamp >= REVEAL_TIMESTAMP)

        ) {

            startingIndexBlock = block.number;

        }

    }





    function freeMint(uint256 _count) public {

        uint256 total = totalSupply();

        require(isWinnerlisted(msg.sender), "Is not winnerlisted");

        require(saleIsActive, "Sale must be active to mint");

        require((total + _count) <= MAX_ELEMENTS, "Exceeds max supply");

        require(

            winnerlist[msg.sender].claimAmount > 0,

            "You have no amount to claim"

        );

        require(

            _count <= winnerlist[msg.sender].claimAmount,

            "You claim amount exceeded"

        );



        for (uint256 i = 0; i < _count; i++) {

            uint256 mintIndex = totalSupply() + 1;

            if (totalSupply() < MAX_ELEMENTS) {

                _safeMint(msg.sender, mintIndex);

            }

        }



        winnerlist[msg.sender].claimAmount =

            winnerlist[msg.sender].claimAmount -

            _count;



        if (

            startingIndexBlock == 0 &&

            (totalSupply() == MAX_ELEMENTS ||

                block.timestamp >= REVEAL_TIMESTAMP)

        ) {

            startingIndexBlock = block.number;

        }

    }



    function setStartingIndex() external onlyOwner {

        require(startingIndex == 0, "Starting index is already set");

        require(startingIndexBlock != 0, "Starting index block must be set");



        startingIndex = uint256(blockhash(startingIndexBlock)) % MAX_ELEMENTS;

        // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)

        if ((block.number - startingIndexBlock) > 255) {

            startingIndex = uint256(blockhash(block.number - 1)) % MAX_ELEMENTS;

        }

        // Prevent default sequence

        if (startingIndex == 0) {

            startingIndex = startingIndex + 1;

        }

    }



    function setWhitelistAddr(address[] memory addrs) public onlyOwner {

        whitelistAddr = addrs;

        for (uint256 i = 0; i < whitelistAddr.length; i++) {

            addAddressToWhitelist(whitelistAddr[i]);

        }

    }



    function emergencySetStartingIndexBlock() external onlyOwner {

        require(startingIndex == 0, "Starting index is already set");



        startingIndexBlock = block.number;

    }



    function withdraw() public onlyOwner {

        uint256 balance = address(this).balance;

        (bool success, ) = msg.sender.call{value: balance}("");

        require(success);

    }



    function partialWithdraw(uint256 _amount, address payable _to)

        external

        onlyOwner

    {

        require(_amount > 0, "Withdraw must be greater than 0");

        require(_amount <= address(this).balance, "Amount too high");

        (bool success, ) = _to.call{value: _amount}("");

        require(success);

    }



    function addAddressToWhitelist(address addr)

        public

        onlyOwner

        returns (bool success)

    {

        require(!isWhitelisted(addr), "Already whitelisted");

        whitelist[addr].addr = addr;

        success = true;

    }



    function isWhitelisted(address addr)

        public

        view

        returns (bool isWhiteListed)

    {

        return whitelist[addr].addr == addr;

    }



    function addAddressToWinnerlist(address addr, uint256 claimAmount)

        public

        onlyOwner

        returns (bool success)

    {

        require(!isWinnerlisted(addr), "Already winnerlisted");

        winnerlist[addr].addr = addr;

        winnerlist[addr].claimAmount = claimAmount;

        winnerlist[addr].hasMinted = 0;

        success = true;

    }



    function isWinnerlisted(address addr)

        public

        view

        returns (bool isWinnerListed)

    {

        return winnerlist[addr].addr == addr;

    }

}