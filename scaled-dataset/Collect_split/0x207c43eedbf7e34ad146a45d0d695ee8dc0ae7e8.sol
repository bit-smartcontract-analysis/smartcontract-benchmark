// SPDX-License-Identifier: MIT

// File: contracts/Address.sol





pragma solidity ^0.8.6;



library Address {

    function isContract(address account) internal view returns (bool) {

        uint size;

        assembly {

            size := extcodesize(account)

        }

        return size > 0;

    }

}

// File: @openzeppelin/contracts/utils/Strings.sol





// OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)



pragma solidity ^0.8.0;



/**

 * @dev String operations.

 */

library Strings {

    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";



    /**

     * @dev Converts a `uint256` to its ASCII `string` decimal representation.

     */

    function toString(uint256 value) internal pure returns (string memory) {

        // Inspired by OraclizeAPI's implementation - MIT licence

        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol



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



    /**

     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.

     */

    function toHexString(uint256 value) internal pure returns (string memory) {

        if (value == 0) {

            return "0x00";

        }

        uint256 temp = value;

        uint256 length = 0;

        while (temp != 0) {

            length++;

            temp >>= 8;

        }

        return toHexString(value, length);

    }



    /**

     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.

     */

    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {

        bytes memory buffer = new bytes(2 * length + 2);

        buffer[0] = "0";

        buffer[1] = "x";

        for (uint256 i = 2 * length + 1; i > 1; --i) {

            buffer[i] = _HEX_SYMBOLS[value & 0xf];

            value >>= 4;

        }

        require(value == 0, "Strings: hex length insufficient");

        return string(buffer);

    }

}



// File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol





// OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)



pragma solidity ^0.8.0;



/**

 * @title ERC721 token receiver interface

 * @dev Interface for any contract that wants to support safeTransfers

 * from ERC721 asset contracts.

 */

interface IERC721Receiver {

    /**

     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}

     * by `operator` from `from`, this function is called.

     *

     * It must return its Solidity selector to confirm the token transfer.

     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.

     *

     * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.

     */

    function onERC721Received(

        address operator,

        address from,

        uint256 tokenId,

        bytes calldata data

    ) external returns (bytes4);

}



// File: @openzeppelin/contracts/utils/introspection/IERC165.sol





// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)



pragma solidity ^0.8.0;



/**

 * @dev Interface of the ERC165 standard, as defined in the

 * https://eips.ethereum.org/EIPS/eip-165[EIP].

 *

 * Implementers can declare support of contract interfaces, which can then be

 * queried by others ({ERC165Checker}).

 *

 * For an implementation, see {ERC165}.

 */

interface IERC165 {

    /**

     * @dev Returns true if this contract implements the interface defined by

     * `interfaceId`. See the corresponding

     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]

     * to learn more about how these ids are created.

     *

     * This function call must use less than 30 000 gas.

     */

    function supportsInterface(bytes4 interfaceId) external view returns (bool);

}



// File: @openzeppelin/contracts/utils/introspection/ERC165.sol





// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)



pragma solidity ^0.8.0;





/**

 * @dev Implementation of the {IERC165} interface.

 *

 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check

 * for the additional interface id that will be supported. For example:

 *

 * ```solidity

 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {

 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);

 * }

 * ```

 *

 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.

 */

abstract contract ERC165 is IERC165 {

    /**

     * @dev See {IERC165-supportsInterface}.

     */

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {

        return interfaceId == type(IERC165).interfaceId;

    }

}



// File: @openzeppelin/contracts/token/ERC721/IERC721.sol





// OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)



pragma solidity ^0.8.0;





/**

 * @dev Required interface of an ERC721 compliant contract.

 */

interface IERC721 is IERC165 {

    /**

     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.

     */

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);



    /**

     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.

     */

    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);



    /**

     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.

     */

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);



    /**

     * @dev Returns the number of tokens in ``owner``'s account.

     */

    function balanceOf(address owner) external view returns (uint256 balance);



    /**

     * @dev Returns the owner of the `tokenId` token.

     *

     * Requirements:

     *

     * - `tokenId` must exist.

     */

    function ownerOf(uint256 tokenId) external view returns (address owner);



    /**

     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients

     * are aware of the ERC721 protocol to prevent tokens from being forever locked.

     *

     * Requirements:

     *

     * - `from` cannot be the zero address.

     * - `to` cannot be the zero address.

     * - `tokenId` token must exist and be owned by `from`.

     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.

     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.

     *

     * Emits a {Transfer} event.

     */

    function safeTransferFrom(

        address from,

        address to,

        uint256 tokenId

    ) external;



    /**

     * @dev Transfers `tokenId` token from `from` to `to`.

     *

     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.

     *

     * Requirements:

     *

     * - `from` cannot be the zero address.

     * - `to` cannot be the zero address.

     * - `tokenId` token must be owned by `from`.

     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.

     *

     * Emits a {Transfer} event.

     */

    function transferFrom(

        address from,

        address to,

        uint256 tokenId

    ) external;



    /**

     * @dev Gives permission to `to` to transfer `tokenId` token to another account.

     * The approval is cleared when the token is transferred.

     *

     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.

     *

     * Requirements:

     *

     * - The caller must own the token or be an approved operator.

     * - `tokenId` must exist.

     *

     * Emits an {Approval} event.

     */

    function approve(address to, uint256 tokenId) external;



    /**

     * @dev Returns the account approved for `tokenId` token.

     *

     * Requirements:

     *

     * - `tokenId` must exist.

     */

    function getApproved(uint256 tokenId) external view returns (address operator);



    /**

     * @dev Approve or remove `operator` as an operator for the caller.

     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.

     *

     * Requirements:

     *

     * - The `operator` cannot be the caller.

     *

     * Emits an {ApprovalForAll} event.

     */

    function setApprovalForAll(address operator, bool _approved) external;



    /**

     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.

     *

     * See {setApprovalForAll}

     */

    function isApprovedForAll(address owner, address operator) external view returns (bool);



    /**

     * @dev Safely transfers `tokenId` token from `from` to `to`.

     *

     * Requirements:

     *

     * - `from` cannot be the zero address.

     * - `to` cannot be the zero address.

     * - `tokenId` token must exist and be owned by `from`.

     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.

     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.

     *

     * Emits a {Transfer} event.

     */

    function safeTransferFrom(

        address from,

        address to,

        uint256 tokenId,

        bytes calldata data

    ) external;

}



