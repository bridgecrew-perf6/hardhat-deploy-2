//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "./ERC721Staked.sol";


contract SBlock is ERC721Staked {

string internal _baseTokenURI;

  constructor (string memory baseTokenURI) ERC721("sBlockForge","sBKLF") {
    _baseTokenURI = baseTokenURI;
  }

  function mint(address to, uint256 tokenId)
    external
    virtual
    override
    nonReentrant
  {
    _safeMint(to, tokenId);
  }


}
