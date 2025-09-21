// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title BasedCertificate
 * @dev NFT-based certificate system for achievements, graduation, or training
 * Features:
 * - Soulbound (non-transferable)
 * - Metadata for certificate details
 * - Issuer-controlled (onlyOwner)
 */
contract BasedCertificate is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    uint256 private _nextTokenId;

    struct CertificateData {
        string recipientName;
        string course;
        string issuer;
        uint256 issuedDate;
        bool valid;
    }

    // --- Mappings ---
    // TODO: Add mappings
    // mapping(uint256 => CertificateData) public certificates;
    // mapping(address => uint256[]) public ownerCertificates; // Track all certs per owner
    // mapping(string => uint256) public certHashToTokenId; // Prevent duplicate certificate by hash

    mapping(uint256 => CertificateData) public certificates;
    mapping(address => uint256[]) public ownerCertificates; // Track all certs per owner
    mapping(string => uint256) public certHashToTokenId; // Prevent duplicate certificate by hash

    // --- Events ---
    event CertificateIssued(
        uint256 indexed tokenId,
        address recipient,
        string course,
        string issuer
    );
    event CertificateRevoked(uint256 indexed tokenId);
    event CertificateUpdated(uint256 indexed tokenId, string newCourse);
    //kalau nggak ada Events, nggak bisa diemit

    constructor() ERC721("Based Certificate", "BCERT") Ownable(msg.sender) {}

    /**
     * @dev Issue a new certificate
     * Use case: Awarding completion or graduation
     */
    function issueCertificate(
        address to,
        string memory recipientName,
        string memory course,
        string memory issuer,
        string memory uri
    ) public onlyOwner {
        // TODO: Implement issuance

        uint256 tokenId = _nextTokenId;
        _nextTokenId++;

        // 1. Check duplicate (optional: via hash)
        string memory certHash = string(abi.encodePacked(to, course, issuer));
        require(certHashToTokenId[certHash] == 0, "Certificate keduplikat euy");

        // 2. Mint new NFT
        _safeMint(to, tokenId);

        // 3. Set token URI (certificate metadata file)
        _setTokenURI(tokenId, uri);

        // 4. Save certificate data
        certificates[tokenId] = CertificateData ({
            recipientName: recipientName,
            course: course,
            issuer: issuer,
            issuedDate: block.timestamp,
            valid: true
        });

        // 5. Update mappings
        ownerCertificates[to].push(tokenId); // dipush ke paling depan
        certHashToTokenId[certHash] = tokenId;

        // 6. Emit event
        emit CertificateIssued(tokenId, to, course, issuer);
    }

    /**
     * @dev Revoke a certificate (e.g. if mistake or fraud)
     */
    function revokeCertificate(uint256 tokenId) public onlyOwner {
        // TODO: Check token exists
        require(_ownerOf(tokenId) != address(0), "Certificate nggak ada!?");

        // Mark certificate invalid
        certificates[tokenId].valid=false;

        // Emit event
        emit CertificateRevoked(tokenId);
    }

    /**
     * @dev Update certificate data (optional, for corrections)
     */
    function updateCertificate(uint256 tokenId, string memory newCourse) public onlyOwner {
        // TODO: Check token exists
        require(_ownerOf(tokenId) != address(0), "Certificate nggak ada!?");

        // Update course field
        certificates[tokenId].course= newCourse;

        // Emit event
        emit CertificateUpdated(tokenId, newCourse);
    }

    /**
     * @dev Get all certificates owned by an address
     */
    function getCertificatesByOwner(address owner)
        public
        view
        returns (uint256[] memory)
    {
        // TODO: Return certificate based on owner
        return ownerCertificates[owner];
    }
    
    /**
    * @dev Burn a certificate (soulbound cleanup)
    */
    function burnCertificate(uint256 tokenId) public onlyOwner {
        address owner = _ownerOf(tokenId);
        require(owner != address(0), "BCERT: token nggak ada!?");
        
        // --- Clean up mappings before burning ---
        CertificateData storage certData = certificates[tokenId];
        string memory certHash = string(abi.encodePacked(owner, certData.course, certData.issuer));

        delete certHashToTokenId[certHash]; //hapus dari certHashToTokenId mapping
        // --- Burn the NFT ---
        uint256[] storage tokenIds = ownerCertificates[owner]; // burn dari array ownerCertificates
        for (uint i = 0; i < tokenIds.length; i++) {
            if (tokenIds[i] == tokenId) {
                tokenIds[i] = tokenIds[tokenIds.length - 1];
                tokenIds.pop(); // pop tail, yg paling belakang dihapus
                break;
            }
        }

        delete certificates[tokenId]; // hapus dari certificates mapping

        //super._burn(tokenId);
        _burn(tokenId);
    }

   /**
     * @dev Override transfer functions to make non-transferable (soulbound)
     */
    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override returns(address){
        // TODO: Only allow minting (from == address(0)) and burning (to == address(0))
         address from = _ownerOf(tokenId); // ambil address pemilkiknya duls

        require(from == address(0) || to == address(0), "Certificates tidak bisa dipindah tangan");
        return super._update(to, tokenId, auth); // super keyword yang dipake untuk ngambil kontrak induk
    }

    // --- Overrides for multiple inheritance ---

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