// File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol





// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)



pragma solidity ^0.8.0;





/**

 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension

 * @dev See https://eips.ethereum.org/EIPS/eip-721

 */

interface IERC721Enumerable is IERC721 {

    /**

     * @dev Returns the total amount of tokens stored by the contract.

     */

    function totalSupply() external view returns (uint256);



    /**

     * @dev Returns a token ID owned by `owner` at a given `index` of its token list.

     * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.

     */

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);



    /**

     * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.

     * Use along with {totalSupply} to enumerate all tokens.

     */

    function tokenByIndex(uint256 index) external view returns (uint256);

}



// File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol





// OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)



pragma solidity ^0.8.0;





/**

 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension

 * @dev See https://eips.ethereum.org/EIPS/eip-721

 */

interface IERC721Metadata is IERC721 {

    /**

     * @dev Returns the token collection name.

     */

    function name() external view returns (string memory);



    /**

     * @dev Returns the token collection symbol.

     */

    function symbol() external view returns (string memory);



    /**

     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.

     */

    function tokenURI(uint256 tokenId) external view returns (string memory);

}



// File: @openzeppelin/contracts/security/ReentrancyGuard.sol





// OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)



pragma solidity ^0.8.0;



/**

 * @dev Contract module that helps prevent reentrant calls to a function.

 *

 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier

 * available, which can be applied to functions to make sure there are no nested

 * (reentrant) calls to them.

 *

 * Note that because there is a single `nonReentrant` guard, functions marked as

 * `nonReentrant` may not call one another. This can be worked around by making

 * those functions `private`, and then adding `external` `nonReentrant` entry

 * points to them.

 *

 * TIP: If you would like to learn more about reentrancy and alternative ways

 * to protect against it, check out our blog post

 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].

 */

