//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "./ERC721Staked.sol";

contract SBlock is ERC721Staked {

  string internal _baseTokenURI;

  constructor (string memory baseTokenURI) ERC721("sBlockForge","sBKLF") {
    _baseTokenURI = baseTokenURI;
  }

  function _baseURI() internal view virtual override returns(string memory) {
    return _baseTokenURI;
  }

  function _setBaseURI(string memory baseTokenURI) external onlyOwner {
    _baseTokenURI = baseTokenURI;
  }

}
