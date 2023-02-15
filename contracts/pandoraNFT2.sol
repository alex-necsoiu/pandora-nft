/**
 * @title Pandora NFT
 * @dev This contract implements a basic NFT (Non-Fungible Token) with some additional
 * functionality specific to Pandora. The contract allows users to mint new tokens,
 * transfer tokens to other users, and burn tokens they no longer want. Each token
 * represents ownership of a unique piece of content created by a Pandora user.
 */
contract pandoraNFT {
    /**
     * @dev This struct represents a single NFT, including its owner and content ID.
     */
    struct NFT {
        address owner; // Address of the NFT's owner
        uint256 contentId; // ID of the content associated with the NFT
    }
    
    /**
     * @dev This event is emitted whenever a new NFT is minted.
     * @param tokenId The ID of the newly minted NFT
     * @param owner The address of the new owner of the NFT
     * @param contentId The ID of the content associated with the NFT
     */
    event NFTMinted(uint256 tokenId, address owner, uint256 contentId);
    
    /**
     * @dev This event is emitted whenever an NFT is transferred to a new owner.
     * @param tokenId The ID of the NFT that was transferred
     * @param from The address of the old owner of the NFT
     * @param to The address of the new owner of the NFT
     */
    event NFTTransferred(uint256 tokenId, address from, address to);
    
    /**
     * @dev This event is emitted whenever an NFT is burned (destroyed).
     * @param tokenId The ID of the NFT that was burned
     */
    event NFTBurned(uint256 tokenId);
    
    mapping(uint256 => NFT) public nfts; // Mapping of token IDs to NFTs
    
    uint256 public totalSupply; // Total number of NFTs that have been minted
    
    /**
     * @dev This function allows a user to mint a new NFT for a given content ID.
     * @param contentId The ID of the content to associate with the new NFT
     * @return The ID of the newly minted NFT
     */
    function mintNFT(uint256 contentId) external returns (uint256) {
        require(contentId > 0, "Content ID must be greater than zero");
        
        // Increment the total supply and generate a new token ID
        totalSupply++;
        uint256 tokenId = totalSupply;
        
        // Create a new NFT and add it to the mapping
        NFT memory newNFT = NFT(msg.sender, contentId);
        nfts[tokenId] = newNFT;
        
        // Emit an event to indicate that a new NFT was minted
        emit NFTMinted(tokenId, msg.sender, contentId);
        
        // Return the ID of the newly minted NFT
        return tokenId;
    }
    
    /**
     * @dev This function allows the owner of an NFT to transfer it to a new owner.
     * @param tokenId The ID of the NFT to transfer
     * @param to The address of the new owner of the NFT
     */
    // function transferNFT(uint256 tokenId, address to) external {
    //     // Ensure that the sender is the current owner of the NFT
    //     require(nfts[tokenId].owner == msg.sender, "Sender must be the current owner of
    }