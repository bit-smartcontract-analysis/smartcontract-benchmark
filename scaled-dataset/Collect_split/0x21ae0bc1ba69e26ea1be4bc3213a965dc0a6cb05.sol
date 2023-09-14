// SPDX-License-Identifier: MIT



/*

░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

░░░░░░░░░░░░░░░░░░░░░░░░  ░░░░░░░░░░░░░░░░░░░░░░░░░

░░░░░░░░░░░░░░░░░░░░░░      ░░░░░░░░░░░░░░░░░░░░░░░

░░░░░░░░░░░░░░░░░░░░░        ░░░░░░░░░░░░░░░░░░░░░░

░░░░░░░░░░░░░░░░░░░            ░░░░░░░░░░░░░░░░░░░░

░░░░░░░░░░░░░░░░░░              ░░░░░░░░░░░░░░░░░░░

░░░░░░░░░░░░░░░░░                ░░░░░░░░░░░░░░░░░░

░░░░░░░░░░░░░░░░░░░░░        ░░░░░░░░░░░░░░░░░░░░░░

░░░░░░░░░░░░░        ░░░░░░░░        ░░░░░░░░░░░░░░

░░░░░░░░░░░░            ░░            ░░░░░░░░░░░░░

░░░░░░░░░░░             ░░              ░░░░░░░░░░░

░░░░░░░░░░              ░░               ░░░░░░░░░░

░░░░░░░░░              ░░░░               ░░░░░░░░░

░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

░░░░░░█▀▀░░░░░░█▀█░░░░░░▀█▀░░░░░░█▀▀░░░░░░█▀▀░░░░░░

░░░░░░█▀▀░░░░░░█▀█░░░░░░░█░░░░░░░█▀▀░░░░░░▀▀█░░░░░░

░░░░░░▀░░░░░░░░▀░▀░░░░░░░▀░░░░░░░▀▀▀░░░░░░▀▀▀░░░░░░

░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

░░░░░░░             Pod v1.0.6              ░░░░░░░

░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

*/



// File: contracts/IERC2981Royalties.sol





pragma solidity ^0.8.0;



/// @title IERC2981Royalties

/// @dev Interface for the ERC2981 - Token Royalty standard

interface IERC2981Royalties {

    /// @notice Called with the sale price to determine how much royalty

    //          is owed and to whom.

    /// @param _tokenId - the NFT asset queried for royalty information

    /// @param _value - the sale price of the NFT asset specified by _tokenId

    /// @return _receiver - address of who should be sent the royalty payment

    /// @return _royaltyAmount - the royalty payment amount for value sale price

    function royaltyInfo(uint256 _tokenId, uint256 _value)

        external

        view

        returns (address _receiver, uint256 _royaltyAmount);

}

// File: contracts/IOperatorFilterRegistry.sol





pragma solidity ^0.8.13;



interface IOperatorFilterRegistry {

    function isOperatorAllowed(address registrant, address operator) external view returns (bool);

    function register(address registrant) external;

    function registerAndSubscribe(address registrant, address subscription) external;

    function registerAndCopyEntries(address registrant, address registrantToCopy) external;

    function unregister(address addr) external;

    function updateOperator(address registrant, address operator, bool filtered) external;

    function updateOperators(address registrant, address[] calldata operators, bool filtered) external;

    function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;

    function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;

    function subscribe(address registrant, address registrantToSubscribe) external;

    function unsubscribe(address registrant, bool copyExistingEntries) external;

    function subscriptionOf(address addr) external returns (address registrant);

    function subscribers(address registrant) external returns (address[] memory);

    function subscriberAt(address registrant, uint256 index) external returns (address);

    function copyEntriesOf(address registrant, address registrantToCopy) external;

    function isOperatorFiltered(address registrant, address operator) external returns (bool);

    function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);

    function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);

    function filteredOperators(address addr) external returns (address[] memory);

    function filteredCodeHashes(address addr) external returns (bytes32[] memory);

    function filteredOperatorAt(address registrant, uint256 index) external returns (address);

    function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);

    function isRegistered(address addr) external returns (bool);

    function codeHashOf(address addr) external returns (bytes32);

}



// File: contracts/OperatorFilterer.sol





pragma solidity ^0.8.13;





/**

 * @title  OperatorFilterer

 * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another

 *         registrant's entries in the OperatorFilterRegistry.

 * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:

 *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.

 *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.

 */

abstract contract OperatorFilterer {

    error OperatorNotAllowed(address operator);



    IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =

        IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);



    constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {

        // If an inheriting token contract is deployed to a network without the registry deployed, the modifier

        // will not revert, but the contract will need to be registered with the registry once it is deployed in

        // order for the modifier to filter addresses.

        if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {

            if (subscribe) {

                OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);

            } else {

                if (subscriptionOrRegistrantToCopy != address(0)) {

                    OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);

                } else {

                    OPERATOR_FILTER_REGISTRY.register(address(this));

                }

            }

        }

    }



    modifier onlyAllowedOperator(address from) virtual {

        // Check registry code length to facilitate testing in environments without a deployed registry.

        if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {

            // Allow spending tokens from addresses with balance

            // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred

            // from an EOA.

            if (from == msg.sender) {

                _;

                return;

            }

            if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {

                revert OperatorNotAllowed(msg.sender);

            }

        }

        _;

    }



    modifier onlyAllowedOperatorApproval(address operator) virtual {

        // Check registry code length to facilitate testing in environments without a deployed registry.

        if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {

            if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {

                revert OperatorNotAllowed(operator);

            }

        }

        _;

    }

}

// File: contracts/RevokableOperatorFilterer.sol





pragma solidity ^0.8.13;





/**

 * @title  RevokableOperatorFilterer

 * @notice This contract is meant to allow contracts to permanently opt out of the OperatorFilterRegistry. The Registry

 *         itself has an "unregister" function, but if the contract is ownable, the owner can re-register at any point.

 *         As implemented, this abstract contract allows the contract owner to toggle the

 *         isOperatorFilterRegistryRevoked flag in order to permanently bypass the OperatorFilterRegistry checks.

 */

