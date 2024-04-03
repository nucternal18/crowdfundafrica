// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFundinAfrica {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    mapping(uint256 => Campaign) public campaigns;

    uint256 public numberOfCampaigns = 0;

    constructor() {}

    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public returns (uint256) {
        Campaign memory campaign = campaigns[numberOfCampaigns];
        // is everything okay
        require(
            campaign.deadline < block.timestamp,
            "The deadline should be a date in the future"
        );
        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;

        return numberOfCampaigns - 1;
    }

    function donateToCampaign(uint256 _campaignId) public payable {
        Campaign storage selectedCampaign = campaigns[_campaignId];
        selectedCampaign.amountCollected += msg.value;
        selectedCampaign.donators.push(msg.sender);
        selectedCampaign.donations.push(msg.value);
    }

    function getDonators(
        uint256 _campaignId
    ) public view returns (address[] memory) {
        Campaign storage selectedCampaign = campaigns[_campaignId];
        return selectedCampaign.donators;
    }

    function getCampains() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);
        for (uint256 i = 0; i < numberOfCampaigns; i++) {
            allCampaigns[i] = campaigns[i];
        }
        return allCampaigns;
    }
}
