// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "./Ship.sol";
import "../node_modules/hardhat/console.sol";

struct Game {
  uint height;
  uint width;
  mapping(uint => mapping(uint => uint)) board;
  mapping(uint => int) xs;
  mapping(uint => int) ys;
}

contract Main {
  Game private game;
  uint private index;
  mapping(address => mapping(address => bool)) private used;
  mapping(uint => address) private ships;
  mapping(uint => address) private owners;
  mapping(address => uint) private count;
  mapping(address => mapping(uint => Ship.Position[])) private guild;
  mapping(address => Ship.PositionFired[]) private fired;

  event Size(uint width, uint height);
  event Touched(uint ship, uint x, uint y);
  event Registered(
    uint indexed index,
    address indexed owner,
    uint x,
    uint y
  );
  event Winner(address indexed owner);
  

  constructor() {
    game.width = 50;
    game.height = 50;
    index = 1;
    emit Size(game.width, game.height);
  }

  function register(address ship) external {
    require(count[msg.sender] < 2, "Only two ships");
    require(!used[msg.sender][ship], "Ship already on the board");
    require(index <= game.height * game.width, "Too much ship on board");
    console.log("Sender", msg.sender, "index", index);
    count[msg.sender] += 1;
    ships[index] = ship;
    owners[index] = msg.sender;
    (uint x, uint y) = placeShip(index);
    Ship(ships[index]).update(x, y, index);
    used[msg.sender][ship] = true;
    emit Registered(index, msg.sender, x, y);
    index += 1;
  }

  function theEnd() external {
      uint count = 0;
      uint[] memory indexs = new uint[](index);
      console.log("Length", indexs.length);
      for (uint i = 1; i < index; i++){
        if(game.xs[i] != -1){
           indexs[count] = i;
           count = count + 1;
           console.log("Info", i, count);
        }
      }
     
      if(indexs.length == 1){
         console.log("Winner:", owners[indexs[0]]);
         emit Winner(owners[indexs[0]]);
      }else if(indexs.length == 2){
         if(owners[indexs[0]] == owners[indexs[1]]){
            console.log("Winner:", owners[indexs[0]]);
            emit Winner(owners[indexs[0]]);
         }
      }
  }

  function turn() external {
    //Require at least 4 ship to start a game
    require(index >= 4, "Not enough ship on board to start");
    bool[] memory touched = new bool[](index);

    /**
    Code to identify partner of each ship
     */
    for (uint i = 1; i < index; i++) {
      Ship ship = Ship(ships[i]);
      (uint x, uint y) = ship.get_cur_pos(i);
      Ship.Position memory currentPosition;
      currentPosition.current_x = x;
      currentPosition.current_y = y;
      uint allie_ship;
      while(allie_ship < index){
          if(allie_ship == i){
              console.log("It's my ship: ", i);
          }else{
            if(owners[i] == owners[allie_ship]){
                console.log("I found a partner!");
                guild[owners[i]][allie_ship].push(currentPosition);
                console.log("Index", i, allie_ship);
            }
          }
          allie_ship = allie_ship + 1;
      }
    }

    //Console log debug for guild
    for (uint i = 1; i < index; i++){
      console.log("Guild", guild[owners[i]][i].length);
      console.log("Index", i, guild[owners[i]][i][0].current_x, guild[owners[i]][i][0].current_y);
    }

    for (uint i = 1; i < index; i++) {
      if (game.xs[i] < 0) continue;
      Ship ship = Ship(ships[i]);
      console.log("Ship: ", address(ship), "Index Turn:", i);
      (uint x, uint y) = ship.fire(game.width, game.height, i, owners[i]);
      // Check with partner's position
      uint partner_x = guild[owners[i]][i][0].current_x;
      uint partner_y = guild[owners[i]][i][0].current_y;
      if(x == partner_x && y == partner_y){
        // If fire is on partner's ship, must change fire position!
        uint random = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) % 100;
        uint new_fire = (x * game.width) + random + 1;
        x = new_fire % game.width;
        y = new_fire / game.width % game.height;
      }
      console.log("I fired here", i, x, y);
      emit Touched(i, x, y);
      if (game.board[x][y] > 0) {
        touched[game.board[x][y]] = true;
      }
    }

    for (uint i = 0; i < index; i++) {
      if (touched[i]) {
        emit Touched(i, uint(game.xs[i]), uint(game.ys[i]));
        game.xs[i] = -1;
      }
    }
    this.theEnd();
  }

  function placeShip(uint idx) internal returns (uint, uint) {
    Ship ship = Ship(ships[idx]);
    (uint x, uint y) = ship.place(game.width, game.height);
    bool invalid = true;
    while (invalid) {
      if (game.board[x][y] == 0) {
        game.board[x][y] = idx;
        game.xs[idx] = int(x);
        game.ys[idx] = int(y);
        invalid = false;
      } else {
        uint newPlace = (x * game.width) + y + 1;
        x = newPlace % game.width;
        y = newPlace / game.width % game.height;
      }
    }
    return (x, y);
  }

}
