//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "./ERC721Staked.sol";


 abstract contract SBlock is ERC721Staked {

string internal _baseTokenURI;

  constructor (string memory baseTokenURI) ERC721("sBlockForge","sBKLF") {
    _baseTokenURI = baseTokenURI;
  }

  /* function mint(address to, uint256 tokenId)
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
 } */

 function setBaseURI(string memory baseTokenURI) external onlyOwner {
   _baseTokenURI = baseTokenURI;

}

}
