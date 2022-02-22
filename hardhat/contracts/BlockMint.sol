// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./ERC721Stakable.sol";




/**
__________.__                 __   ___________
\______   \  |   ____   ____ |  | _\_   _____/______  ____   ____   ____
 |    |  _/  |  /  _ \_/ ___\|  |/ /|    __) \_  __ \/  _ \ / ___\_/ __ \
 |    |   \  |_(  <_> )  \___|    < |     \   |  | \(  <_> ) /_/  >  ___/
 |______  /____/\____/ \___  >__|_ \\___  /   |__|   \____/\___  / \___  >
        \/                 \/     \/    \/                /_____/      \/


credits to Critterz, Meebits and CosmicCaps contracts and teams
Cosmic Caps are fungi from far out in the shroomiverse, and they want to chill with you!

*/

contract BlockMint is ERC721Stakable, ReentrancyGuardUpgradeable {

	uint256 internal constant Max_Supply = 10000;
	uint256 internal constant Reeserve_Supply = 300;
	uint256 internal constant Public_Supply = Max_Supply - Reeserve_Supply;
	uint256 internal constant price = 0.02 ether;
	uint256 internal constant Max_mint_per_transaction = 10;
	//uint256 internal constant Whitelist_Max_mint_per_wallet = 2;

	uint[Max_Supply] private indices;
	uint private nonce = 0;


	string internal _baseTokenURI;
	bool internal URISet = false;


	//bytes32 public WhitelistMerkleRoot;
	//string public WhitelistURI;

	//bool public whitelistMintOpen;
	bool public publicMintOpen;

	uint256 public totalSupply;

	//uint256 internal _reserveMinted;

	//mapping(address => uint256) public whitelistMintedCounts;
	mapping(address => uint256) public publicMintedCounts;

	event WhitelistMintOpen();
	event PublicMintOpen();
	event Deposit(address indexed _from, uint256 indexed _id, uint _value);

	//  REMOVE TESTNET ADDRESSES BEFORE DEPLOYMENT ON MAINNET
		address payable internal jukabo = payable(0xeBd5bF494CCF8a1fC7a42aa2edFB39B3890ea220);
	//  REMOVE TESTNET ADDRESSES BEFORE DEPLOYMENT ON MAINNET



 /*
  WRITE FUNCTIONS
  */


 	// Function to initialize token, metadata and staking address

	constructor (address _stakingAddress) ERC721("BlockForge","BKLF") {
		StakingAddress = _stakingAddress;
	}

 //  Function to generate random ID => Credits to LarvaLabs Meebits Contract

	function randomIndex() internal returns (uint) {
			 uint totalSize = Max_Supply - totalSupply;
			 uint index = uint(keccak256(abi.encodePacked(nonce, msg.sender, block.difficulty, block.timestamp))) % totalSize;
			 uint value = 0;

			 if (indices[index] != 0) {
					 value = indices[index];
			 } else {
					 value = index;
			 }

			 // Move last value to selected position
			 if (indices[totalSize - 1] == 0) {
					 // Array position not initialized, so use position
					 indices[index] = totalSize - 1;
			 } else {
					 // Array position holds a value so use that
					 indices[index] = indices[totalSize - 1];
			 }
			 nonce++;
			 // Don't allow a zero index, start counting at 1
			 return value+1;
	 }


 	// Function to mint, can be called externally but cannot be called by a contract address => Credits to Critterz

	function mint(uint256 amount, bool stake) external payable noContract{
		uint256 newMintedAmount = publicMintedCounts[msg.sender] + amount;
		require(totalSupply + amount <= Public_Supply, "Token Limit Reached"); //Ensure there is supply before minting
		//require(newMintedAmount <= 1, "Public Mint Limit Reached");
		publicMintedCounts[msg.sender] = newMintedAmount;
		_mintHelper(msg.sender, amount, stake);
	}


 	// Function that actually does the mint. Need to call this if you want to mint => Credits to Critterz

	function _mintHelper(address account, uint256 amount, bool stake) internal nonReentrant {
		//uint _id;
		require(amount >0, "Amount too small");    		// amount of tokens you want to mint
		require(msg.value == price * amount);	 			// Ensures Mint Price is Applied
		uint256 _totalSupply = totalSupply;        // Total Supply of minted Tokens
		for(uint256 i = 0; i < amount; i++) {
			//_id = randomIndex();								 // commented out for test purposes, change before hardhat deploys or actual deploy
			_safeMint(
				stake ? StakingAddress: account,   // Checks if bool stake = yes, then send to staking address if no, then send to account
				_totalSupply + i,//_id,					   							// Increment Total Supply of minted tokens
				abi.encode(account)              // Not sure why this is done
			);
			emit Deposit(msg.sender, _totalSupply + i , msg.value);
		}

		totalSupply += amount; // => Critterz say this could be vunerable to re-entracy
	}


 	/**
 	 * Modifier is used to check if account used to mint is not a contract.
   * Does this by checking the code size of the address, which has to be 0 for non-contracts.
  */
	modifier noContract() {
		address account = msg.sender;  //checks that the account is the caller of the function
		require(account == tx.origin, "Caller is a contract");
		uint256 size = 0;
		assembly {
			size := extcodesize(account)
		}
		require(size ==0, "Caller is a contract");
		_;
	}



 /*
  READ FUNCTIONS
  */


 	// Function to view baseURI

 	function _baseURI() internal view virtual override returns(string memory){
 		return _baseTokenURI;
 	}


 /*
  OWNER FUNCTIONS
  */

 	//  Function to Open Public mint

  function setPublicMintOpen(bool open) external onlyOwner {
    publicMintOpen = open;
  	emit PublicMintOpen();
  }

 	//  Function to Set Staking Address/Change Staking address

 	function setStakingAddress(address _StakingAddress) public onlyOwner {
   	StakingAddress = _StakingAddress;
  }

 	// Function to set Base URI

  function setBaseURI(string memory baseTokenURI) external onlyOwner {
    _baseTokenURI = baseTokenURI;
    URISet = true;
  }

	function withdrawFunds() external virtual {
		uint256 balance = address(this).balance;
		jukabo.transfer(balance);
	}

}
