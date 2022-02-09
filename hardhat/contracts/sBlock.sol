//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "./ERC721Staked.sol";


contract sBlock is ERC721Staked {

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

}