abstract contract ReentrancyGuard {

    // Booleans are more expensive than uint256 or any type that takes up a full

    // word because each write operation emits an extra SLOAD to first read the

    // slot's contents, replace the bits taken up by the boolean, and then write

    // back. This is the compiler's defense against contract upgrades and

    // pointer aliasing, and it cannot be disabled.



    // The values being non-zero value makes deployment a bit more expensive,

    // but in exchange the refund on every call to nonReentrant will be lower in

    // amount. Since refunds are capped to a percentage of the total

    // transaction's gas, it is best to keep them low in cases like this one, to

    // increase the likelihood of the full refund coming into effect.

    uint256 private constant _NOT_ENTERED = 1;

    uint256 private constant _ENTERED = 2;



    uint256 private _status;



    constructor() {

        _status = _NOT_ENTERED;

    }



    /**

     * @dev Prevents a contract from calling itself, directly or indirectly.

     * Calling a `nonReentrant` function from another `nonReentrant`

     * function is not supported. It is possible to prevent this from happening

     * by making the `nonReentrant` function external, and making it call a

     * `private` function that does the actual work.

     */

    modifier nonReentrant() {

        // On the first call to nonReentrant, _notEntered will be true

        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");



        // Any calls to nonReentrant after this point will fail

        _status = _ENTERED;



        _;



        // By storing the original value once again, a refund is triggered (see

        // https://eips.ethereum.org/EIPS/eip-2200)

        _status = _NOT_ENTERED;

    }

}



// File: @openzeppelin/contracts/utils/Context.sol





// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)



pragma solidity ^0.8.0;



/**

 * @dev Provides information about the current execution context, including the

 * sender of the transaction and its data. While these are generally available

 * via msg.sender and msg.data, they should not be accessed in such a direct

 * manner, since when dealing with meta-transactions the account sending and

 * paying for execution may not be the actual sender (as far as an application

 * is concerned).

 *

 * This contract is only required for intermediate, library-like contracts.

 */

abstract contract Context {

    function _msgSender() internal view virtual returns (address) {

        return msg.sender;

    }



    function _msgData() internal view virtual returns (bytes calldata) {

        return msg.data;

    }

}



// File: contracts/ERC721.sol







pragma solidity ^0.8.7;

















abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {

    using Address for address;

    using Strings for uint256;

    

    string private _name;

    string private _symbol;



    // Mapping from token ID to owner address

    address[] internal _owners;

    // Mapping for custom creations

    address[] internal _customOwners;



    mapping(uint256 => address) private _tokenApprovals;

    mapping(address => mapping(address => bool)) private _operatorApprovals;



    /**

     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.

     */

    constructor(string memory name_, string memory symbol_) {

        _name = name_;

        _symbol = symbol_;

    }



    /**

     * @dev See {IERC165-supportsInterface}.

     */

    function supportsInterface(bytes4 interfaceId)

        public

        view

        virtual

        override(ERC165, IERC165)

        returns (bool)

    {

        return

            interfaceId == type(IERC721).interfaceId ||

            interfaceId == type(IERC721Metadata).interfaceId ||

            super.supportsInterface(interfaceId);

    }



    /**

     * @dev See {IERC721-balanceOf}.

     */

    function balanceOf(address owner) 

        public 

        view 

        virtual 

        override 

        returns (uint) 

    {

        require(owner != address(0), "ERC721: balance query for the zero address");



        uint count;

        for( uint i; i < _owners.length; ++i ){

          if( owner == _owners[i] )

            ++count;

        }

        for( uint i; i < _customOwners.length; ++i ){

            if(owner == _customOwners[i])

            ++count;

        }

        return count;

    }



    /**

     * @dev See {IERC721-ownerOf}.

     */

    function ownerOf(uint256 tokenId)

        public

        view

        virtual

        override

        returns (address)

    {

        address owner;

        if(tokenId > 8887){

            owner = _customOwners[tokenId-8888];

        }

        else{

            owner = _owners[tokenId];

        }

        require(

            owner != address(0),

            "ERC721: owner query for nonexistent token"

        );

        return owner;

    }



    /**

     * @dev See {IERC721Metadata-name}.

     */

    function name() public view virtual override returns (string memory) {

        return _name;

    }



    /**

     * @dev See {IERC721Metadata-symbol}.

     */

    function symbol() public view virtual override returns (string memory) {

        return _symbol;

    }



    /**

     * @dev See {IERC721-approve}.

     */

    function approve(address to, uint256 tokenId) public virtual override {

        address owner = ERC721.ownerOf(tokenId);

        require(to != owner, "ERC721: approval to current owner");



        require(

            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),

            "ERC721: approve caller is not owner nor approved for all"

        );



        _approve(to, tokenId);

    }



    /**

     * @dev See {IERC721-getApproved}.

     */

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



    /**

     * @dev See {IERC721-setApprovalForAll}.

     */

    function setApprovalForAll(address operator, bool approved)

        public

        virtual

        override

    {

        require(operator != _msgSender(), "ERC721: approve to caller");



        _operatorApprovals[_msgSender()][operator] = approved;

        emit ApprovalForAll(_msgSender(), operator, approved);

    }



    /**

     * @dev See {IERC721-isApprovedForAll}.

     */

    function isApprovedForAll(address owner, address operator)

        public

        view

        virtual

        override

        returns (bool)

    {

        return _operatorApprovals[owner][operator];

    }



    /**

     * @dev See {IERC721-transferFrom}.

     */

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



    /**

     * @dev See {IERC721-safeTransferFrom}.

     */

    function safeTransferFrom(

        address from,

        address to,

        uint256 tokenId

    ) public virtual override {

        safeTransferFrom(from, to, tokenId, "");

    }



    /**

     * @dev See {IERC721-safeTransferFrom}.

     */

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



    /**

     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients

     * are aware of the ERC721 protocol to prevent tokens from being forever locked.

     *

     * `_data` is additional data, it has no specified format and it is sent in call to `to`.

     *

     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.

     * implement alternative mechanisms to perform token transfer, such as signature-based.

     *

     * Requirements:

     *

     * - `from` cannot be the zero address.

     * - `to` cannot be the zero address.

     * - `tokenId` token must exist and be owned by `from`.

     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.

     *

     * Emits a {Transfer} event.

     */

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



    /**

     * @dev Returns whether `tokenId` exists.

     *

     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.

     *

     * Tokens start existing when they are minted (`_mint`),

     * and stop existing when they are burned (`_burn`).

     */

    function _exists(uint256 tokenId) internal view virtual returns (bool) {

        if(tokenId > 8887){

            uint256 temp = tokenId - 8888;

            return temp < _customOwners.length && _customOwners[temp] != address(0);

        }

        return tokenId < _owners.length && _owners[tokenId] != address(0);

    }



    /**

     * @dev Returns whether `spender` is allowed to manage `tokenId`.

     *

     * Requirements:

     *

     * - `tokenId` must exist.

     */

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

            isApprovedForAll(owner, spender));

    }



    /**

     * @dev Safely mints `tokenId` and transfers it to `to`.

     *

     * Requirements:

     *

     * - `tokenId` must not exist.

     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.

     *

     * Emits a {Transfer} event.

     */

    function _safeMint(address to, uint256 tokenId) internal virtual {

        _safeMint(to, tokenId, "");

    }



    /**

     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is

     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.

     */

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



    /**

     * @dev Mints `tokenId` and transfers it to `to`.

     *

     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible

     *

     * Requirements:

     *

     * - `tokenId` must not exist.

     * - `to` cannot be the zero address.

     *

     * Emits a {Transfer} event.

     */

    function _mint(address to, uint256 tokenId) internal virtual {

        require(to != address(0), "ERC721: mint to the zero address");

        require(!_exists(tokenId), "ERC721: token already minted");



        _beforeTokenTransfer(address(0), to, tokenId);

        if(tokenId > 8887)

            _customOwners.push(to);

        else

        _owners.push(to);



        emit Transfer(address(0), to, tokenId);

    }



    /**

     * @dev Destroys `tokenId`.

     * The approval is cleared when the token is burned.

     *

     * Requirements:

     *

     * - `tokenId` must exist.

     *

     * Emits a {Transfer} event.

     */

    function _burn(uint256 tokenId) internal virtual {

        address owner = ERC721.ownerOf(tokenId);



        _beforeTokenTransfer(owner, address(0), tokenId);



        // Clear approvals

        _approve(address(0), tokenId);

        _owners[tokenId] = address(0);



        emit Transfer(owner, address(0), tokenId);

    }



    /**

     * @dev Transfers `tokenId` from `from` to `to`.

     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.

     *

     * Requirements:

     *

     * - `to` cannot be the zero address.

     * - `tokenId` token must be owned by `from`.

     *

     * Emits a {Transfer} event.

     */

    function _transfer(

        address from,

        address to,

        uint256 tokenId

    ) internal virtual {

        require(

            ERC721.ownerOf(tokenId) == from,

            "ERC721: transfer of token that is not own"

        );

        require(to != address(0), "ERC721: transfer to the zero address");



        _beforeTokenTransfer(from, to, tokenId);



        // Clear approvals from the previous owner

        _approve(address(0), tokenId);

        if(tokenId > 8887){

            _customOwners[tokenId-8888] = to;

        }

        else{

        _owners[tokenId] = to;

        }



        emit Transfer(from, to, tokenId);

    }



    /**

     * @dev Approve `to` to operate on `tokenId`

     *

     * Emits a {Approval} event.

     */

    function _approve(address to, uint256 tokenId) internal virtual {

        _tokenApprovals[tokenId] = to;

        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);

    }



    /**

     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.

     * The call is not executed if the target address is not a contract.

     *

     * @param from address representing the previous owner of the given token ID

     * @param to target address that will receive the tokens

     * @param tokenId uint256 ID of the token to be transferred

     * @param _data bytes optional data to send along with the call

     * @return bool whether the call correctly returned the expected magic value

     */

    function _checkOnERC721Received(

        address from,

        address to,

        uint256 tokenId,

        bytes memory _data

    ) private returns (bool) {

        if (to.isContract()) {

            try

                IERC721Receiver(to).onERC721Received(

                    _msgSender(),

                    from,

                    tokenId,

                    _data

                )

            returns (bytes4 retval) {

                return retval == IERC721Receiver.onERC721Received.selector;

            } catch (bytes memory reason) {

                if (reason.length == 0) {

                    revert(

                        "ERC721: transfer to non ERC721Receiver implementer"

                    );

                } else {

                    assembly {

                        revert(add(32, reason), mload(reason))

                    }

                }

            }

        } else {

            return true;

        }

    }



    /**

     * @dev Hook that is called before any token transfer. This includes minting

     * and burning.

     *

     * Calling conditions:

     *

     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be

     * transferred to `to`.

     * - When `from` is zero, `tokenId` will be minted for `to`.

     * - When `to` is zero, ``from``'s `tokenId` will be burned.

     * - `from` and `to` are never both zero.

     *

     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].

     */

    function _beforeTokenTransfer(

        address from,

        address to,

        uint256 tokenId

    ) internal virtual {}

}

