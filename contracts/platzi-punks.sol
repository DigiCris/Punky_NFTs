// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./PlatziPunksDna.sol";
import "./Base64.sol";

contract PlatziPunks is ERC721, ERC721Enumerable, Ownable, PlatziPunksDNA {
    using Counters for Counters.Counter;
    using Strings for uint256; //sobrecargando funcionalidades

    uint256 public maxSupply;
    mapping(uint256 => uint256) private tokenDNA;

    Counters.Counter private _tokenIdCounter;

    constructor(uint256 _maxSupply) ERC721("PlatziPunks", "plpks") 
    {
        maxSupply= _maxSupply;
    }

    function mint() public {
        uint256 tokenId = _tokenIdCounter.current();
        require(maxSupply>tokenId,"No PlatziPunks left to mint");
        _tokenIdCounter.increment();
        tokenDNA[tokenId] = random(tokenId, msg.sender, block.timestamp);
        _safeMint(msg.sender, tokenId);
    }


    function _baseURI() internal pure override returns (string memory) {
        return "https://avataaars.io/";
    }

    function _paramsURI(uint256 _dna) private view returns (string memory) {
        string memory params;

        {
            params = string(
                abi.encodePacked(
                    "accessoriesType=",
                    getAccesoriesType(_dna),
                    "&clotheColor=",
                    getClotheColor(_dna),
                    "&clotheType=",
                    getClotheType(_dna),
                    "&eyeType=",
                    getEyeType(_dna),
                    "&eyebrowType=",
                    getEyeBrowType(_dna),
                    "&facialHairColor=",
                    getFacialHairColor(_dna),
                    "&facialHairType=",
                    getFacialHairType(_dna),
                    "&hairColor=",
                    getHairColor(_dna),
                    "&hatColor=",
                    getHatColor(_dna),
                    "&graphicType=",
                    getGraphicType(_dna),
                    "&mouthType=",
                    getMouthType(_dna),
                    "&skinColor=",
                    getSkinColor(_dna)
                )
            );
        }

        return string(abi.encodePacked(params, "&topType=", getTopType(_dna)));
    }

    function imageByDNA(uint256 _dna) public view returns (string memory) {
        string memory baseURI = _baseURI();
        string memory paramsURI = _paramsURI(_dna);

        return string(abi.encodePacked(baseURI, "?", paramsURI));
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721 Metadata: URI query for nonexistent token"
        );

        uint256 dna = tokenDNA[tokenId];
        string memory image = imageByDNA(dna);

        string memory jsonURI = Base64.encode(
            abi.encodePacked(
                '{ "name": "PlatziPunks #',
                tokenId.toString(),
                '", "description": "Platzi Punks are randomized Avataaars stored on chain", "image": "',
                image,
                '"}'
            )
        );

        return
            string(abi.encodePacked("data:application/json;base64,", jsonURI));
    }


    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

// deployed at 0xA0Fd124345842ECb09B1929d7e6a789Fa4c6f5F2 by 0x113e6dB376c8C004Bd43AAac931bd97B047b2E67
