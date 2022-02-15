//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC721Staked.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "./access/Delegatable.sol";

abstract contract ERC721Staked is
  IERC721Staked,
  ERC721,
  Delegatable,
  ReentrancyGuardUpgradeable
{

uint256 public constant MINT_ROLE = 1;
uint256 public constant BURN_ROLE = 2;

  /*
  WRITE FUNCTIONS
  */

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
