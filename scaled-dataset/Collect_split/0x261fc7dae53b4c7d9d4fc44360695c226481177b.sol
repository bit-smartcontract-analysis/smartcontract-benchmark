// SPDX-License-Identifier: MIT



pragma solidity ^0.8.0;



/*

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





/**

 * @dev External interface of AccessControl declared to support ERC165 detection.

 */

interface IAccessControl {

    function hasRole(bytes32 role, address account) external view returns (bool);



    function getRoleAdmin(bytes32 role) external view returns (bytes32);



    function grantRole(bytes32 role, address account) external;



    function revokeRole(bytes32 role, address account) external;



    function renounceRole(bytes32 role, address account) external;

}



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

     * bearer except when using {_setupRole}.

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

     * @dev Modifier that checks that an account has a specific role. Reverts

     * with a standardized message including the required role.

     *

     * The format of the revert reason is given by the following regular expression:

     *

     *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/

     *

     * _Available since v4.1._

     */

    modifier onlyRole(bytes32 role) {

        _checkRole(role, _msgSender());

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

    function hasRole(bytes32 role, address account) public view override returns (bool) {

        return _roles[role].members[account];

    }



    /**

     * @dev Revert with a standard message if `account` is missing `role`.

     *

     * The format of the revert reason is given by the following regular expression:

     *

     *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/

     */

    function _checkRole(bytes32 role, address account) internal view {

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

    function getRoleAdmin(bytes32 role) public view override returns (bytes32) {

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

     * If the calling account had been granted `role`, emits a {RoleRevoked}

     * event.

     *

     * Requirements:

     *

     * - the caller must be `account`.

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

     * [WARNING]

     * ====

     * This function should only be called from the constructor when setting

     * up the initial roles for the system.

     *

     * Using this function in any other way is effectively circumventing the admin

     * system imposed by {AccessControl}.

     * ====

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

        emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);

        _roles[role].adminRole = adminRole;

    }



    function _grantRole(bytes32 role, address account) private {

        if (!hasRole(role, account)) {

            _roles[role].members[account] = true;

            emit RoleGranted(role, account, _msgSender());

        }

    }



    function _revokeRole(bytes32 role, address account) private {

        if (hasRole(role, account)) {

            _roles[role].members[account] = false;

            emit RoleRevoked(role, account, _msgSender());

        }

    }

}



interface CrazyBunnyIF {

    function mintNextToken(address _mintTo) external returns (bool);

    function mint(address _mintTo, uint256 _tokenId) external returns (bool);

    function getCurrentTokenId() external view returns (uint256);

    function totalSupply() external view returns (uint256);

    function cap() external view returns (uint256);

}

 

 

contract CrazyBunnyDistributor is AccessControl {

    

    CrazyBunnyIF cbToken;



    uint256 public tokenPrice = uint256(6 * 10**16); // = 0.06 ETH

    address public withdrawWallet;



    bytes32 public constant TOGGLE_MINTING_ROLE = keccak256("TOGGLE_MINTING_ROLE");

    bool public _mintingPaused = false;



    address public upgradedToAddress = address(0);



    mapping(address => bool) public whiteList;

    bool public whitelistOnly = true;



    mapping(address => uint256) public totalMintsPerAddress;



    



    constructor(CrazyBunnyIF _cbToken) {

        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);

        _setupRole(TOGGLE_MINTING_ROLE, msg.sender);



        withdrawWallet = msg.sender;



        cbToken = _cbToken;

    }



    function upgrade(address _upgradedToAddress) public {

        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Caller is not a admin");

        

        upgradedToAddress = _upgradedToAddress;

    }



    function mint(uint256 _num) public payable returns (bool) {

        require(address(0) == upgradedToAddress, "Contract has been upgraded to a new address");

        require(whiteList[msg.sender] || !whitelistOnly, "ONLY WHITELIST"); //either on whitelist or whitelist is false



        require(whitelistOnly || (!whitelistOnly && _num <= 20), "You can mint a maximum of 20 at once");//whitelist is false, and you can max mint 20 at a time

        require(!whitelistOnly || (whitelistOnly && totalMintsPerAddress[msg.sender] + _num <= 10), "You can mint a maximum of 10 when whitelist enabled");//whitelist is true, and you can max mint 20 per address

        

        require(msg.value >= (tokenPrice * _num), "Insufficient amount provided");

        require(!_mintingPaused, "Minting paused");



        uint256 tokenId = cbToken.getCurrentTokenId();

        require(tokenId + _num < 10000, "Maximum cap of 10k mints reached");



        totalMintsPerAddress[msg.sender] += _num; //log the total mints per address



        for(uint256 i; i < _num; i++){

            cbToken.mintNextToken(msg.sender);//, tokenId + i + 1

        }

        return true;

    }





    function giveAway(address _to, uint256 _amount) external {

        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Caller is not a admin");



        uint256 supply = cbToken.totalSupply();



        require( supply + _amount <= cbToken.cap(), "Cap reached, maximum 10000 mints possible");



        for(uint256 i; i < _amount; i++){

            cbToken.mintNextToken(_to);

        }

    }



    fallback() external payable {}

    receive() external payable {}





    // admin functions

    function withdrawAll() public {

        uint256 _each = address(this).balance;

        require(payable(withdrawWallet).send(_each));

    }



    function updateWithdrawWallet(address _newWallet) public {

        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not admin");



        withdrawWallet = _newWallet;

    }



    function togglePause(bool _pause) public {

        require(hasRole(TOGGLE_MINTING_ROLE, msg.sender), "Caller is not TOGGLE_MINTING_ROLE");

        require(_mintingPaused != _pause, "Already in desired pause state");



        _mintingPaused = _pause;

    }



    function updatePrice(uint256 _newPrice) public {

        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not admin");



        tokenPrice = _newPrice;

    }



    //whitelist

    function addToWhiteList(address[] calldata entries) external {

        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not admin");



        for(uint256 i = 0; i < entries.length; i++) {

            address entry = entries[i];

            require(entry != address(0), "Cannot add zero address");

            require(!whiteList[entry], "Cannot add duplicate address");



            whiteList[entry] = true;

        }   

    }



    function removeFromWhiteList(address[] calldata entries) external {

        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not admin");



        for(uint256 i = 0; i < entries.length; i++) {

            address entry = entries[i];

            require(entry != address(0), "Cannot remove zero address");

            

            whiteList[entry] = false;

        }

    }



    function toggleWhiteListOnly(bool _whitelistOnly) external {

        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not admin");



        whitelistOnly = _whitelistOnly;

    }

    

    function isOnWhiteList(address addr) external view returns (bool) {

        return whiteList[addr];

    }







    



}