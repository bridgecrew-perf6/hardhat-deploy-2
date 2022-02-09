//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IERC721Staked is IERC721 {
  function burn(uint256 tokenId) external;

  function mint(address to, uint256 tokenId) external;

//  function revoke(uint256 tokenId) external;

  //function setLockDuration(uint256 tokenId, uint256 lockDuration) external;
}
