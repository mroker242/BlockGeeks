pragma solidity ^0.4.24;

contract RewardPoints {
    address private owner;
    mapping(address => bool) private isAdmin; // Quick way to check if an addr is an Admin

    struct Merchant {
        uint id;
        address addr; // the organization's owner address
        bool isApproved;
        mapping(address => bool) isOperator; // is addr approved by Merchant as operator
    }
    Merchant[] private merchants;
    mapping(address => uint) private addrToMerchantId; // get merchantId from an addr

    struct User {
        uint id;
        address addr;
        bool isApproved;
        uint totalEarnedPoints;
        uint totalReedemedPoints;
        mapping(uint => uint) merchantToEarnedPts; // keep track of points earned from each merchant separately
        mapping(uint => uint) merchantToRedeemedPts; // keep track of points used for at each merchant
    }
    User[] private users;
    mapping(address => uint) private addrToUserId;


    // =================================
    // Events and modifiers
    // =================================
    event AddedAdmin(address indexed admin);
    event RemovedAdmin(address indexed admin);

    event AddedMerchant(address indexed merchant, uint indexed id);
    event BannedMerchant(uint indexed merchantId);
    event ApprovedMerchant(uint indexed merchantId);
    event TransferredMerchantOwnership(uint indexed merchantId, address oldOwner, address newOwner);

    event AddedOperator(uint indexed merchantId, address indexed operator);
    event RemovedOperator(uint indexed merchantId, address indexed operator);

    event AddedUser(address indexed user, uint indexed id);
    event BannedUser(address indexed user, uint indexed id);
    event ApprovedUser(address indexed user, uint indexed id);

    event RewardedUser(address indexed user, uint indexed merchantId, uint points);
    event RedeemedPoints(address indexed user, uint indexed merchantId, uint points);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyAdmin() {
        require(isAdmin[msg.sender] || msg.sender == owner);
        _;
    }

    function merchantExist(uint _id) internal view returns(bool) {
        if (_id != 0 && _id < merchants.length) return true;
        return false;
    }

    function isMerchantValid(uint _id) internal view returns(bool) {
        if(merchantExist(_id) && merchants[_id].isApproved) return true;
        return false;
    }

    function isMerchantOwner(address _owner) internal view returns(bool) {
        uint id = addrToMerchantId[_owner];
        return (isMerchantValid(id) && merchants[id].addr == _owner);
    }

    modifier onlyMerchantOwner() {
        require(isMerchantOwner(msg.sender));
        _;
    }

    modifier onlyMerchant() {
        uint id = addrToMerchantId[msg.sender];
        bool isOperator = merchants[id].isOperator[msg.sender];
        require(isMerchantValid(id));
        require(isMerchantOwner(msg.sender) || isOperator);
        _;
    }

    function userExist(uint _id) internal view returns(bool) {
        if(_id != 0 && _id < users.length) return true;
        return false;
    }

    function isUserValid(uint _id) internal view returns(bool) {
        if(userExist(_id) && users[_id].isApproved) return true;
        return false;
    }

    modifier onlyUser() {
        require(isUserValid(addrToUserId[msg.sender]));
        _;
    }

    constructor() public {
        // Do not use ID 0 for first user and merchant to avoid returning invalid
        // first merchant/user when looking it up with addrToMerchantID mapping
        merchants.push(Merchant(0, 0, false));
        users.push(User(0, 0, false, 0, 0));
        owner = msg.sender;
    }

    // =================================
    // Owner Only
    // =================================
    function addAdmin(address _admin) external onlyOwner {
        // TODO: your code here
        
        // add User
        uint userId = users.length;
        users.push(User(userId, _admin, true, 0, 0));
        
        // add user to mapping
        addrToUserId[_admin] = userId;
        
        // change isadmin to true
        isAdmin[_admin] = true;
        
        emit AddedAdmin(_admin);

    }

    function removeAdmin(address _admin) external onlyOwner {
        // TODO: your code here
        
        // change isAdmin mapping to false
        isAdmin[_admin] = false; 
        
        //so far, not removing anything from the array of users because 
        // it defaults to 0 anyway. also, not from the mapping
        
        emit RemovedAdmin(_admin);
    }

    // =================================
    // Admin Only Actions
    // =================================
    function addMerchant(address _merchant) external onlyAdmin {
        // TODO: your code here
        // Hints: Remember the index into the array is the ID
        // 1. Create a new merchant and assign various fields
        // 2. Push new merchant into array
        // 3. Update addrToMerchantId mapping
        // 4. Emit event
        
        // 1. 2.  add a merchant
        uint mId = merchants.length;
        merchants.push(Merchant(mId, _merchant, true));
        
        
        
        
        // 3. add to mapping
        addrToMerchantId[_merchant] = mId;
        
        // 4. emit event
        emit AddedMerchant(_merchant, mId);
        
        
    }

    function banMerchant(uint _id) external onlyAdmin {
        // TODO: your code here
        // Hints: Only ban merchants that are valid and
        // remember we're not removing a merchant.
        
        // check to make sure it is a merchant
        require(_id <= merchants.length, "This is not a valid merchant.");
        
        // ban the merchant
        merchants[_id].isApproved = false;
        
        emit BannedMerchant(_id);
    }

    function approveMerchant(uint _id) external onlyAdmin {
        // TODO: your code here
        // Hints: Do the reverse of banMerchant
        
        // check to make sure id is fine
        require(_id <= merchants.length, "This is not a valid merchant.");
        
        // make sure that the merchant is currently not approved.
        require(merchants[_id].isApproved == false, "Merchant already is approved.");
        
        merchants[_id].isApproved = true;
        
        emit ApprovedMerchant(_id);
    }

    function addUser(address _user) external onlyAdmin {
        // TODO: your code here
        // Hints: Similar steps to addMerchant
        
        // add user
        uint uId = users.length;
        users.push(User(uId, _user, true, 0, 0));
        
        // add to mapping
        addrToUserId[_user] = uId;
        
        emit AddedUser(_user, uId);
        
        
    }

    function banUser(address _user) external onlyAdmin {
        // TODO: your code here
        // Hints: Similar to banMerchant but the input
        // parameter is user address instead of ID.
        
        // find the userId
        uint uId = addrToUserId[_user];
        
        require(users[uId].isApproved == false, "User is already banned.");
        
        // ban user, turn their isapproved to false
        users[uId].isApproved = false;
        
        emit BannedUser(_user, uId);
        
    }

    function approveUser(address _user) external onlyAdmin {
        // TODO: your code here
        // Hints: Do the reverse of banUser
        
        // find the userId
        uint uId = addrToUserId[_user];
        
        // require user to be already be banned.
        require(users[uId].isApproved == true, "User is already approved.");

        
        // ban user, turn their isapproved to false
        users[uId].isApproved = true;
        
        emit ApprovedUser(_user, uId);
    }

    // =================================
    // Merchant Owner Only Actions
    // =================================
    function addOperator(address _operator) external onlyMerchantOwner {
        // TODO: your code here
        // Hints:
        // 1. Get the merchant ID from msg.sender
        // 2. Set the correct field within the Merchant Struct
        // 3. Update addrToMerchantId mapping
        // 4. Emit event
        
        //1. get merchant id of owner
        uint mId = addrToMerchantId[msg.sender];

        
        //2. update new merchant struct to operator = true
        merchants[mId].isOperator[_operator] = true;
        
        // add another int for mapping
        uint operatorId = merchants.length;
        
        // 3. update mapping from address to id
        addrToMerchantId[_operator] = operatorId;
        
        
        // 4. emit event
        emit AddedOperator(mId, _operator);
       
    }

    function removeOperator(address _operator) external onlyMerchantOwner {
        // TODO: your code here
        // Hints: Do the reverse of addOperator
        
        // get the id of merchant owner
        uint mId = addrToMerchantId[msg.sender];
        
        // change operator to false inside Merchant struct 
        merchants[mId].isOperator[_operator] = false;
        
        emit RemovedOperator(mId, _operator);
        
    }

    function transferMerchantOwnership(address _newAddr) external onlyMerchantOwner {
        // TODO: your code here
        // Hints: Similar to addOperator but update different fields
        // but remember to update the addrToMerchantId twice. Once to
        // remove the old owner and once for the new owner.
        
        // add the ownership to the struct
        uint ownerMerchantId = addrToMerchantId[msg.sender];
        
        uint transferMerchantId = addrToMerchantId[_newAddr];
        
        // add ownership to new Merchant
        merchants[transferMerchantId].addr = _newAddr;
        
        // remove ownership from current ownership
        merchants[ownerMerchantId].addr = _newAddr;
        
        emit TransferredMerchantOwnership(transferMerchantId, msg.sender, _newAddr);
    }

    // =================================
    // Merchant only actions
    // =================================
    function rewardUser(address _user, uint _points) external onlyMerchant {
        // TODO: your code here
        // Hints: update the total and per merchant points
        // for the user in the User struct.
        
        // get id for User
        uint uid = addrToUserId[_user];
        
        // add points to user
        users[uid].totalEarnedPoints += _points;
        
        
        // find out the merchant id
        uint mId = addrToMerchantId[msg.sender];
        
        // map the current merchant id to the points
        users[uid].merchantToEarnedPts[mId] = _points;
        
        emit RewardedUser(_user, mId, _points);
        
        
    }

    // =================================
    // User only action
    // =================================
    function redeemPoints(uint _mId, uint _points) external onlyUser {
        // TODO: your code here
        // Hints:
        // 1. Get the user ID from caller
        // 2. Ensure user has at least _points at merchant with id _mID
        // 3. Update the appropriate fields in User structs
        // 4. Emit event
        
        uint senderId = addrToUserId[msg.sender];
        
        require(users[senderId].totalEarnedPoints > _points, "You do not have enough points to redeem.");
        
        // add to total redeemed points
        users[senderId].totalReedemedPoints += _points;
        
        // add to merchant to redeemed points
        users[senderId].merchantToRedeemedPts[_mId] += _points;
        
        emit RedeemedPoints(msg.sender, _mId, _points);
        
        
        
    }

    // =================================
    // Getters
    // =================================

    function getMerchantById(uint _id) public view returns(uint, address, bool) {
        require(merchantExist(_id));
        Merchant storage m = merchants[_id];
        return(m.id, m.addr, m.isApproved);
    }

    function getMerchantByAddr(address _addr) public view returns(uint, address, bool) {
        uint id = addrToMerchantId[_addr];
        return getMerchantById(id);
    }

    function isMerchantOperator(address _operator, uint _mId) public view returns(bool) {
        require(merchantExist(_mId));
        return merchants[_mId].isOperator[_operator];
    }

    function getUserById(uint _id) public view returns(uint, address, bool, uint, uint) {
        require(userExist(_id));
        User storage u = users[_id];
        return(u.id, u.addr, u.isApproved, u.totalEarnedPoints, u.totalReedemedPoints);
    }

    function getUserByAddr(address _addr) public view returns(uint, address, bool, uint, uint) {
        uint id = addrToUserId[_addr];
        return getUserById(id);
    }

    function getUserEarnedPointsAtMerchant(address _user, uint _mId) public view returns(uint) {
        uint uId = addrToUserId[_user];
        require(userExist(uId));
        require(merchantExist(_mId));
        return users[uId].merchantToEarnedPts[_mId];
    }

    function getUserRedeemedPointsAtMerchant(address _user, uint _mId) public view returns(uint) {
        uint uId = addrToUserId[_user];
        require(userExist(uId));
        require(merchantExist(_mId));
        return users[uId].merchantToRedeemedPts[_mId];
    }

}
