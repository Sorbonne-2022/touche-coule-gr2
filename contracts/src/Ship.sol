// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import '../node_modules/hardhat/console.sol';

abstract contract Ship {
  address _owner;
  uint index;

  struct Position{
    uint current_x;
    uint current_y;
  }

  struct PositionFired{
      uint _x;
      uint _y;
  }

  mapping(uint => Position[]) internal ship_pos; 
  mapping(address => PositionFired[]) internal fired_pos;

  function update(uint x, uint y, uint _index) public virtual;
  function fire(uint width, uint height, uint _index) public virtual returns (uint, uint);
  function place(uint width, uint height) public virtual returns (uint, uint);
}


contract FirstShip is Ship{

  function update(uint x, uint y, uint _index) override(Ship) public {
    Position memory currentPosition;
    currentPosition.current_x = x;
    currentPosition.current_y = y;
    ship_pos[_index].push(currentPosition);
    console.log("Pushed");
  }

  function fire(uint width, uint height, uint _index) override(Ship) public returns (uint, uint) {
    uint x;
    uint y; 
    console.log("owner:", _index);
    /**
    console.log("Index 1:", ship_pos[1].length);
    console.log("Index 2:", ship_pos[2].length);
    console.log("Index 1 detail", ship_pos[1][0].current_x, ship_pos[1][0].current_y);
    console.log("Index 2 detail", ship_pos[2][0].current_x, ship_pos[2][0].current_y);
    */
    for(uint i = 0; i < ship_pos[_index].length; i++){
      // Generate any random number ranging from 100-599
      uint random = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) % 500;
      random = random + 100;
      x = ship_pos[_index][i].current_x * random % width;
      y = ship_pos[_index][i].current_y * random / width % height; 
    }
    console.log("Block difficulty", x, y);
    return (1, 1);
  }

  function place(uint width, uint height) override(Ship) public returns (uint, uint) { 
     uint x = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) % width;
     uint y = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) / width % height;
     console.log("First Ship", x, y, msg.sender);
     return (x, y);
  }

  function getPosition(uint _index) public view returns (uint) {
        ship_pos[_index].length;
  }
} 


contract SecondShip is Ship{

  function update(uint x, uint y, uint _index) override(Ship) public {
    Position memory currentPosition;
    currentPosition.current_x = x;
    currentPosition.current_y = y;
    ship_pos[_index].push(currentPosition);
    console.log("Pushed");
  }

  function fire(uint width, uint height, uint _index) override(Ship) public returns (uint, uint) {
    uint x;
    uint y;
     
    console.log("owner:", _index);
    /**
    console.log("Index 1:", ship_pos[1].length);
    console.log("Index 2:", ship_pos[2].length);
    console.log("Index 1 detail", ship_pos[1][0].current_x, ship_pos[1][0].current_y);
    console.log("Index 2 detail", ship_pos[2][0].current_x, ship_pos[2][0].current_y);
    */
    for(uint i = 0; i < ship_pos[_index].length; i++){
      // Generate any random number ranging from 100-599
      uint random = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) % 500;
      random = random + 100;
      x = ship_pos[_index][i].current_x * random % width;
      y = ship_pos[_index][i].current_y * random / width % height; 
    }
    console.log("Block difficulty", x, y);
    return (1, 1);
  }

  function place(uint width, uint height) override(Ship) public returns (uint, uint) { 
     uint x = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) % width;
     uint y = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) / width % height;
     console.log("First Ship", x, y, msg.sender);
     return (x, y);
  }

  function getPosition(uint _index) public view returns (uint) {
        ship_pos[_index].length;
  }
} 