//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @dev Contract module for delegating role based access control to acounts.
 * Roles are represented by bit flags.
 */
abstract contract Delegatable is Ownable {
  mapping(address => uint256) public delegates;

  event DelegateUpdated(address indexed delegate, uint256 indexed roles);
  // need to initialize ownable
  /*
  READ FUNCTIONS
  */
  function hasRoles(address delegate, uint256 roles)
    public
    view
    returns (bool)
  {
    return (delegates[delegate] & roles) == roles;
  }

  /*
  WRITE FUNCTIONS
  */

  function _setDelegate(address delegate, uint256 roles) private {
    delegates[delegate] = roles;
    emit DelegateUpdated(delegate, roles);
  }

  /*
  OWNER FUNCTIONS
  */

  function updateDelegate(address delegate, uint256 roles)
    public
    virtual
    onlyOwner
  {
    require(
      delegate != address(0),
      "Delegatable: new delegate is the zero address"
    );
    _setDelegate(delegate, roles);
  }

  function replaceDelegate(address oldDelegate, address newDelegate)
    external
    virtual
    onlyOwner
  {
    uint256 roles = delegates[oldDelegate];
    updateDelegate(oldDelegate, 0);
    updateDelegate(newDelegate, roles);
  }

  /*
  MODIFIER
  */

  modifier onlyDelegate(uint256 roles) {
    require(
      hasRoles(msg.sender, roles),
      "Delegatable: caller does not have correct roles"
    );
    _;
  }
}