// File: contracts/ERC721Enumerable.sol







pragma solidity ^0.8.7;







/**

 * @dev This implements an optional extension of {ERC721} defined in the EIP that adds

 * enumerability of all the token ids in the contract as well as all token ids owned by each

 * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.

 */

abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {

    /**

     * @dev See {IERC165-supportsInterface}.

     */

    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {

        return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);

    }



    /**

     * @dev See {IERC721Enumerable-totalSupply}.

     */

    function totalSupply() public view virtual override returns (uint256) {

        return _owners.length + _customOwners.length;

    }



    /**

     * @dev See {IERC721Enumerable-tokenByIndex}.

     */

    function tokenByIndex(uint256 index) public view virtual override returns (uint256) {

        if(index > 8887){

            require(index - 8888 < _customOwners.length, "ERC721Enumerable: custom index out of bounds");

            return index; 

        }

        require(index < _owners.length, "ERC721Enumerable: global index out of bounds");

        return index;

    }



    /**

     * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.

     */

    function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {

        if(index > 8887){

            uint256 temp = index-8888;

            require(temp < balanceOf(owner), "ERC721: custom index out of bounds");

            uint counter;

            for(uint i; i < _customOwners.length; i++){

                if(owner == _customOwners[i]){

                    if(counter == temp) return i;

                    else counter++;

                }

            }

        }

        require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");



        uint count;

        for(uint i; i < _owners.length; i++){

            if(owner == _owners[i]){

                if(count == index) return i;

                else count++;

            }

        }



        revert("ERC721Enumerable: owner index out of bounds");

    }

    

}

