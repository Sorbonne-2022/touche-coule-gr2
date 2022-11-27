// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import '../node_modules/hardhat/console.sol';

abstract contract Ship {
  address owner;
  uint index;

  struct Position{
    uint current_x;
    uint current_y;
    bool eliminated;
  }

  struct PositionFired{
      uint _x;
      uint _y;
      bool first_fire;
  }

  mapping(uint => Position[]) public ship_pos; 
  mapping(uint => PositionFired) public last_fire;

  function update(uint x, uint y, uint _index) public virtual;
  function fire(uint width, uint height, uint _index, address _owner) public virtual returns (uint, uint);
  function place(uint width, uint height) public virtual returns (uint, uint);
  function get_cur_pos(uint _index) public virtual returns (uint, uint);
}


contract FirstShip is Ship{

  function get_cur_pos(uint _index) override(Ship) public returns (uint, uint) {
      uint x = ship_pos[_index][0].current_x;
      uint y = ship_pos[_index][0].current_y;
      return (x,y);
  }

  function update(uint x, uint y, uint _index) override(Ship) public {
    Position memory currentPosition;
    currentPosition.current_x = x;
    currentPosition.current_y = y;
    ship_pos[_index].push(currentPosition);
    console.log("Pushed");
  }

  function fire(uint width, uint height, uint _index, address _owner) override(Ship) public returns (uint, uint) {
    uint x;
    uint y;
    
    console.log("Index :", _index, _owner);
    for(uint i = 0; i < ship_pos[_index].length; i++){
      // Generate any random number ranging from 1-49
      uint random = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) % 50;
      console.log("Random number :", random, !last_fire[_index].first_fire);
      // (+) operator for case when x or y == 0
      // (i + ..) operator for  case when two ship have same position like (35,35)
      if(!last_fire[_index].first_fire){
        x = (ship_pos[_index][i].current_x + random  + (i + 1)) % width;
        y = (ship_pos[_index][i].current_y + random + i) % height;
        last_fire[_index]._x = x;
        last_fire[_index]._y = y;
        last_fire[_index].first_fire = true;
        console.log("Set a first fire", last_fire[_index]._x, last_fire[_index]._y, last_fire[_index].first_fire);
      }else{
        console.log("Get last fire position", last_fire[_index]._x, last_fire[_index]._y, last_fire[_index].first_fire);
        x = (last_fire[_index]._x + random + (i + 1)) % width;
        y = (last_fire[_index]._y + random + i) % height;
        last_fire[_index]._x = x;
        last_fire[_index]._y = y;
        console.log("Fire", last_fire[_index]._x, last_fire[_index]._y, last_fire[_index].first_fire);
      }
    }
    console.log("Block Fire", last_fire[_index]._x, last_fire[_index]._y);
    return (x, y);
  }

  function place(uint width, uint height) override(Ship) public returns (uint, uint) { 
     uint x = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) % width;
     uint y = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) / width % height;
     console.log("First Ship", x, y, msg.sender);
     return (x, y);
  }
} 


contract SecondShip is Ship{

  function get_cur_pos(uint _index) override(Ship) public returns (uint, uint) {
      uint x = ship_pos[_index][0].current_x;
      uint y = ship_pos[_index][0].current_y;
      return (x,y);
  }

  function update(uint x, uint y, uint _index) override(Ship) public {
    Position memory currentPosition;
    currentPosition.current_x = x;
    currentPosition.current_y = y;
    ship_pos[_index].push(currentPosition);
    console.log("Pushed");
  }

  function fire(uint width, uint height, uint _index, address _owner) override(Ship) public returns (uint, uint) {
    uint x;
    uint y;
    
    console.log("Index :", _index, _owner);
    for(uint i = 0; i < ship_pos[_index].length; i++){
      // Generate any random number ranging from 1-49
      uint random = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) % 50;
      console.log("Random number :", random, !last_fire[_index].first_fire);
      // (+) operator for case when x or y == 0
      // (i + ..) operator for  case when two ship have same position like (35,35)
      if(!last_fire[_index].first_fire){
        x = (ship_pos[_index][i].current_x + random  + (i + 1)) % width;
        y = (ship_pos[_index][i].current_y + random + i) % height;
        last_fire[_index]._x = x;
        last_fire[_index]._y = y;
        last_fire[_index].first_fire = true;
        console.log("Set a first fire", last_fire[_index]._x, last_fire[_index]._y, last_fire[_index].first_fire);
      }else{
        console.log("Get last fire position", last_fire[_index]._x, last_fire[_index]._y, last_fire[_index].first_fire);
        x = (last_fire[_index]._x + random + (i + 1)) % width;
        y = (last_fire[_index]._y + random + i) % height;
        last_fire[_index]._x = x;
        last_fire[_index]._y = y;
        console.log("Fire", last_fire[_index]._x, last_fire[_index]._y, last_fire[_index].first_fire);
      }
    }
    console.log("Block Fire", last_fire[_index]._x, last_fire[_index]._y);
    return (x, y);
  }

  function place(uint width, uint height) override(Ship) public returns (uint, uint) { 
     uint x = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) % width;
     uint y = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) / width % height;
     console.log("First Ship", x, y, msg.sender);
     return (x, y);
  }
} 