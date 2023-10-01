// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";

contract PortNFT is VRFConsumerBaseV2 {
    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId, uint256[] randomWords);

    struct RequestStatus {
        bool fulfilled;
        bool exists; 
        uint256[] randomWords;
    }
    mapping(uint256 => RequestStatus)
        public s_requests;
    VRFCoordinatorV2Interface COORDINATOR;

    uint64 s_subscriptionId = 5627;

    uint256[] public requestIds;
    uint256 public lastRequestId;

    bytes32 keyHash =
        0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c;

    uint32 callbackGasLimit = 100000;
    uint16 requestConfirmations = 3;
    uint32 numWords = 1;
    address contractOwner;

    constructor(
        address _contractOwner
    )
        VRFConsumerBaseV2(0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625)
    {
        COORDINATOR = VRFCoordinatorV2Interface(
            0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625
        );
        contractOwner = _contractOwner;
    }

    modifier onlyContractOwner() {
        require(msg.sender == contractOwner, "Only the contract owner can call this function");
        _;
    }

    string public portName;
    uint256 public money;
    uint32 public level;
    uint256 public coolDownTimeAmount = 3200;
    uint16 private dockCounter = 0;
    uint8 public continent;
    
    uint16 constant upgradeDockBasePrice = 20;
    uint16 constant saleDockBasePrice = 200;

    struct Dock {
        uint32 level;
        uint256 timeCreated;
        uint256 source;
        uint256 coolDownTime;
    }

    //mapping(uint256 => Dock) public docks;
    Dock[] public docksArray; // Array of Dock structs

    // Mint a new Port
    function mint(string memory username, uint8 _continent, uint8 _firstSource) public onlyContractOwner {
        docksArray.push(Dock(1, block.timestamp, _firstSource, block.timestamp+coolDownTimeAmount));
        portName = username;
        money = 100;
        level = 0;
        continent = _continent;
        dockCounter++;
    }

    // User can choose a predefined location on a map (frontend) -> we need to store it in smart contract
    // When dock is created: 1. either random source port 2. or choose specific source port

    function trade(uint16 dockID) public onlyContractOwner { // Store source and port location somewhere; Make reward less when it is bad weather.
        // Create custom function for weather
        require(block.timestamp >= docksArray[dockID].coolDownTime);
        docksArray[dockID].coolDownTime = block.timestamp+coolDownTimeAmount;  
        // Get weather data from Chainlink function
        // Call API with 
        uint16 windSpeed = 20; // Returned wind speed
        uint16 waveHeight = ((27)*((windSpeed**2)*100))/(981);
        uint16 reward;
        if(waveHeight >= 2000) {
            reward = 10;
        } else if(waveHeight <= 500) {
            reward = 100;
        } else {
            reward = 50;
        }
        money = money+(reward*((docksArray[dockID].level+level)/10));
        level++; // Level gets updated everytime the trade is performed
    }

    function buyDock() public onlyContractOwner {
        uint32 salePrice = saleDockBasePrice*level;
        // Get Chainlink's random number
        requestRandomWords();
    }

    function upgradeDock(uint16 dockID) public onlyContractOwner {
        uint32 upgradePrice = upgradeDockBasePrice*docksArray[dockID].level;
        require(money >= upgradePrice);
        money = money-upgradePrice;
        docksArray[dockID].level++;
    }


    // Get the details of all docks
    function getAllDocks() public view returns (Dock[] memory) {
        return docksArray;
    }

    function requestRandomWords()
        public
        returns (uint256 requestId)
    {
        // Will revert if subscription is not set and funded.
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
        s_requests[requestId] = RequestStatus({
            randomWords: new uint256[](0),
            exists: true,
            fulfilled: false
        });
        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSent(requestId, numWords);
        return requestId;
    }

    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] memory _randomWords
    ) internal override {
        require(s_requests[_requestId].exists, "request not found");
        s_requests[_requestId].fulfilled = true;
        s_requests[_requestId].randomWords = _randomWords;

        // Create new dock with random source
        uint256 _randomSource;
        if(_randomWords[0] > 7) {
            _randomSource = 3;
        } else if(_randomWords[0] < 3) {
            _randomSource = 2;
        } else if(_randomWords[0] > 2 && _randomWords[0] < 5) {
            _randomSource = 1;
        } else {
            _randomSource = 0;
        }

        level++;
        uint32 salePrice = saleDockBasePrice*level;
        money = money-salePrice;
        docksArray.push(Dock(1, block.timestamp, _randomSource, block.timestamp+coolDownTimeAmount));
        dockCounter++;

        emit RequestFulfilled(_requestId, _randomWords);
    }

    function getRequestStatus(
        uint256 _requestId
    ) external view returns (bool fulfilled, uint256[] memory randomWords) {
        require(s_requests[_requestId].exists, "request not found");
        RequestStatus memory request = s_requests[_requestId];
        return (request.fulfilled, request.randomWords);
    }
}