// File: @openzeppelin/contracts/access/Ownable.sol





// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)



pragma solidity ^0.8.0;





/**

 * @dev Contract module which provides a basic access control mechanism, where

 * there is an account (an owner) that can be granted exclusive access to

 * specific functions.

 *

 * By default, the owner account will be the one that deploys the contract. This

 * can later be changed with {transferOwnership}.

 *

 * This module is used through inheritance. It will make available the modifier

 * `onlyOwner`, which can be applied to your functions to restrict their use to

 * the owner.

 */

abstract contract Ownable is Context {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    constructor() {

        _transferOwnership(_msgSender());

    }



    /**

     * @dev Returns the address of the current owner.

     */

    function owner() public view virtual returns (address) {

        return _owner;

    }



    /**

     * @dev Throws if called by any account other than the owner.

     */

    modifier onlyOwner() {

        require(owner() == _msgSender(), "Ownable: caller is not the owner");

        _;

    }



    /**

     * @dev Leaves the contract without owner. It will not be possible to call

     * `onlyOwner` functions anymore. Can only be called by the current owner.

     *

     * NOTE: Renouncing ownership will leave the contract without an owner,

     * thereby removing any functionality that is only available to the owner.

     */

    function renounceOwnership() public virtual onlyOwner {

        _transferOwnership(address(0));

    }



    /**

     * @dev Transfers ownership of the contract to a new account (`newOwner`).

     * Can only be called by the current owner.

     */

    function transferOwnership(address newOwner) public virtual onlyOwner {

        require(newOwner != address(0), "Ownable: new owner is the zero address");

        _transferOwnership(newOwner);

    }



    /**

     * @dev Transfers ownership of the contract to a new account (`newOwner`).

     * Internal function without access restriction.

     */

    function _transferOwnership(address newOwner) internal virtual {

        address oldOwner = _owner;

        _owner = newOwner;

        emit OwnershipTransferred(oldOwner, newOwner);

    }

}



// File: contracts/dreamers.sol







pragma solidity ^0.8.7;









