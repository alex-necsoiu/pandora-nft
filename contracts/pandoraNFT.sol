// SPDX-License-Identifier: MIT
pragma solidity  >=0.8.11 <0.8.18;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


/**
 * @title Pandora NFT Contract
 * @dev A non-fungible token contract that allows for minting NFTs by the team, airdrop, whitelist, and public sale. The contract also implements URI standards and utilizes OpenZeppelin libraries for upgrades, ownership, and reentrancy guard.
 */
contract pandoraNFT is
    ERC721EnumerableUpgradeable,
    OwnableUpgradeable,
    ReentrancyGuardUpgradeable,
    UUPSUpgradeable
{
    // Route of the URL of the images stored on IPFS
    string private baseURI;

    // Public team minting price
    uint64 private constant TEAM_MINT_PRICE = 0.001 ether;

    // Public whitelist minting price
    uint64 private constant WHITELIST_MINT_PRICE = 0.003 ether;

    // Public minting price
    uint64 private constant PUBLIC_MINT_PRICE = 0.005 ether;

    // Total supply
    uint32 public constant MAX_SUPPLY = 1000;

    // Flags to activate or deactivate different stages of minting
    bool public teamMintActive; // Only private whitelist
    bool public airdropMintActive; // Minted only by the contract owner
    bool public whitelistMintActive; // Only preregistered whitelist
    bool public pubMintActive; // Open to public sale

    // Whitelists
    mapping(address => uint32) public whitelist;
    mapping(address => uint32) public teamWhitelist;

    // Current index of the NFT
    using Counters for Counters.Counter;
    Counters.Counter private supply;

    // Address of the treasury that will own 50% of the NFTs on initialization of the contract
    address public treasury;

    /**
     * @dev Emitted when the minting status is updated.
     * @param teamMintActive True if team minting is active, false otherwise.
     * @param airdropMintActive True if airdrop minting is active, false otherwise.
     * @param whitelistMintActive True if whitelist minting is active, false otherwise.
     * @param pubMintActive True if public minting is active, false otherwise.
     */
    event mintingStatus(
        bool teamMintActive,
        bool airdropMintActive,
        bool whitelistMintActive,
        bool pubMintActive
    );

    /**
     * @dev Initializes the contract by setting the base URI, max supply, and transferring ownership to a new address.
     * @param _treasury The address of the treasury that will own 50% of the NFTs on initialization of the contract.
     * @param _newOwner The address that will become the owner of the contract.
     */
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

    /**
     * @dev Mint NFTs and assign them to the given address. 
     * @param _to The address to which the NFTs should be assigned.
     * @param _quantity The quantity of NFTs to mint.
     * @notice To save gas, since we know _quantity won't overflow, checks are performed in caller functions/methods.
     * @notice The maximum supply of NFTs that can be minted has already been reached.
     * @notice Reverts if the minting process has been paused.
     */

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

    /**
     * @dev Allows the team to mint the first 20 rare NFT's of the collection.
     *
     * Requirements:
     * - `_quantity` must be greater than zero.
     * - Team Mint must be active.
     * - The value sent with the transaction must be at least `_quantity * TEAM_MINT_PRICE`.
     * - `_to` must be a valid Ethereum address.
     * - `msg.sender` must have at least `_quantity` NFT's available to mint.
     *
     * Emits a {Mint} event with `_to` and `_quantity` as arguments.
     */
    function teamNFTMint(address _to, uint32 _quantity) external payable nonReentrant{
        require(_quantity > 0,"Invalid mint quantity");
        require(teamMintActive, "Team Mint not started");
        require(TEAM_MINT_PRICE * _quantity <= msg.value, "Not enough minting fees");
        require(teamWhitelist[msg.sender] >= _quantity, "NFT's not available for this address");
        teamWhitelist[msg.sender] -= _quantity;
        mint(_to,_quantity);
    }

    /**
     * @dev Airdrop Mint giveaway for founders and partners
     *
     * Requirements:
     * - `_to` must be a valid address.
     * - `_quantity` must be greater than 0.
     * - Airdrop mint must be active.
     */
    function airdropNFTMint(address _to, uint32 _quantity) external onlyOwner {
        require(_quantity > 0,"Invalid mint quantity");
        require(airdropMintActive, "Airdrop mint not started");
        mint(_to,_quantity);
    }

    /**
     * @dev Whitelist Mint 
     *
     * Requirements:
     * - `_to` must be a valid address.
     * - `_quantity` must be greater than 0.
     * - Whitelist mint must be active.
     * - `msg.sender` must have enough NFTs available.
     * - The value sent must be enough to cover the minting fees.
     */
    function whitelistNFTMint(address _to, uint32 _quantity) public payable nonReentrant {
        require(_quantity > 0,"Invalid mint quantity");
        require(whitelistMintActive, "Whitelist mint not started");
        require(whitelist[msg.sender] >= _quantity, "NFT's not available for this address");
        require(WHITELIST_MINT_PRICE * _quantity <= msg.value, "Not enough minting fees");
        whitelist[msg.sender] -= _quantity;
        mint(_to,_quantity);
    }

    /**
     * @dev Public Mint
     *
     * Requirements:
     * - `_to` must be a valid address.
     * - `_quantity` must be greater than 0.
     * - Public mint must be active.
     * - The value sent must be enough to cover the minting fees.
     */
    function publicNFTMint(address _to, uint32 _quantity) public payable nonReentrant {
        require(_quantity > 0,"Invalid mint quantity");
        require(pubMintActive, "Public mint not started");
        require(PUBLIC_MINT_PRICE * _quantity <= msg.value, "Not enough minting fees");
        mint(_to,_quantity);
    }

    /**
     * @dev Activates or deactivates minting status.
     * @param _teamMintActive Whether the team mint is active.
     * @param _airdropMintActive Whether the airdrop mint is active.
     * @param _whitelistMintActive Whether the whitelist mint is active.
     * @param _pubMintActive Whether the public mint is active.
     */
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

    /**
     * @dev Adds new addresses to the whitelist and the amount of NFT's that each address could mint.
     * @param _listAddress Array of addresses to be added to the whitelist.
     * @param _amount Array of the amounts of NFT's that each address could mint.
     * @param _listStage The stage of the whitelist, either 1 for the main whitelist or 2 for the team whitelist.
     */
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
    
    /**
     * @dev Authorizes the upgrade of the contract by the owner
     */
    function _authorizeUpgrade(address) internal override onlyOwner {}

    /**
     * @dev Transfers all ether in the contract to the treasury
     */
    function transferToTreasury() external nonReentrant onlyOwner {
        (bool sent, ) = treasury.call{value: address(this).balance}("");
        require(sent, "failed to send eth to treasury");
    }

    /**
     * @dev Sets the base URI for the NFT file
     * @param uri The new base URI to set
     */
    function setBaseURI(string memory uri) external onlyOwner {
        baseURI = uri;
    }

    /**
     * @dev Returns the current base URI
     * @return The current base URI string
     */
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    /**
     * @dev Allows the contract owner to withdraw any ether that might be locked in the contract
     */
    function emergencyWithdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    /**
     * @dev Returns the total supply of NFTs minted
     * @return The total supply of NFTs
     */
    function getSupply() external view returns (uint32) {
        return uint32(supply.current());
    }

    /**
     * @dev Returns the amount of NFTs that the specified address is allowed to mint
     * @param _address The address to check the whitelist for
     * @return The number of NFTs the address is allowed to mint
     */
    function getWhitelist(address _address) external view returns (uint32) {
        return whitelist[_address];
    }

    /**
     * @notice Returns the amount of NFT's that an address is allowed to mint during the team whitelist stage
     * @param _address The address to check the whitelist for
     * @return The amount of NFT's that the address is allowed to mint
     */
    function getTeamWhitelist(address _address) external view returns (uint32) {
        return teamWhitelist[_address];
    }

}