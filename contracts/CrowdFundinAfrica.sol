// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

/**
 * @title CrowdFundinAfrica
 * @dev A contract for creating and managing crowdfunding campaigns in Africa.
 */
contract CrowdFundinAfrica {
    struct Campaign {
        address owner;          // Address of the campaign owner
        string title;           // Title of the campaign
        string description;     // Description of the campaign
        uint256 target;         // Target amount to be raised
        uint256 deadline;       // Deadline for the campaign
        uint256 amountCollected;    // Amount collected so far
        string image;           // Image associated with the campaign
        address[] donators;     // Addresses of the campaign donators
        uint256[] donations;    // Amounts donated by each donator
    }

    mapping(uint256 => Campaign) public campaigns;    // Mapping of campaign IDs to Campaign structs

    uint256 public numberOfCampaigns = 0;    // Total number of campaigns created

    constructor() {}

    /**
     * @dev Creates a new crowdfunding campaign.
     * @param _owner The address of the campaign owner
     * @param _title The title of the campaign
     * @param _description The description of the campaign
     * @param _target The target amount to be raised
     * @param _deadline The deadline for the campaign
     * @param _image The image associated with the campaign
     * @return The ID of the newly created campaign
     */
    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public returns (uint256) {
        Campaign memory campaign = campaigns[numberOfCampaigns];
        
        // Check if the deadline is a date in the future
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

    /**
     * @dev Allows a user to donate to a campaign.
     * @param _campaignId The ID of the campaign
     */
    function donateToCampaign(uint256 _campaignId) public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_campaignId];
        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        if (sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    /**
     * @dev Returns the list of donators and their donations for a campaign.
     * @param _campaignId The ID of the campaign
     * @return The addresses of the donators and the amounts donated
     */
    function getDonators(
        uint256 _campaignId
    ) public view returns (address[] memory, uint256[] memory) {
        Campaign storage selectedCampaign = campaigns[_campaignId];
        return (selectedCampaign.donators, selectedCampaign.donations);
    }

    /**
     * @dev Returns all the campaigns created.
     * @return An array of all the campaigns
     */
    function getCampains() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);
        for (uint256 i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];

            allCampaigns[i] = item;
        }
        return allCampaigns;
    }

    /**
     * @dev Returns the details of a specific campaign.
     * @param _campaignId The ID of the campaign
     * @return The details of the campaign
     */
    function getCampaign(uint256 _campaignId)
        public
        view
        returns (Campaign memory)
    {
        require(_campaignId < numberOfCampaigns, "Invalid campaign id");
        return campaigns[_campaignId];
    }

    /**
     * @dev Removes a campaign.
     * @param _campaignId The ID of the campaign
     */
    function removeCampaign(uint256 _campaignId) public {
        require(_campaignId < numberOfCampaigns, "Invalid campaign id");
        require(
            campaigns[_campaignId].owner == msg.sender,
            "You are not the owner of this campaign"
        );

        for (uint256 i = _campaignId; i < numberOfCampaigns - 1; i++) {
            campaigns[i] = campaigns[i + 1];
        }

        delete campaigns[numberOfCampaigns - 1];
        numberOfCampaigns--;
    }
}
