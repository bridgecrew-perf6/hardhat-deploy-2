//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "./ERC721Staked.sol";

contract SBlock is ERC721Staked {

  uint256 public constant DEFAULT_LOCK_DURATION = 60 * 1; // 6 mins

  uint256 public constant MINT_ROLE = 1;
  uint256 public constant BURN_ROLE = 2;
  //uint256 public constant TRANSFER_ROLE = 3;
  uint256 n = 0;

  mapping(uint256 => uint256) public lockDurations;
  mapping(uint256 => Lease) private leases;

  struct Lease {
    address provenance;
    uint48 lockExpiration;
  }

string internal _baseTokenURI;

  constructor (string memory baseTokenURI) ERC721("sBlockForge","sBKLF") {
    _baseTokenURI = baseTokenURI;
  }

  function mint(address to, uint256 tokenId)
    external
    virtual
    override
    nonReentrant
    onlyDelegate(MINT_ROLE)
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

 function revoke(uint256 tokenId) external virtual override {
    address provenance = leases[tokenId].provenance;
    require(provenance == msg.sender, "Caller is not provenance");
    _transfer(ownerOf(tokenId), provenance, tokenId);
  }


 function setBaseURI(string memory baseTokenURI) external onlyOwner {
   _baseTokenURI = baseTokenURI;

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
