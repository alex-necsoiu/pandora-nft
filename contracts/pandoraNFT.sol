// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract pandoraNFT is
    ERC721EnumerableUpgradeable,
    OwnableUpgradeable,
    ReentrancyGuardUpgradeable,
    UUPSUpgradeable
{
    // Route of the url of the images stored on ipfs 
    string private baseURi;

    string public contractURI;

    // Flags to activate or desactivate different stages of minting 
    bool public teamMintActive; // Only private Whitelist
    bool public airdropMintActive; // Minted only by the contract Owner
    bool public whitelistMintActive; // Only preregistred whitelist
    bool public pubMintActive; // Open to public sale 

    // Whitelists 
    mapping(address=> uint32) public whitelist;
    mapping(address => uint32) public teamWhitelist;

    // Total supply
	uint32 public constant MAX_SUPPLY = 100;

    // Public Team Minting price
    uint64 private constant TEAM_MINT_PRICE = 0.001 ether;

    // Public Whitelist Minting price
    uint64 private constant WHITELIST_MINT_PRICE = 0.003 ether;

    // Public Minting price
    uint64 private constant PUBLIC_MINT_PRICE = 0.005 ether;

    // Current index of the NFT
    using Counters for Counters.Counter;
    Counters.Counter private supply;

    // Address of the treasury how will own 50% of the NFT's on initialization of the contract
    address public treasury;

    // Events
    event mintingStatus(
        bool teamMintActive,
        bool airdropMintActive,
        bool whitelistMintActive,
        bool pubMintActive
        );

    // Initialize the contract
    function initialize(
        address _newOwner,  
        address _treasury
    ) public initializer {
        __ERC721_init("The Pandora", "PANDORA");
        __Ownable_init();
        __UUPSUpgradeable_init();
        treasury=_treasury;
        transferOwnership(_newOwner);
        supply.increment();
    }

    // Initializes the contract by setting a `name` and a `symbol`
    // constructor(){
    //     initalize("The Panter", "PANTER", myAddress,myAddress);
    // }

    // Mint Function
    function mint(address _to, uint32 _quantity) private {
        /**
		 * To save gas, since we know _quantity won't overflow
		 * Checks are performed in caller functions / methods
		 */
        require(supply.current() <= MAX_SUPPLY, "Max supply alredy minted");
        for(uint32 i = 0; i < _quantity; ++i){
            _mint(_to,supply.current());
            supply.increment();
        }
    }

    // Team Mint first 50 rare NFT's of the colection
    function teamNFTMint(address _to, uint32 _quantity) external payable nonReentrant{
        require(_quantity > 0,"Invalid mint quantity");
        require(teamMintActive, "Team Mint not started");
        require(TEAM_MINT_PRICE * _quantity <= msg.value, "Not enough minting fees");
        require(teamWhitelist[msg.sender] >= _quantity, "NFT's not available for this address");
        teamWhitelist[msg.sender] -= _quantity;
        mint(_to,_quantity);
    }

    // Airdrop Mint giveaway for founders and partners
    function airdropNFTMint(address _to, uint32 _quantity) external onlyOwner {
        require(_quantity > 0,"Invalid mint quantity");
        require(airdropMintActive, "Airdrop mint not started");
        mint(_to,_quantity);
    }

    // Whitelist Mint 
    function whitelistNFTMint(address _to, uint32 _quantity) public payable nonReentrant {
        require(_quantity > 0,"Invalid mint quantity");
        require(whitelistMintActive, "Whitelist mint not started");
        require(whitelist[msg.sender] >= _quantity, "NFT's not available for this address");
        require(WHITELIST_MINT_PRICE * _quantity <= msg.value, "Not enough minting fees");
        whitelist[msg.sender] -= _quantity;
        mint(_to,_quantity);
    }

    // Public Mint
    function publicNFTMint(address _to, uint32 _quantity) public payable nonReentrant {
        require(_quantity > 0,"Invalid mint quantity");
        require(pubMintActive, "Public mint not started");
        require(PUBLIC_MINT_PRICE * _quantity <= msg.value, "Not enough minting fees");
        mint(_to,_quantity);
    }

    // Activates Minting Status 
    function setMintStatus(
        bool _teamMintActive,
        bool _airdropMintActive,
        bool _whitelistMintActive,
        bool _pubMintActive
    ) external onlyOwner {
        teamMintActive = _teamMintActive;
        airdropMintActive = _airdropMintActive;
        whitelistMintActive = _whitelistMintActive;
        pubMintActive = _pubMintActive;

        emit mintingStatus(
            teamMintActive,
            airdropMintActive,
            whitelistMintActive,
            pubMintActive
        );
    }

    // Add new addreses to whitelist and the amount of NFT's that each address could mint
    function setWhitelist(
        address[] calldata _listAddress,
        uint32[] calldata _amount,
        uint8 _listStage
    ) external onlyOwner{
        require(_listStage >0 && _listAddress.length == _amount.length, "Input mismatch");
        for(uint32 i=0; i< uint32(_amount.length); ++i){
            if(_listStage == 1){
                whitelist[_listAddress[i]]=_amount[i]; 
            }else if(_listStage == 2){
                teamWhitelist[_listAddress[i]]= _amount[i];
            }
        }
    } 

    function _authorizeUpgrade(address) internal override onlyOwner {}
}