contract WizardsWitches is ERC721Enumerable, ReentrancyGuard, Ownable {

    uint256 public maxTokens;  

    address public proxyRegistryAddress;

    string public baseURI;

    string public customURI;

    bool public devMintLocked;

    uint256 public devCreations;

    uint256 public constant devReserves = 200;

    uint256 public constant maxMintsPerTx = 6;

    uint256 public constant tokenPrice = 0.022 ether;





    event Minted(address indexed account, uint256 tokenId);



    mapping(address => bool) public projectProxy;





    constructor(

        string memory _baseURI,

        address _proxyRegistryAddress

        )

        ERC721("WizardsWitches", "WnW")

        {

            baseURI = _baseURI;

            proxyRegistryAddress = _proxyRegistryAddress;

        }

    

   //Set Base URI

    function setBaseURI(string memory _baseURI) 

        external 

        onlyOwner 

        {

            baseURI = _baseURI;

        }



    function tokenURI(uint256 _tokenId)

        public

        view

        override

        returns (string memory)

        {

            require(_exists(_tokenId), "Token does not exist.");

            if(_tokenId > 8887)

                return string(abi.encodePacked(customURI, Strings.toString(_tokenId)));

            return string(abi.encodePacked(baseURI, Strings.toString(_tokenId)));

        }



    function setProxyRegistryAddress(address _proxyRegistryAddress)

        external

        onlyOwner

        {

            proxyRegistryAddress = _proxyRegistryAddress;

        }

    





    function isOwnerOf(address account, uint256[] calldata _tokenIds)

        external

        view

        returns (bool)

        {

            for(uint256 i; i < _tokenIds.length; ++i)

            {

                if(i > 8887){

                    if(_customOwners[_tokenIds[i-8888]] == account)

                    return true;

                }

                if(_owners[_tokenIds[i]] != account)

                    return false;

            }

            return true;

        }



    function batchTransferFrom(address _from, address _to, uint256[] memory _tokenIds)

        public 

        {

            for (uint256 i = 0; i < _tokenIds.length; i++)

            {

            transferFrom(_from, _to, _tokenIds[i]);

            }

        }



    function batchSafeTransferFrom(address _from, address _to, uint256[] memory _tokenIds, bytes memory data_)

        public

        {

            for (uint256 i = 0; i < _tokenIds.length; i++)

            {

            safeTransferFrom(_from, _to, _tokenIds[i], data_);

            }

        }



    function isApprovedForAll(address _owner, address operator) 

        public 

        view

        override

        returns(bool)

        {

            OpenSeaProxyRegistry proxyRegistry = OpenSeaProxyRegistry(proxyRegistryAddress);

            if (address(proxyRegistry.proxies(_owner)) == operator)

                return true;

            return super.isApprovedForAll(_owner, operator);

        }



    // for custom creations

    function setCustomURI(string memory _customURI)

        external

        onlyOwner

        {

            customURI = _customURI;

        }

       

       //Cannot be turned back, tread carefully

    function lockDevMint()

        public

        onlyOwner

        {

        devMintLocked=true;

        }





   function togglePublicSale(uint256 _maxTokens)

        external

        onlyOwner

        {

            require(maxTokens == 0, "public sale has already begun!");

            maxTokens = _maxTokens;

        }

    

    function publicMint(uint256 count)

        public

        nonReentrant

        payable

        {

            uint256 totalSupply = _owners.length;



            require(totalSupply + count <= maxTokens - devCreations, "Pick a smaller number to summon, the contracts are almost fully filled!");

            require(count <= maxMintsPerTx, "You lack the power to summon more than 5 at a time!");

            require(count * tokenPrice == msg.value, "Your sacrifice is found lacking. Invalid funds provided.");

    

            for(uint i; i < count; i++)

            { 

                _mint(_msgSender(), totalSupply + i);

                emit Minted(_msgSender(), totalSupply + i);

            }

        }



    function burn(uint256 tokenId)

        public

        { 

            require(_isApprovedOrOwner(_msgSender(), tokenId), "Not approved to burn.");

            _burn(tokenId);

        }



//swap this to address, to

    function devCustomMint(uint256 specialId)

        external

        onlyOwner

        {

            require(!devMintLocked, "Dev mint is locked! Collection is final!");

            devCreations++;

            maxTokens++;

            _mint(_msgSender(), specialId);

            emit Minted(_msgSender(), specialId);

        }



    function collectDevReserves()

        external

        onlyOwner

        {

            require(_owners.length == 0, 'Reserves already taken.');

                devMintLocked = false;

                devCreations = 0;

                for(uint256 i; i < devReserves; i++)

                    _mint(_msgSender(), i);

        }



    

    function walletOfOwner(address _owner)

        public

        view 

        returns (uint256[] memory)

        {

            uint256 tokenCount = balanceOf(_owner);

                if (tokenCount == 0) return new uint256[](0);



            uint256[] memory tokensId = new uint256[](tokenCount);

                for (uint256 i; i < tokenCount; i++) 

                {

                    tokensId[i] = tokenOfOwnerByIndex(_owner, i);

                }

        return tokensId;

    }





    //Allow owner to withdraw eth

    function withdraw()

    public 

    nonReentrant

    onlyOwner {

        (bool os, ) = payable(owner()).call{value: address(this).balance}('');

        require(os);

    }



    function _mint(address to, uint256 tokenId)

        internal

        virtual

        override

        {

        if(tokenId > 8887){

            _customOwners.push(to);

        }

        else{

        _owners.push(to);

        }

        emit Transfer(address(0), to, tokenId);

        }

}



contract OwnableDelegateProxy { }

contract OpenSeaProxyRegistry {

    mapping(address => OwnableDelegateProxy) public proxies;

}