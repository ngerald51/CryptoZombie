pragma solidity ^0.4.19;

import "./zombieattack.sol";
import "./erc721.sol";

/*
ERC721 standard, and crypto-collectible assets.
Tutorial on making NFTs that are tradeable with  your friend
*/

contract ZombieOwnership is ZombieAttack, ERC721 {

  mapping (uint => address) zombieApprovals;

  function balanceOf(address _owner) public view returns (uint256 _balance) {
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return zombieToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerZombieCount[_to]++;
    ownerZombieCount[_from]--;
    zombieToOwner[_tokenId] = _to;
    Transfer(_from, _to, _tokenId);
  }

  function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    _transfer(msg.sender, _to, _tokenId);
  }

  function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    zombieApprovals[_tokenId] = _to;
    Approval(msg.sender, _to, _tokenId);
  }


//Require statement to check that zombieApprovals for _tokenId is equal to msg.sender.
//That way if msg.sender hasn't been approved to take this token, it will throw an error.

function takeOwnership(uint256 _tokenId) public {
    require(zombieApprovals[_tokenId] == msg.sender);
//In order to call _transfer, we need to know the address of the person who owns the token (it requires _from as an argument).
//Luckily we can look this up with our function ownerOf.
//So declare an address variable named owner, and set it equal to ownerOf(_tokenId).
    address owner = ownerOf(_tokenId);
    
 //call _transfer, and pass it all the required information. (Here you can use msg.sender for _to, 
 //since the person calling this function is the one the token should be sent to).
    _transfer(owner, msg.sender, _tokenId);
  }
}





