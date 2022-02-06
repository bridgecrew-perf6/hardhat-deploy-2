//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC721Staked.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

abstract contract ERC721Staked is
  IERC721Staked,
  ERC721,
  ReentrancyGuardUpgradeable
{

  /*
  WRITE FUNCTIONS
  */

  function mint(address to, uint256 tokenId)
    external
    virtual
    override
    nonReentrant
  {
    _safeMint(to, tokenId);
  }

}
