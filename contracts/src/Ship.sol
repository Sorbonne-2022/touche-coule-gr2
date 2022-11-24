// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import '../node_modules/hardhat/console.sol';

abstract contract Ship {
  function update(uint x, uint y) public virtual;
  function fire() public virtual returns (uint, uint);
  function place(uint width, uint height) public virtual returns (uint, uint);
}


contract FirstShip is Ship{ 
  
  function update(uint x, uint y) override public { 
    console.log("a", x, y);
  } 

  function fire() override public view returns (uint, uint) {
    return (0, 0);
  }

  function place(uint width, uint height) override public view returns (uint, uint) { 
     uint x = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) % width;
     uint y = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) % height;
     console.log("First Ship", x, y);
     return (x, y);
  } 
} 


contract SecondShip is Ship{

  function update(uint x, uint y) override public { 
    console.log("a", x, y);
  } 

  function fire() override public view returns (uint, uint) {
    return (0, 0);
  }

  function place(uint width, uint height) override public view returns (uint, uint) { 
    uint x = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) % width;
    uint y = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) % height;
    console.log("Second Ship", x, y);
    return (x, y);
  } 
}