abstract contract RevokableOperatorFilterer is OperatorFilterer {

    error OnlyOwner();

    error AlreadyRevoked();



    bool private _isOperatorFilterRegistryRevoked;



    modifier onlyAllowedOperator(address from) override {

        // Check registry code length to facilitate testing in environments without a deployed registry.

        if (!_isOperatorFilterRegistryRevoked && address(OPERATOR_FILTER_REGISTRY).code.length > 0) {

            // Allow spending tokens from addresses with balance

            // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred

            // from an EOA.

            if (from == msg.sender) {

                _;

                return;

            }

            if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {

                revert OperatorNotAllowed(msg.sender);

            }

        }

        _;

    }



    modifier onlyAllowedOperatorApproval(address operator) override {

        // Check registry code length to facilitate testing in environments without a deployed registry.

        if (!_isOperatorFilterRegistryRevoked && address(OPERATOR_FILTER_REGISTRY).code.length > 0) {

            if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {

                revert OperatorNotAllowed(operator);

            }

        }

        _;

    }



    /**

     * @notice Disable the isOperatorFilterRegistryRevoked flag. OnlyOwner.

     */

    function revokeOperatorFilterRegistry() external {

        if (msg.sender != owner()) {

            revert OnlyOwner();

        }

        if (_isOperatorFilterRegistryRevoked) {

            revert AlreadyRevoked();

        }

        _isOperatorFilterRegistryRevoked = true;

    }



    function isOperatorFilterRegistryRevoked() public view returns (bool) {

        return _isOperatorFilterRegistryRevoked;

    }



    /**

     * @dev assume the contract has an owner, but leave specific Ownable implementation up to inheriting contract

     */

    function owner() public view virtual returns (address);

}

// File: contracts/RevokableDefaultOperatorFilterer.sol





pragma solidity ^0.8.13;







/**

 * @title  RevokableDefaultOperatorFilterer

 * @notice Inherits from RevokableOperatorFilterer and automatically subscribes to the default OpenSea subscription.

 */

abstract contract RevokableDefaultOperatorFilterer is RevokableOperatorFilterer {

    address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);



    constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}

}

// File: @openzeppelin/contracts/utils/Strings.sol





// OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)



pragma solidity ^0.8.0;



/**

 * @dev String operations.

 */

library Strings {

    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    uint8 private constant _ADDRESS_LENGTH = 20;



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



    /**

     * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.

     */

    function toHexString(address addr) internal pure returns (string memory) {

        return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);

    }

}



// File: @openzeppelin/contracts/access/IAccessControl.sol





// OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)



pragma solidity ^0.8.0;



/**

 * @dev External interface of AccessControl declared to support ERC165 detection.

 */

interface IAccessControl {

    /**

     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`

     *

     * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite

     * {RoleAdminChanged} not being emitted signaling this.

     *

     * _Available since v3.1._

     */

    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);



    /**

     * @dev Emitted when `account` is granted `role`.

     *

     * `sender` is the account that originated the contract call, an admin role

     * bearer except when using {AccessControl-_setupRole}.

     */

    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);



    /**

     * @dev Emitted when `account` is revoked `role`.

     *

     * `sender` is the account that originated the contract call:

     *   - if using `revokeRole`, it is the admin role bearer

     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)

     */

    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);



    /**

     * @dev Returns `true` if `account` has been granted `role`.

     */

    function hasRole(bytes32 role, address account) external view returns (bool);



    /**

     * @dev Returns the admin role that controls `role`. See {grantRole} and

     * {revokeRole}.

     *

     * To change a role's admin, use {AccessControl-_setRoleAdmin}.

     */

    function getRoleAdmin(bytes32 role) external view returns (bytes32);



    /**

     * @dev Grants `role` to `account`.

     *

     * If `account` had not been already granted `role`, emits a {RoleGranted}

     * event.

     *

     * Requirements:

     *

     * - the caller must have ``role``'s admin role.

     */

    function grantRole(bytes32 role, address account) external;



    /**

     * @dev Revokes `role` from `account`.

     *

     * If `account` had been granted `role`, emits a {RoleRevoked} event.

     *

     * Requirements:

     *

     * - the caller must have ``role``'s admin role.

     */

    function revokeRole(bytes32 role, address account) external;



    /**

     * @dev Revokes `role` from the calling account.

     *

     * Roles are often managed via {grantRole} and {revokeRole}: this function's

     * purpose is to provide a mechanism for accounts to lose their privileges

     * if they are compromised (such as when a trusted device is misplaced).

     *

     * If the calling account had been granted `role`, emits a {RoleRevoked}

     * event.

     *

     * Requirements:

     *

     * - the caller must be `account`.

     */

    function renounceRole(bytes32 role, address account) external;

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



// File: @openzeppelin/contracts/access/Ownable.sol





// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)



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

     * @dev Throws if called by any account other than the owner.

     */

    modifier onlyOwner() {

        _checkOwner();

        _;

    }



    /**

     * @dev Returns the address of the current owner.

     */

    function owner() public view virtual returns (address) {

        return _owner;

    }



    /**

     * @dev Throws if the sender is not the owner.

     */

    function _checkOwner() internal view virtual {

        require(owner() == _msgSender(), "Ownable: caller is not the owner");

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



// File: @openzeppelin/contracts/utils/Address.sol





// OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)



pragma solidity ^0.8.1;



/**

 * @dev Collection of functions related to the address type

 */

library Address {

    /**

     * @dev Returns true if `account` is a contract.

     *

     * [IMPORTANT]

     * ====

     * It is unsafe to assume that an address for which this function returns

     * false is an externally-owned account (EOA) and not a contract.

     *

     * Among others, `isContract` will return false for the following

     * types of addresses:

     *

     *  - an externally-owned account

     *  - a contract in construction

     *  - an address where a contract will be created

     *  - an address where a contract lived, but was destroyed

     * ====

     *

     * [IMPORTANT]

     * ====

     * You shouldn't rely on `isContract` to protect against flash loan attacks!

     *

     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets

     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract

     * constructor.

     * ====

     */

    function isContract(address account) internal view returns (bool) {

        // This method relies on extcodesize/address.code.length, which returns 0

        // for contracts in construction, since the code is only stored at the end

        // of the constructor execution.



        return account.code.length > 0;

    }



    /**

     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to

     * `recipient`, forwarding all available gas and reverting on errors.

     *

     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost

     * of certain opcodes, possibly making contracts go over the 2300 gas limit

     * imposed by `transfer`, making them unable to receive funds via

     * `transfer`. {sendValue} removes this limitation.

     *

     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].

     *

     * IMPORTANT: because control is transferred to `recipient`, care must be

     * taken to not create reentrancy vulnerabilities. Consider using

     * {ReentrancyGuard} or the

     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].

     */

    function sendValue(address payable recipient, uint256 amount) internal {

        require(address(this).balance >= amount, "Address: insufficient balance");



        (bool success, ) = recipient.call{value: amount}("");

        require(success, "Address: unable to send value, recipient may have reverted");

    }



    /**

     * @dev Performs a Solidity function call using a low level `call`. A

     * plain `call` is an unsafe replacement for a function call: use this

     * function instead.

     *

     * If `target` reverts with a revert reason, it is bubbled up by this

     * function (like regular Solidity function calls).

     *

     * Returns the raw returned data. To convert to the expected return value,

     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].

     *

     * Requirements:

     *

     * - `target` must be a contract.

     * - calling `target` with `data` must not revert.

     *

     * _Available since v3.1._

     */

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {

        return functionCall(target, data, "Address: low-level call failed");

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with

     * `errorMessage` as a fallback revert reason when `target` reverts.

     *

     * _Available since v3.1._

     */

    function functionCall(

        address target,

        bytes memory data,

        string memory errorMessage

    ) internal returns (bytes memory) {

        return functionCallWithValue(target, data, 0, errorMessage);

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],

     * but also transferring `value` wei to `target`.

     *

     * Requirements:

     *

     * - the calling contract must have an ETH balance of at least `value`.

     * - the called Solidity function must be `payable`.

     *

     * _Available since v3.1._

     */

    function functionCallWithValue(

        address target,

        bytes memory data,

        uint256 value

    ) internal returns (bytes memory) {

        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");

    }



    /**

     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but

     * with `errorMessage` as a fallback revert reason when `target` reverts.

     *

     * _Available since v3.1._

     */

    function functionCallWithValue(

        address target,

        bytes memory data,

        uint256 value,

        string memory errorMessage

    ) internal returns (bytes memory) {

        require(address(this).balance >= value, "Address: insufficient balance for call");

        require(isContract(target), "Address: call to non-contract");



        (bool success, bytes memory returndata) = target.call{value: value}(data);

        return verifyCallResult(success, returndata, errorMessage);

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],

     * but performing a static call.

     *

     * _Available since v3.3._

     */

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {

        return functionStaticCall(target, data, "Address: low-level static call failed");

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],

     * but performing a static call.

     *

     * _Available since v3.3._

     */

    function functionStaticCall(

        address target,

        bytes memory data,

        string memory errorMessage

    ) internal view returns (bytes memory) {

        require(isContract(target), "Address: static call to non-contract");



        (bool success, bytes memory returndata) = target.staticcall(data);

        return verifyCallResult(success, returndata, errorMessage);

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],

     * but performing a delegate call.

     *

     * _Available since v3.4._

     */

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {

        return functionDelegateCall(target, data, "Address: low-level delegate call failed");

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],

     * but performing a delegate call.

     *

     * _Available since v3.4._

     */

    function functionDelegateCall(

        address target,

        bytes memory data,

        string memory errorMessage

    ) internal returns (bytes memory) {

        require(isContract(target), "Address: delegate call to non-contract");



        (bool success, bytes memory returndata) = target.delegatecall(data);

        return verifyCallResult(success, returndata, errorMessage);

    }



    /**

     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the

     * revert reason using the provided one.

     *

     * _Available since v4.3._

     */

    function verifyCallResult(

        bool success,

        bytes memory returndata,

        string memory errorMessage

    ) internal pure returns (bytes memory) {

        if (success) {

            return returndata;

        } else {

            // Look for revert reason and bubble it up if present

            if (returndata.length > 0) {

                // The easiest way to bubble the revert reason is using memory via assembly

                /// @solidity memory-safe-assembly

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



// File: contracts/ERC2981Base.sol





pragma solidity ^0.8.0;







/// @dev This is a contract used to add ERC2981 support to ERC721 and 1155

abstract contract ERC2981Base is ERC165, IERC2981Royalties {

    struct RoyaltyInfo {

        address recipient;

        uint24 amount;

    }



    /// @inheritdoc	ERC165

    function supportsInterface(bytes4 interfaceId)

        public

        view

        virtual

        override

        returns (bool)

    {

        return

            interfaceId == type(IERC2981Royalties).interfaceId ||

            super.supportsInterface(interfaceId);

    }

}

// File: contracts/ERC2981ContractWideRoyalties.sol





pragma solidity ^0.8.0;







/// @dev This is a contract used to add ERC2981 support to ERC721 and 1155

/// @dev This implementation has the same royalties for each and every tokens

abstract contract ERC2981ContractWideRoyalties is ERC2981Base {

    RoyaltyInfo private _royalties;



    /// @dev Sets token royalties

    /// @param recipient recipient of the royalties

    /// @param value percentage (using 2 decimals - 10000 = 100, 0 = 0)

    function _setRoyalties(address recipient, uint256 value) internal {

        require(value <= 10000, "ERC2981Royalties: Too high");

        _royalties = RoyaltyInfo(recipient, uint24(value));

    }



    /// @inheritdoc	IERC2981Royalties

    function royaltyInfo(uint256, uint256 value)

        external

        view

        override

        returns (address receiver, uint256 royaltyAmount)

    {

        RoyaltyInfo memory royalties = _royalties;

        receiver = royalties.recipient;

        royaltyAmount = (value * royalties.amount) / 10000;

    }

}

// File: @openzeppelin/contracts/access/AccessControl.sol





// OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)



pragma solidity ^0.8.0;











/**

 * @dev Contract module that allows children to implement role-based access

 * control mechanisms. This is a lightweight version that doesn't allow enumerating role

 * members except through off-chain means by accessing the contract event logs. Some

 * applications may benefit from on-chain enumerability, for those cases see

 * {AccessControlEnumerable}.

 *

 * Roles are referred to by their `bytes32` identifier. These should be exposed

 * in the external API and be unique. The best way to achieve this is by

 * using `public constant` hash digests:

 *

 * ```

 * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");

 * ```

 *

 * Roles can be used to represent a set of permissions. To restrict access to a

 * function call, use {hasRole}:

 *

 * ```

 * function foo() public {

 *     require(hasRole(MY_ROLE, msg.sender));

 *     ...

 * }

 * ```

 *

 * Roles can be granted and revoked dynamically via the {grantRole} and

 * {revokeRole} functions. Each role has an associated admin role, and only

 * accounts that have a role's admin role can call {grantRole} and {revokeRole}.

 *

 * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means

 * that only accounts with this role will be able to grant or revoke other

 * roles. More complex role relationships can be created by using

 * {_setRoleAdmin}.

 *

 * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to

 * grant and revoke this role. Extra precautions should be taken to secure

 * accounts that have been granted it.

 */

abstract contract AccessControl is Context, IAccessControl, ERC165 {

    struct RoleData {

        mapping(address => bool) members;

        bytes32 adminRole;

    }



    mapping(bytes32 => RoleData) private _roles;



    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;



    /**

     * @dev Modifier that checks that an account has a specific role. Reverts

     * with a standardized message including the required role.

     *

     * The format of the revert reason is given by the following regular expression:

     *

     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/

     *

     * _Available since v4.1._

     */

    modifier onlyRole(bytes32 role) {

        _checkRole(role);

        _;

    }



    /**

     * @dev See {IERC165-supportsInterface}.

     */

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {

        return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);

    }



    /**

     * @dev Returns `true` if `account` has been granted `role`.

     */

    function hasRole(bytes32 role, address account) public view virtual override returns (bool) {

        return _roles[role].members[account];

    }



    /**

     * @dev Revert with a standard message if `_msgSender()` is missing `role`.

     * Overriding this function changes the behavior of the {onlyRole} modifier.

     *

     * Format of the revert message is described in {_checkRole}.

     *

     * _Available since v4.6._

     */

    function _checkRole(bytes32 role) internal view virtual {

        _checkRole(role, _msgSender());

    }



    /**

     * @dev Revert with a standard message if `account` is missing `role`.

     *

     * The format of the revert reason is given by the following regular expression:

     *

     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/

     */

    function _checkRole(bytes32 role, address account) internal view virtual {

        if (!hasRole(role, account)) {

            revert(

                string(

                    abi.encodePacked(

                        "AccessControl: account ",

                        Strings.toHexString(uint160(account), 20),

                        " is missing role ",

                        Strings.toHexString(uint256(role), 32)

                    )

                )

            );

        }

    }



    /**

     * @dev Returns the admin role that controls `role`. See {grantRole} and

     * {revokeRole}.

     *

     * To change a role's admin, use {_setRoleAdmin}.

     */

    function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {

        return _roles[role].adminRole;

    }



    /**

     * @dev Grants `role` to `account`.

     *

     * If `account` had not been already granted `role`, emits a {RoleGranted}

     * event.

     *

     * Requirements:

     *

     * - the caller must have ``role``'s admin role.

     *

     * May emit a {RoleGranted} event.

     */

    function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {

        _grantRole(role, account);

    }



    /**

     * @dev Revokes `role` from `account`.

     *

     * If `account` had been granted `role`, emits a {RoleRevoked} event.

     *

     * Requirements:

     *

     * - the caller must have ``role``'s admin role.

     *

     * May emit a {RoleRevoked} event.

     */

    function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {

        _revokeRole(role, account);

    }



    /**

     * @dev Revokes `role` from the calling account.

     *

     * Roles are often managed via {grantRole} and {revokeRole}: this function's

     * purpose is to provide a mechanism for accounts to lose their privileges

     * if they are compromised (such as when a trusted device is misplaced).

     *

     * If the calling account had been revoked `role`, emits a {RoleRevoked}

     * event.

     *

     * Requirements:

     *

     * - the caller must be `account`.

     *

     * May emit a {RoleRevoked} event.

     */

    function renounceRole(bytes32 role, address account) public virtual override {

        require(account == _msgSender(), "AccessControl: can only renounce roles for self");



        _revokeRole(role, account);

    }



    /**

     * @dev Grants `role` to `account`.

     *

     * If `account` had not been already granted `role`, emits a {RoleGranted}

     * event. Note that unlike {grantRole}, this function doesn't perform any

     * checks on the calling account.

     *

     * May emit a {RoleGranted} event.

     *

     * [WARNING]

     * ====

     * This function should only be called from the constructor when setting

     * up the initial roles for the system.

     *

     * Using this function in any other way is effectively circumventing the admin

     * system imposed by {AccessControl}.

     * ====

     *

     * NOTE: This function is deprecated in favor of {_grantRole}.

     */

    function _setupRole(bytes32 role, address account) internal virtual {

        _grantRole(role, account);

    }



    /**

     * @dev Sets `adminRole` as ``role``'s admin role.

     *

     * Emits a {RoleAdminChanged} event.

     */

    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {

        bytes32 previousAdminRole = getRoleAdmin(role);

        _roles[role].adminRole = adminRole;

        emit RoleAdminChanged(role, previousAdminRole, adminRole);

    }



    /**

     * @dev Grants `role` to `account`.

     *

     * Internal function without access restriction.

     *

     * May emit a {RoleGranted} event.

     */

    function _grantRole(bytes32 role, address account) internal virtual {

        if (!hasRole(role, account)) {

            _roles[role].members[account] = true;

            emit RoleGranted(role, account, _msgSender());

        }

    }



    /**

     * @dev Revokes `role` from `account`.

     *

     * Internal function without access restriction.

     *

     * May emit a {RoleRevoked} event.

     */

    function _revokeRole(bytes32 role, address account) internal virtual {

        if (hasRole(role, account)) {

            _roles[role].members[account] = false;

            emit RoleRevoked(role, account, _msgSender());

        }

    }

}



// File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol





// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)



pragma solidity ^0.8.0;





/**

 * @dev _Available since v3.1._

 */

interface IERC1155Receiver is IERC165 {

    /**

     * @dev Handles the receipt of a single ERC1155 token type. This function is

     * called at the end of a `safeTransferFrom` after the balance has been updated.

     *

     * NOTE: To accept the transfer, this must return

     * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`

     * (i.e. 0xf23a6e61, or its own function selector).

     *

     * @param operator The address which initiated the transfer (i.e. msg.sender)

     * @param from The address which previously owned the token

     * @param id The ID of the token being transferred

     * @param value The amount of tokens being transferred

     * @param data Additional data with no specified format

     * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed

     */

    function onERC1155Received(

        address operator,

        address from,

        uint256 id,

        uint256 value,

        bytes calldata data

    ) external returns (bytes4);



    /**

     * @dev Handles the receipt of a multiple ERC1155 token types. This function

     * is called at the end of a `safeBatchTransferFrom` after the balances have

     * been updated.

     *

     * NOTE: To accept the transfer(s), this must return

     * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`

     * (i.e. 0xbc197c81, or its own function selector).

     *

     * @param operator The address which initiated the batch transfer (i.e. msg.sender)

     * @param from The address which previously owned the token

     * @param ids An array containing ids of each token being transferred (order and length must match values array)

     * @param values An array containing amounts of each token being transferred (order and length must match ids array)

     * @param data Additional data with no specified format

     * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed

     */

    function onERC1155BatchReceived(

        address operator,

        address from,

        uint256[] calldata ids,

        uint256[] calldata values,

        bytes calldata data

    ) external returns (bytes4);

}



// File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol





// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)



pragma solidity ^0.8.0;





/**

 * @dev Required interface of an ERC1155 compliant contract, as defined in the

 * https://eips.ethereum.org/EIPS/eip-1155[EIP].

 *

 * _Available since v3.1._

 */

interface IERC1155 is IERC165 {

    /**

     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.

     */

    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);



    /**

     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all

     * transfers.

     */

    event TransferBatch(

        address indexed operator,

        address indexed from,

        address indexed to,

        uint256[] ids,

        uint256[] values

    );



    /**

     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to

     * `approved`.

     */

    event ApprovalForAll(address indexed account, address indexed operator, bool approved);



    /**

     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.

     *

     * If an {URI} event was emitted for `id`, the standard

     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value

     * returned by {IERC1155MetadataURI-uri}.

     */

    event URI(string value, uint256 indexed id);



    /**

     * @dev Returns the amount of tokens of token type `id` owned by `account`.

     *

     * Requirements:

     *

     * - `account` cannot be the zero address.

     */

    function balanceOf(address account, uint256 id) external view returns (uint256);



    /**

     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.

     *

     * Requirements:

     *

     * - `accounts` and `ids` must have the same length.

     */

    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)

        external

        view

        returns (uint256[] memory);



    /**

     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,

     *

     * Emits an {ApprovalForAll} event.

     *

     * Requirements:

     *

     * - `operator` cannot be the caller.

     */

    function setApprovalForAll(address operator, bool approved) external;



    /**

     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.

     *

     * See {setApprovalForAll}.

     */

    function isApprovedForAll(address account, address operator) external view returns (bool);



    /**

     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.

     *

     * Emits a {TransferSingle} event.

     *

     * Requirements:

     *

     * - `to` cannot be the zero address.

     * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.

     * - `from` must have a balance of tokens of type `id` of at least `amount`.

     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the

     * acceptance magic value.

     */

    function safeTransferFrom(

        address from,

        address to,

        uint256 id,

        uint256 amount,

        bytes calldata data

    ) external;



    /**

     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.

     *

     * Emits a {TransferBatch} event.

     *

     * Requirements:

     *

     * - `ids` and `amounts` must have the same length.

     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the

     * acceptance magic value.

     */

    function safeBatchTransferFrom(

        address from,

        address to,

        uint256[] calldata ids,

        uint256[] calldata amounts,

        bytes calldata data

    ) external;

}



// File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol





// OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)



pragma solidity ^0.8.0;





/**

 * @dev Interface of the optional ERC1155MetadataExtension interface, as defined

 * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].

 *

 * _Available since v3.1._

 */

interface IERC1155MetadataURI is IERC1155 {

    /**

     * @dev Returns the URI for token type `id`.

     *

     * If the `\{id\}` substring is present in the URI, it must be replaced by

     * clients with the actual token type ID.

     */

    function uri(uint256 id) external view returns (string memory);

}



// File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol





// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)



pragma solidity ^0.8.0;















/**

 * @dev Implementation of the basic standard multi-token.

 * See https://eips.ethereum.org/EIPS/eip-1155

 * Originally based on code by Enjin: https://github.com/enjin/erc-1155

 *

 * _Available since v3.1._

 */

contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {

    using Address for address;



    // Mapping from token ID to account balances

    mapping(uint256 => mapping(address => uint256)) private _balances;



    // Mapping from account to operator approvals

    mapping(address => mapping(address => bool)) private _operatorApprovals;



    // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json

    string private _uri;



    /**

     * @dev See {_setURI}.

     */

    constructor(string memory uri_) {

        _setURI(uri_);

    }



    /**

     * @dev See {IERC165-supportsInterface}.

     */

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {

        return

            interfaceId == type(IERC1155).interfaceId ||

            interfaceId == type(IERC1155MetadataURI).interfaceId ||

            super.supportsInterface(interfaceId);

    }



    /**

     * @dev See {IERC1155MetadataURI-uri}.

     *

     * This implementation returns the same URI for *all* token types. It relies

     * on the token type ID substitution mechanism

     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].

     *

     * Clients calling this function must replace the `\{id\}` substring with the

     * actual token type ID.

     */

    function uri(uint256) public view virtual override returns (string memory) {

        return _uri;

    }



    /**

     * @dev See {IERC1155-balanceOf}.

     *

     * Requirements:

     *

     * - `account` cannot be the zero address.

     */

    function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {

        require(account != address(0), "ERC1155: address zero is not a valid owner");

        return _balances[id][account];

    }



    /**

     * @dev See {IERC1155-balanceOfBatch}.

     *

     * Requirements:

     *

     * - `accounts` and `ids` must have the same length.

     */

    function balanceOfBatch(address[] memory accounts, uint256[] memory ids)

        public

        view

        virtual

        override

        returns (uint256[] memory)

    {

        require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");



        uint256[] memory batchBalances = new uint256[](accounts.length);



        for (uint256 i = 0; i < accounts.length; ++i) {

            batchBalances[i] = balanceOf(accounts[i], ids[i]);

        }



        return batchBalances;

    }



    /**

     * @dev See {IERC1155-setApprovalForAll}.

     */

    function setApprovalForAll(address operator, bool approved) public virtual override {

        _setApprovalForAll(_msgSender(), operator, approved);

    }



    /**

     * @dev See {IERC1155-isApprovedForAll}.

     */

    function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {

        return _operatorApprovals[account][operator];

    }



    /**

     * @dev See {IERC1155-safeTransferFrom}.

     */

    function safeTransferFrom(

        address from,

        address to,

        uint256 id,

        uint256 amount,

        bytes memory data

    ) public virtual override {

        require(

            from == _msgSender() || isApprovedForAll(from, _msgSender()),

            "ERC1155: caller is not token owner nor approved"

        );

        _safeTransferFrom(from, to, id, amount, data);

    }



    /**

     * @dev See {IERC1155-safeBatchTransferFrom}.

     */

    function safeBatchTransferFrom(

        address from,

        address to,

        uint256[] memory ids,

        uint256[] memory amounts,

        bytes memory data

    ) public virtual override {

        require(

            from == _msgSender() || isApprovedForAll(from, _msgSender()),

            "ERC1155: caller is not token owner nor approved"

        );

        _safeBatchTransferFrom(from, to, ids, amounts, data);

    }



    /**

     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.

     *

     * Emits a {TransferSingle} event.

     *

     * Requirements:

     *

     * - `to` cannot be the zero address.

     * - `from` must have a balance of tokens of type `id` of at least `amount`.

     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the

     * acceptance magic value.

     */

    function _safeTransferFrom(

        address from,

        address to,

        uint256 id,

        uint256 amount,

        bytes memory data

    ) internal virtual {

        require(to != address(0), "ERC1155: transfer to the zero address");



        address operator = _msgSender();

        uint256[] memory ids = _asSingletonArray(id);

        uint256[] memory amounts = _asSingletonArray(amount);



        _beforeTokenTransfer(operator, from, to, ids, amounts, data);



        uint256 fromBalance = _balances[id][from];

        require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");

        unchecked {

            _balances[id][from] = fromBalance - amount;

        }

        _balances[id][to] += amount;



        emit TransferSingle(operator, from, to, id, amount);



        _afterTokenTransfer(operator, from, to, ids, amounts, data);



        _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);

    }



    /**

     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.

     *

     * Emits a {TransferBatch} event.

     *

     * Requirements:

     *

     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the

     * acceptance magic value.

     */

    function _safeBatchTransferFrom(

        address from,

        address to,

        uint256[] memory ids,

        uint256[] memory amounts,

        bytes memory data

    ) internal virtual {

        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");

        require(to != address(0), "ERC1155: transfer to the zero address");



        address operator = _msgSender();



        _beforeTokenTransfer(operator, from, to, ids, amounts, data);



        for (uint256 i = 0; i < ids.length; ++i) {

            uint256 id = ids[i];

            uint256 amount = amounts[i];



            uint256 fromBalance = _balances[id][from];

            require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");

            unchecked {

                _balances[id][from] = fromBalance - amount;

            }

            _balances[id][to] += amount;

        }



        emit TransferBatch(operator, from, to, ids, amounts);



        _afterTokenTransfer(operator, from, to, ids, amounts, data);



        _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);

    }



    /**

     * @dev Sets a new URI for all token types, by relying on the token type ID

     * substitution mechanism

     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].

     *

     * By this mechanism, any occurrence of the `\{id\}` substring in either the

     * URI or any of the amounts in the JSON file at said URI will be replaced by

     * clients with the token type ID.

     *

     * For example, the `https://token-cdn-domain/\{id\}.json` URI would be

     * interpreted by clients as

     * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`

     * for token type ID 0x4cce0.

     *

     * See {uri}.

     *

     * Because these URIs cannot be meaningfully represented by the {URI} event,

     * this function emits no events.

     */

    function _setURI(string memory newuri) internal virtual {

        _uri = newuri;

    }



    /**

     * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.

     *

     * Emits a {TransferSingle} event.

     *

     * Requirements:

     *

     * - `to` cannot be the zero address.

     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the

     * acceptance magic value.

     */

    function _mint(

        address to,

        uint256 id,

        uint256 amount,

        bytes memory data

    ) internal virtual {

        require(to != address(0), "ERC1155: mint to the zero address");



        address operator = _msgSender();

        uint256[] memory ids = _asSingletonArray(id);

        uint256[] memory amounts = _asSingletonArray(amount);



        _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);



        _balances[id][to] += amount;

        emit TransferSingle(operator, address(0), to, id, amount);



        _afterTokenTransfer(operator, address(0), to, ids, amounts, data);



        _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);

    }



    /**

     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.

     *

     * Emits a {TransferBatch} event.

     *

     * Requirements:

     *

     * - `ids` and `amounts` must have the same length.

     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the

     * acceptance magic value.

     */

    function _mintBatch(

        address to,

        uint256[] memory ids,

        uint256[] memory amounts,

        bytes memory data

    ) internal virtual {

        require(to != address(0), "ERC1155: mint to the zero address");

        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");



        address operator = _msgSender();



        _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);



        for (uint256 i = 0; i < ids.length; i++) {

            _balances[ids[i]][to] += amounts[i];

        }



        emit TransferBatch(operator, address(0), to, ids, amounts);



        _afterTokenTransfer(operator, address(0), to, ids, amounts, data);



        _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);

    }



    /**

     * @dev Destroys `amount` tokens of token type `id` from `from`

     *

     * Emits a {TransferSingle} event.

     *

     * Requirements:

     *

     * - `from` cannot be the zero address.

     * - `from` must have at least `amount` tokens of token type `id`.

     */

    function _burn(

        address from,

        uint256 id,

        uint256 amount

    ) internal virtual {

        require(from != address(0), "ERC1155: burn from the zero address");



        address operator = _msgSender();

        uint256[] memory ids = _asSingletonArray(id);

        uint256[] memory amounts = _asSingletonArray(amount);



        _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");



        uint256 fromBalance = _balances[id][from];

        require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");

        unchecked {

            _balances[id][from] = fromBalance - amount;

        }



        emit TransferSingle(operator, from, address(0), id, amount);



        _afterTokenTransfer(operator, from, address(0), ids, amounts, "");

    }



    /**

     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.

     *

     * Emits a {TransferBatch} event.

     *

     * Requirements:

     *

     * - `ids` and `amounts` must have the same length.

     */

    function _burnBatch(

        address from,

        uint256[] memory ids,

        uint256[] memory amounts

    ) internal virtual {

        require(from != address(0), "ERC1155: burn from the zero address");

        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");



        address operator = _msgSender();



        _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");



        for (uint256 i = 0; i < ids.length; i++) {

            uint256 id = ids[i];

            uint256 amount = amounts[i];



            uint256 fromBalance = _balances[id][from];

            require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");

            unchecked {

                _balances[id][from] = fromBalance - amount;

            }

        }



        emit TransferBatch(operator, from, address(0), ids, amounts);



        _afterTokenTransfer(operator, from, address(0), ids, amounts, "");

    }



    /**

     * @dev Approve `operator` to operate on all of `owner` tokens

     *

     * Emits an {ApprovalForAll} event.

     */

    function _setApprovalForAll(

        address owner,

        address operator,

        bool approved

    ) internal virtual {

        require(owner != operator, "ERC1155: setting approval status for self");

        _operatorApprovals[owner][operator] = approved;

        emit ApprovalForAll(owner, operator, approved);

    }



    /**

     * @dev Hook that is called before any token transfer. This includes minting

     * and burning, as well as batched variants.

     *

     * The same hook is called on both single and batched variants. For single

     * transfers, the length of the `ids` and `amounts` arrays will be 1.

     *

     * Calling conditions (for each `id` and `amount` pair):

     *

     * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens

     * of token type `id` will be  transferred to `to`.

     * - When `from` is zero, `amount` tokens of token type `id` will be minted

     * for `to`.

     * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`

     * will be burned.

     * - `from` and `to` are never both zero.

     * - `ids` and `amounts` have the same, non-zero length.

     *

     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].

     */

    function _beforeTokenTransfer(

        address operator,

        address from,

        address to,

        uint256[] memory ids,

        uint256[] memory amounts,

        bytes memory data

    ) internal virtual {}



    /**

     * @dev Hook that is called after any token transfer. This includes minting

     * and burning, as well as batched variants.

     *

     * The same hook is called on both single and batched variants. For single

     * transfers, the length of the `id` and `amount` arrays will be 1.

     *

     * Calling conditions (for each `id` and `amount` pair):

     *

     * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens

     * of token type `id` will be  transferred to `to`.

     * - When `from` is zero, `amount` tokens of token type `id` will be minted

     * for `to`.

     * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`

     * will be burned.

     * - `from` and `to` are never both zero.

     * - `ids` and `amounts` have the same, non-zero length.

     *

     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].

     */

    function _afterTokenTransfer(

        address operator,

        address from,

        address to,

        uint256[] memory ids,

        uint256[] memory amounts,

        bytes memory data

    ) internal virtual {}



    function _doSafeTransferAcceptanceCheck(

        address operator,

        address from,

        address to,

        uint256 id,

        uint256 amount,

        bytes memory data

    ) private {

        if (to.isContract()) {

            try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {

                if (response != IERC1155Receiver.onERC1155Received.selector) {

                    revert("ERC1155: ERC1155Receiver rejected tokens");

                }

            } catch Error(string memory reason) {

                revert(reason);

            } catch {

                revert("ERC1155: transfer to non ERC1155Receiver implementer");

            }

        }

    }



    function _doSafeBatchTransferAcceptanceCheck(

        address operator,

        address from,

        address to,

        uint256[] memory ids,

        uint256[] memory amounts,

        bytes memory data

    ) private {

        if (to.isContract()) {

            try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (

                bytes4 response

            ) {

                if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {

                    revert("ERC1155: ERC1155Receiver rejected tokens");

                }

            } catch Error(string memory reason) {

                revert(reason);

            } catch {

                revert("ERC1155: transfer to non ERC1155Receiver implementer");

            }

        }

    }



    function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {

        uint256[] memory array = new uint256[](1);

        array[0] = element;



        return array;

    }

}



