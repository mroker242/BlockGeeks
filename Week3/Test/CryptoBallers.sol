pragma solidity ^0.4.24;

import './ERC721.sol';

contract CryptoBallers is ERC721 {

    struct Baller {
        string name;
        uint level;
        uint offenseSkill;
        uint defenseSkill;
        uint winCount;
        uint lossCount;
    }

    address owner;
    Baller[] public ballers;

    // Mapping for if address has claimed their free baller
    mapping(address => bool) claimedFreeBaller;

    // Fee for buying a baller
    uint ballerFee = 0.10 ether;

    // /**
    // * @dev Ensures ownership of the specified token ID
    // * @param tokenId uint256 ID of the token to check
    // */
    modifier onlyOwnerOf(uint256 _tokenId) {
        // TODO add your code
        // _tokenOwner is mapping from ownerId to owner address
        require(msg.sender == ownerOf(_tokenId), "User is not the owner of the token.");
        _;
    }

    // /**
    // * @dev Ensures ownership of contract
    // */
    modifier onlyOwner() {
        // TODO add your code
        require(msg.sender == owner, "You are not the owner of the Contract.");
        _;
    }

    // /**
    // * @dev Ensures baller has level above specified level
    // * @param level uint level that the baller needs to be above
    // * @ballerId uint ID of the Baller to check
    // */
    modifier aboveLevel(uint _level, uint _ballerId) {
        // TODO add your code
        // every Baller has a level as the Struct. What are the levels?
        require(ballers[_ballerId].level > _level, "Baller has to be above this level.");
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    // /**
    // * @dev Allows user to claim first free baller, ensure no address can claim more than one
    // */
    function claimFreeBaller() public {
        // TODO add your code
        
        //make sure person cannot claim freeballer again.
        require(claimedFreeBaller[owner] == false, "You already have claimed your freeballer.");
        
        // create a baller
        _createBaller("Jude", 2, 10, 10);
        
        // mark that the owner has claimed their freeballer
        claimedFreeBaller[owner] = true;
    }

    /**
    * @dev Allows user to buy baller with set attributes
    */
    function buyBaller() public payable {
        // TODO add your code
        
        // Does the user have enough ether?
        require(msg.value >= ballerFee, "You do not have sufficient funds.");
        
        _createBaller("Arnold", 3, 7, 7);
    }

    // /**
    // * @dev Play a game with your baller and an opponent baller
    // * If your baller has more offensive skill than your opponent's defensive skill
    // * you win, your level goes up, the opponent loses, and vice versa.
    // * If you win and your baller reaches level 5, you are awarded a new baller with a mix of traits
    // * from your baller and your opponent's baller.
    // * @param ballerId uint ID of the Baller initiating the game
    // * @param targetId uint ID that the baller needs to be above
    // */
    function playBall(uint _ballerId, uint _opponentId) onlyOwnerOf(_ballerId) public {
       // TODO add your code
       
       // if your baller has more offensiveskill than your opponent, you win
       if (ballers[_ballerId].offenseSkill > ballers[_opponentId].defenseSkill){
           // then you win, change level count of your baller 
           ballers[_ballerId].winCount += 1;
           ballers[_opponentId].lossCount += 1;
           ballers[_ballerId].level += 1;
       } else{
           ballers[_opponentId].winCount += 1;
           ballers[_ballerId].lossCount += 1;
           ballers[_opponentId].level += 1;
       }
    }

    // /**
    // * @dev Changes the name of your baller if they are above level two
    // * @param ballerId uint ID of the Baller who's name you want to change
    // * @param newName string new name you want to give to your Baller
    // */
    function changeName(uint _ballerId, string _newName) external aboveLevel(2, _ballerId) onlyOwnerOf(_ballerId) {
        // TODO add your code
        
        // just off the cuff code.
        ballers[_ballerId].name = _newName;
    }

//     /**
//   * @dev Creates a baller based on the params given, adds them to the Baller array and mints a token
//   * @param name string name of the Baller
//   * @param level uint level of the Baller
//   * @param offenseSkill offensive skill of the Baller
//   * @param defenseSkill defensive skill of the Baller
//   */
    function _createBaller(string _name, uint _level, uint _offenseSkill, uint _defenseSkill) internal {
        // TODO add your code
        
        // figure this one out
        //Baller storage baller1 = ballers[ballerId];
        
        
        ballers.push(Baller(_name, _level, _offenseSkill, _defenseSkill, 0, 0));
        
        uint256 tokenId = ballers.length - 1;
        
        _mint(msg.sender, tokenId);
        
        
        
    }

    // /**
    // * @dev Helper function for a new baller which averages the attributes of the level, attack, defense of the ballers
    // * @param baller1 Baller first baller to average
    // * @param baller2 Baller second baller to average
    // * @return tuple of level, attack and defense
    // */
    function _breedBallers(Baller _baller1, Baller _baller2) internal pure returns (uint, uint, uint) {
        uint level = _baller1.level.add(_baller2.level).div(2);
        uint attack = _baller1.offenseSkill.add(_baller2.offenseSkill).div(2);
        uint defense = _baller1.defenseSkill.add(_baller2.defenseSkill).div(2);
        return (level, attack, defense);

    }
}
