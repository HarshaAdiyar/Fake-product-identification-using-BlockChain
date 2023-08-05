// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;
import "hardhat/console.sol";

contract FPI
{
    address public owner;

    constructor() 
    {
		owner = msg.sender;
	}

    uint productId = 0;

    struct Manufacturer
    {
        bool exists;
        string Name;
        address _address;
    }

    struct Product
    {
        uint id;
		string name;
		string model;
		address manufacturer;
		address curOwner;
        address[] owners;
    }

    mapping(address => Manufacturer) public manufacturers;
	mapping(uint => Product) public products;

    event ManufacturerCreated(string name, address _address);
	event ProductCreated(uint id, address manufacturer);
	event OwnershipUpdated(uint id, address newOwner);


    function createManufacturer(string memory name, address _address) public 
    {
		require(msg.sender == owner, "Only OWNER can create a Manufacturer!!!");
		Manufacturer storage m = manufacturers[_address];
        m.exists=true;
		m.Name = name;
		m._address = _address;
		emit ManufacturerCreated(name, _address);
        console.log("Manufacturer Created...");
	}

    function createProduct(string memory _name, string memory _model) public
    {
		require(manufacturers[msg.sender].exists == true,"You are not a Manufacturer!!!");

		Product storage p = products[productId];
		p.id = productId;
		p.name = _name;
		p.model = _model;
		p.manufacturer = msg.sender;
		p.curOwner = msg.sender;
        p.owners.push(msg.sender);
		productId++;
		emit ProductCreated(productId-1, msg.sender);
        console.log("Product Created...");
	}

    function updateOwnership(uint _productId, address _newOwner) public 
    {
		Product storage p = products[_productId];
		require(p.curOwner == msg.sender, "Not authorized to change ownership!!!");
		
		p.curOwner = _newOwner;
        p.owners.push(_newOwner);
		emit OwnershipUpdated(_productId, _newOwner);
        console.log("Ownership Updated...");
	}

    function checkProductAuthentication(uint _productId,address _owner) public view returns(string memory)
    {
        Product storage p = products[_productId];

        if(p.curOwner==_owner)
        {
            return "Authentic Product";
        }

        else
        {
            return "Fake Product";
        }
    }

    function getOwnersOfProduct(uint _productId) public view returns(address[] memory)
    {
        Product storage p = products[_productId];
        return p.owners;
    }

}