// File: contracts/Pod.sol





pragma solidity ^0.8.16;



contract Asset {

    function fatesAssetTransfer(uint256 _id, address _to) public {}

}



contract Pod is

    ERC1155,

    AccessControl,

    Ownable,

    RevokableDefaultOperatorFilterer,

    ERC2981ContractWideRoyalties

{

    string public name; // Token name.

    string public symbol; // Shorthand identifer.

    string public contractURI_; // Link to contract-level metadata.

    string public baseURI; // Base domain.

    string public launchedURI; // Launched token's metadata.

    string public unlaunchedURI; // Unlaunched token's metadata.

    uint256 public royalty; // Royalty % 10000 = 100%.

    uint256 public expiry = 3600;

    bool public paused = false; // Revert calls to critical funcs.

    bool internal locked; // Switch to prevent reentrancy attack.



    struct TokenIds {

        uint256 aId;

        uint256 cId;

        uint256 expiresAt;

        bool listed;

    }



    // Stop >1 of same address per allowlist slot

    mapping(address => bool) public allowlistValve;

    // Tokens requiring unique IDs.

    mapping(uint256 => bool) public uid;

    // Mapping pod IDs to corresponding pilot addresses.

    mapping(uint256 => address) public allowList;

    // Prevent >1 token per pilot.

    mapping(address => bool) public launchClearance;

    // Mapping pod assigned pilots to exodus assets.

    mapping(address => TokenIds) launchList;

    // pod state tracker.

    mapping(uint256 => bool) private launchStatus;



    // Contracts pod will interact with.

    Asset private astrContract;

    Asset private charContract;



    // Distributor role.

    bytes32 public constant DISTRIBUTOR = keccak256("DISTRIBUTOR");



    constructor(

        address _root,

        address _distributor,

        address _astrContract,

        address _charContract,

        string memory _name,

        string memory _symbol,

        string memory _contractURI,

        string memory _baseURI,

        string memory _launchedURI,

        string memory _unlaunchedURI,

        uint256 _royalty

    ) ERC1155(baseURI) {

        _setupRole(DEFAULT_ADMIN_ROLE, _root);

        _setupRole(DISTRIBUTOR, _distributor);

        name = _name;

        symbol = _symbol;

        contractURI_ = _contractURI;

        baseURI = _baseURI;

        launchedURI = _launchedURI;

        unlaunchedURI = _unlaunchedURI;

        royalty = _royalty;

        astrContract = Asset(_astrContract);

        charContract = Asset(_charContract);

    }



    /*

     * @dev

     *      Modifier restricts func calls to addresses under admin role only.

     */

    modifier onlyAdmin() {

        require(

            hasRole(DEFAULT_ADMIN_ROLE, msg.sender),

            "Restricted to admins."

        );

        _;

    }



    /*

     * @dev

     *      Modifier used to lock external functions until fully executed.

     */

    modifier noReentrant() {

        require(!locked, "No recursive calls.");

        locked = true;

        _;

        locked = false;

    }



    /*

     * @dev

     *      Write contract activity switch.

     * @params

     *      _paused - Boolean state change.

     */

    function setPaused(bool _paused) external onlyAdmin {

        paused = _paused;

    }



    /*

     * @dev

     *      Read collection-level metadata.

     */

    function contractURI() public view returns (string memory) {

        return contractURI_;

    }



    /*

     * @dev

     *      Write collection-level metadata.

     * @params

     *      _contracturi - Link to contract-level JSON metadata.

     */

    function setContractURI(string memory _contracturi) external onlyAdmin {

        contractURI_ = _contracturi;

    }



    /*

     * @dev

     *      Set expiry time for buying a token.

     * @params

     *      _expiry - In seconds, 3600 default.

     */

    function setExpiry(uint256 _expiry) external onlyAdmin {

        expiry = _expiry;

    }



    /*

     * @dev

     *      Read royalty fee set.

     */

    function getRoyaltyFee() public view returns (uint256) {

        return royalty;

    }



    /*

     * @dev

     *      Write royalty fee.

     * @params

     *      _recipient - Target address to receive the royalty fee.

     *      _value - Basis point royalty %.

     */

    function setRoyalties(address _recipient, uint256 _value)

        external

        onlyAdmin

    {

        _setRoyalties(_recipient, _value);

    }



    /*

     * @dev

     *      Add pilot address to the allowList against token ID.

     * @params

     *      _id - ID of tokens to be minted.

     *      _pilot - Pilot to allow listed.

     */

    function addToAllowList(uint256 _id, address _pilot)

        external

        onlyRole(DISTRIBUTOR)

    {

        // Pod must not already have been claimed.

        require(uid[_id] == false, "Pod already claimed.");

        // Pilot must not have already been allocated a Pod.

        require(allowlistValve[_pilot] == false, "Address already listed.");

        // No more than once whilst on allow list at any one time.

        allowlistValve[_pilot] = true;

        // Add to allow list.

        allowList[_id] = _pilot;

    }



    /*

     * @dev

     *      Remove pilot address from the allow list against token ID.

     *      Also resets the pilot to be able to engage in the evac process again.

     * @params

     *      _id - ID of token to remove.

     *      _pilot - Pilot address to remove.

     */

    function removeFromAllowList(uint256 _id, address _pilot)

        external

        onlyRole(DISTRIBUTOR)

    {

        require(allowlistValve[_pilot] == true, "Address not allocated a pod.");

        allowlistValve[_pilot] = false;

        delete allowList[_id];

    }



    /*

     * @dev

     *      Check an account is on the allowList.

     * @params

     *      _id - ID of token to check as listed.

     *      _pilot - Pilot address to check as listed.

     */

    function isAllowListed(uint256 _id, address _pilot)

        public

        view

        returns (bool)

    {

        bool pilotIsAllowListed = false;

        if (allowList[_id] == _pilot) {

            pilotIsAllowListed = true;

        }

        return pilotIsAllowListed;

    }



    /*

     * @dev

     *      Claim evac pod.

     * @params

     *      _id - ID of tokens to be minted.

     */

    function evacPodClaim(uint256 _id) external noReentrant {

        // Required on public funcs that alter state.

        require(!paused, "Exodus is on hold.");



        // Pod must be non-fungible.

        require(uid[_id] == false, "Pod already claimed.");



        address pilot = msg.sender;

        // Pilot must be on allowListed for token id.

        require(allowList[_id] == pilot, "Address is not listed for this pod.");

        // Ensure pilot address has not launched.

        require(launchClearance[pilot] == false, "Address already owns a pod.");



        // Pilot now cleared for launch.

        launchClearance[pilot] = true;



        // Pod ID claimed.

        uid[_id] = true;



        // Allocate to pilot.

        _mint(pilot, _id, 1, bytes(""));

    }



    /*

     * @dev

     *      Add pilot to launch list.

     * @params

     *      _podId - Id of pod to launch.

     *      _charId - Id of character to allocate.

     *      _astrId - Id of asteroid to allocate.

     */

    function addToLaunchList(

        address _pilot,

        uint256 _charId,

        uint256 _astrId

    ) external onlyRole(DISTRIBUTOR) {

        // Ensure pilot address has not launched.

        require(launchClearance[_pilot] == true, "Address doesn't own a pod.");



        // Ensures the same pilot cannot be allocated twice.

        require(

            launchList[_pilot].listed == false,

            "Address doesn't own a pod."

        );



        launchList[_pilot] = TokenIds(

            _astrId,

            _charId,

            block.timestamp + expiry,

            true

        );

    }



    /*

     * @dev

     *      Remove pilot addresses from the allowList against token IDs.

     * @params

     *      _pilot - Pilot address to remove from launchList.

     */

    function removeFromLaunchList(address _pilot)

        external

        onlyRole(DISTRIBUTOR)

    {

        delete launchList[_pilot];

    }



    /*

     * @dev

     *      Check an account is on the launchList.

     * @params

     *      _pilot - Pilot address to check against launchList.

     */

    function isLaunchListed(address _pilot) public view returns (bool) {

        bool pilotLaunchListed = false;



        if (

            launchList[_pilot].listed == true &&

            block.timestamp <= launchList[_pilot].expiresAt

        ) {

            pilotLaunchListed = true;

        }

        return pilotLaunchListed;

    }



    /*

     * @dev

     *       Set pilot's launch clearance.

     * @params

     *      _pilot - Pilot address to clear.

     *      _clearance - Cleared to launch or not.

     */

    function setLaunchClearance(address _pilot, bool _clearance)

        external

        onlyRole(DISTRIBUTOR)

    {

        launchClearance[_pilot] = _clearance;

    }



    /*

     * @dev

     *      Launch pod.

     * @params

     *      _id - Ids of pod to launch.

     */

    function _launchPod(uint256 _id) private {

        require(!launchStatus[_id]);

        launchStatus[_id] = true;

    }



    /*

     * @dev

     *      Launch pod, simultaneously allocating correspoinding assets.

     * @params

     *      _podId - Id of pod to launch.

     *      _charId - Id of character to allocate.

     *      _astrId - Id of asteroid to allocate.

     */

    function evacPodLaunch(

        uint256 _podId,

        uint256 _charId,

        uint256 _astrId

    ) external noReentrant {

        // Required on public funcs that alter state.

        require(!paused, "Exodus is on hold.");



        // Set pilot.

        address pilot = msg.sender;



        // launchList IDs must match pilots assigned _astrId and _charId.

        require(

            launchList[pilot].aId == _astrId,

            "Asteroid not assigned to pilot."

        );

        require(

            launchList[pilot].cId == _charId,

            "Character not assigned to pilot."

        );

        // launchList entry must not have expired.

        require(

            block.timestamp <= launchList[pilot].expiresAt,

            "List entry expired."

        );



        // Check Pilot is cleared for launch.

        require(

            launchClearance[pilot] == true,

            "Pod is not cleared for launch."

        );

        require(launchStatus[_podId] == false, "Failure to launch.");



        // Launch pod.

        _launchPod(_podId);

        // Distribute assets to pilot.

        astrContract.fatesAssetTransfer(_astrId, pilot);

        charContract.fatesAssetTransfer(_charId, pilot);

    }



    /*

     * @dev

     *      Check a pod's launch status.

     * @params

     *      _id - Id of pod.

     */

    function hasLaunched(uint256 _id) public view returns (bool) {

        return launchStatus[_id];

    }



    /*

     * @dev

     *      Read the URI to a pod's metadata.

     * @params

     *      _id - Id of pod.

     */

    function uri(uint256 _id) public view override returns (string memory) {

        if (launchStatus[_id] == true) {

            return string(abi.encodePacked(baseURI, launchedURI));

        }

        return string(abi.encodePacked(baseURI, unlaunchedURI));

    }



    /*

     * @dev

     *      Write the base URI to a pod's metadata.

     * @params

     *      _uri - Base domain (w/o trailing slash).

     */

    function setBaseURI(string memory _baseuri) external onlyAdmin {

        baseURI = _baseuri;

    }



    /*

     * @dev

     *      Write the launched URI to a pod's metadata.

     *      Note: Can use the ERC1155 {id}, per-token substitution.

     * @params

     *      _suffix - Suffix link to launched state metadata JSON file (with trailing slash).

     */

    function setLaunchedURI(string memory _suffix) external onlyAdmin {

        launchedURI = _suffix;

    }



    /*

     * @dev

     *      Write the launched URI to a pod's metadata.

     *      Note: Can use the ERC1155 {id}, per-token substitution.

     * @params

     *      _suffix - Suffix link to unlaunched state metadata JSON file (with trailing slash).

     */

    function setUnLaunchedURI(string memory _suffix) external onlyAdmin {

        unlaunchedURI = _suffix;

    }



    /*

     * @dev

     *      Ensure marketplaces don't bypass creator royalty.

     */

    function setApprovalForAll(address operator, bool approved)

        public

        override

        onlyAllowedOperatorApproval(operator)

    {

        super.setApprovalForAll(operator, approved);

    }



    function safeTransferFrom(

        address from,

        address to,

        uint256 tokenId,

        uint256 amount,

        bytes memory data

    ) public override onlyAllowedOperator(from) {

        super.safeTransferFrom(from, to, tokenId, amount, data);

    }



    function safeBatchTransferFrom(

        address from,

        address to,

        uint256[] memory ids,

        uint256[] memory amounts,

        bytes memory data

    ) public virtual override onlyAllowedOperator(from) {

        super.safeBatchTransferFrom(from, to, ids, amounts, data);

    }



    function owner()

        public

        view

        virtual

        override(Ownable, RevokableOperatorFilterer)

        returns (address)

    {

        return Ownable.owner();

    }



    function supportsInterface(bytes4 interfaceId)

        public

        view

        virtual

        override(ERC1155, AccessControl, ERC2981Base)

        returns (bool)

    {

        return super.supportsInterface(interfaceId);

    }

}