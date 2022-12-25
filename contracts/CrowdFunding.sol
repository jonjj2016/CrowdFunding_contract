// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

error CrowdFunding__Deadline();

contract CrowdFunding {
    struct Compaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donaters;
        uint256[] donations;
    }
    mapping(uint256 => Compaign) public compaigns;

    uint256 numberOfComaigns = 0;

    constructor() {}

    function cerateCompaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public returns (uint256) {
        Compaign storage compaign = compaigns[numberOfComaigns];
        compaign.deadline = _deadline;
        if (compaign.deadline < block.timestamp)
            revert CrowdFunding__Deadline();
        compaign.owner = _owner;
        compaign.title = _title;
        compaign.description = _description;
        compaign.target = _target;
        compaign.deadline = _deadline;
        compaign.amountCollected = 0;
        compaign.image = _image;
        numberOfComaigns++;

        return numberOfComaigns - 1;
    }

    function donateToCompaign(uint256 _id) public payable {
        uint256 amount = msg.value;
        Compaign storage compaign = compaigns[_id];
        compaign.donaters.push(msg.sender);
        compaign.donations.push(amount);
        (bool sent, ) = (compaign.owner).call{value: amount}("");
        if (sent) {
            compaign.amountCollected = compaign.amountCollected + amount;
        }
    }

    function getDonators(
        uint256 _id
    ) public view returns (address[] memory, uint256[] memory) {
        return (compaigns[_id].donaters, compaigns[_id].donations);
    }

    function getCompaigns() public view returns (Compaign[] memory) {
        Compaign[] memory allCompaigns = new Compaign[](numberOfComaigns);
        for (uint i = 0; i < numberOfComaigns; i++) {
            Compaign storage item = compaigns[i];
            allCompaigns[i] = item;
        }
        return allCompaigns;
    }
}
