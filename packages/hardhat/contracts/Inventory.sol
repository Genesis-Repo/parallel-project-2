// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract Inventory is Ownable, ERC721Enumerable {
    struct Warehouse {
        string name;
        string description;
        uint256 opens_at;
        uint256 closed_at;
    }
    
    struct Article {
        string name;
        string description;
        uint256 price;
        string image;
        address warehouseAddress;
    }

    mapping(address => Warehouse) private warehouses;
    mapping(uint256 => Article) private articles;
    uint256 private nextArticleId = 1;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    // Function to create a new warehouse with specified details
    function createWarehouse(string memory _name, string memory _description, uint256 _opens_at, uint256 _closed_at) external {
        require(_opens_at < _closed_at, "opens_at must be before closed_at");
        warehouses[msg.sender] = Warehouse(_name, _description, _opens_at, _closed_at);
    }

    // Function to get the details of a warehouse owned by an address
    function getWarehouseDetails(address _owner) external view returns (string memory, string memory, uint256, uint256) {
        Warehouse memory warehouse = warehouses[_owner];
        return (warehouse.name, warehouse.description, warehouse.opens_at, warehouse.closed_at);
    }

    // Function to create a new article linked to a warehouse
    function createArticle(string memory _name, string memory _description, uint256 _price, string memory _image, address _warehouseAddress) external {
        articles[nextArticleId] = Article(_name, _description, _price, _image, _warehouseAddress);
        _safeMint(msg.sender, nextArticleId);
        nextArticleId++;
    }

    // Function to retrieve details of an article by its ID
    function getArticleDetails(uint256 _articleId) external view returns (string memory, string memory, uint256, string memory, address) {
        Article memory article = articles[_articleId];
        return (article.name, article.description, article.price, article.image, article.warehouseAddress);
    }

    // Function to update details of an existing article
    function updateArticle(uint256 _articleId, string memory _name, string memory _description, uint256 _price, string memory _image) external {
        Article storage article = articles[_articleId];
        article.name = _name;
        article.description = _description;
        article.price = _price;
        article.image = _image;
    }
}