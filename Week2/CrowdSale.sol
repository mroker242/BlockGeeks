pragma solidity ^0.4.24;

import "./IERC20.sol";
import "./SafeMath.sol";

contract Crowdsale {
    using SafeMath for uint256;

    uint256 private cap; // maximum amount of ether to be raised
    uint256 private weiRaised; // current amount of wei raised

    uint256 private rate; // price in wei per smallest unit of token (e.g. 1 wei = 10 smallet unit of a token)
    address private wallet; // wallet to hold the ethers
    IERC20 private token; // address of erc20 tokens

   /**
    * Event for token purchase logging
    * @param purchaser who paid for the tokens
    * @param beneficiary who got the tokens
    * @param value weis paid for purchase
    * @param amount amount of tokens purchased
    */
    event TokensPurchased(
        address indexed purchaser,
        address indexed beneficiary,
        uint256 value,
        uint256 amount
    );

    // -----------------------------------------
    // Public functions (DO NOT change the interface!)
    // -----------------------------------------
   /**
    * @param _rate Number of token units a buyer gets per wei
    * @dev The rate is the conversion between wei and the smallest and indivisible token unit.
    * @param _wallet Address where collected funds will be forwarded to
    * @param _token Address of the token being sold
    */
    constructor(uint256 _rate, address _wallet, IERC20 _token, uint256 _cap) public {
        // TODO: Your Code Here
        rate = _rate;
        wallet = _wallet;
        token = _token;
        // convert cap to ether e.g 1 ether = 1000000000000000000 weis 
        cap = _cap.mul(1000000000000000000);
    }

    /**
    * @dev Fallback function for users to send ether directly to contract address
    */
    function() external payable {
        // TODO: Your Code Here
        
        // use the buyTokens function to send ether directly to users, not sure what the address should be
        buyTokens(msg.sender);
    }

    function buyTokens(address beneficiary) public payable {
        // Below are some general steps that should be done.
        // You need to decide the right order to do them in.
        //  - Validate any conditions
        //  - Calculate number of tokens
        //  - Update any states
        //  - Transfer tokens and emit event
        //  - Forward funds to wallet

        // TODO: Your Code Here
        
        // validations
        // make sure cap is not reached
        require(weiRaised < cap, "The cap is reached, the sale ends now.");
        
        // calculate how much wei is the person sending as ether
        //uint256 weiConverted = msg.value * 1000000000000000000;
        
        // weiRaised is raised to how much the sender purchases
        weiRaised = weiRaised.add(msg.value);
        
        //calculate number of tokens a user should receive
        uint256 numOfTokens = rate * msg.value;
        
        //transfer tokens
        token.transfer(beneficiary, numOfTokens);
        
        //forward funds to wallet. This is the user putting on the Crowdsale
        wallet.transfer(msg.value);
    
        emit TokensPurchased(msg.sender, beneficiary, msg.value, numOfTokens);
    }

    /**
    * @dev Checks whether the cap has been reached.
    * @return Whether the cap was reached
    */
    function capReached() public view returns (bool) {
        // TODO: Your Code Here
        
        if (weiRaised >= cap) {
            return true;
        } else {
            return false;
        }
        
        
    }

    // -----------------------------------------
    // Internal functions (you can write any other internal helper functions here)
    // -----------------------------------------


}
