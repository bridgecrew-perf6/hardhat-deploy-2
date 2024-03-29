//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC721Staked.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "./Delegatable.sol";
abstract contract ERC721Staked is
  IERC721Staked,
  ERC721,
  Delegatable,
  ReentrancyGuardUpgradeable
{
  uint256 public constant DEFAULT_LOCK_DURATION = 60 * 60 * 24 * 7; // 7 days

  uint256 public constant MINT_ROLE = 1;
  uint256 public constant BURN_ROLE = 2;
  uint256 public constant TRANSFER_ROLE = 3;

  mapping(uint256 => uint256) public lockDurations;
  mapping(uint256 => Lease) private leases;

  struct Lease {
    address provenance;
    uint48 lockExpiration;
  }

uint256 public constant MINT_ROLE = 1;
uint256 public constant BURN_ROLE = 2;

  /*
  WRITE FUNCTIONS
  */

  function mint(address to, uint256 tokenId)
    external
    virtual
    override
    onlyDelegate(MINT_ROLE)
    nonReentrant
  {
    _safeMint(to, tokenId);
  }

  function burn(uint256 tokenId)
   external
   virtual
   override
   onlyDelegate(BURN_ROLE)
 {
   _burn(tokenId);
 }

 function transferFrom(
   address from,
   address to,
   uint256 tokenId
 ) public virtual override(ERC721, IERC721) {
   address sender = _msgSender();
   require(
     _isApprovedOrOwner(sender, tokenId) || hasRoles(sender, TRANSFER_ROLE),
     "ERC721: transfer caller is not owner nor approved"
   );

   _transfer(from, to, tokenId);
 }

 function _beforeTokenTransfer(
    address from,
    address to,
    uint256 tokenId
  ) internal virtual override {
    super._beforeTokenTransfer(from, to, tokenId);

    // don't set lease on mint to save gas, getLease will handle lease
    // ownership
    if (from == address(0)) {
      return;
    }

    Lease memory lease = getLease(tokenId);
    // prevent lease owner from unstaking locked tokens
    require(
      msg.sender == from || block.timestamp >= uint256(lease.lockExpiration),
      "Token is locked in lease"
    );

    if (to == address(0)) {
      // remove lease on burn
      delete leases[tokenId];
    } else if (from != to) {
      if (from == lease.provenance) {
        // set lease lock on transfer from provenance to another
        uint256 lockDuration = getLockDuration(tokenId);
        leases[tokenId] = Lease(
          lease.provenance,
          uint48(block.timestamp + lockDuration)
        );
      } else if (to == lease.provenance) {
        // remove lock on transfer from another to provenance
        leases[tokenId] = Lease(lease.provenance, 0);
      }
    }
  }



  // Read Functions

  function getLease(uint256 tokenId) public view returns (Lease memory lease) {
   lease = leases[tokenId];
   // lease provenance is null and token exist only on initial mint
   if (lease.provenance == address(0) && _exists(tokenId)) {
     lease.provenance = ownerOf(tokenId);
   }
 }

  function getLockDuration(uint256 tokenId)
    public
    view
    returns (uint256 lockDuration)
  {
    lockDuration = lockDurations[tokenId];
    if (lockDuration == 0) {
      lockDuration = DEFAULT_LOCK_DURATION;
    }
  }

}
