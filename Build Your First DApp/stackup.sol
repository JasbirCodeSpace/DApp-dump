// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract StackUp {
    enum PlayerQuestStatus {
        NOT_JOINED,
        JOINED,
        SUBMITTED,
        REJECTED,
        APPROVED
    }

    struct Quest {
        uint256 questId;
        uint256 numberOfPlayers;
        string title;
        uint8 reward;
        uint256 numberOfRewards;
        uint256 startTime;
        uint256 endTime;
        bool isDeleted;
    }

    struct Campaign {
        uint256 campaignId;
        string name;
        uint256[] questIds;
    }

    address public admin;
    uint256 public nextQuestId;
    uint256 public nextCampaignId;
    mapping(uint256 => Quest) public quests;
    mapping(address => mapping(uint256 => PlayerQuestStatus)) public playerQuestStatuses;
    mapping(uint256 => Campaign) public campaigns;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can perform this action");
        _;
    }

    modifier questExists(uint256 questId) {
        require(quests[questId].reward != 0, "Quest does not exist");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /**
     * @dev Create a new quest.
     * @param title_ The title of the quest.
     * @param reward_ The reward amount for completing the quest.
     * @param numberOfRewards_ The number of rewards available for the quest.
     * @param startTime_ The start time of the quest.
     * @param endTime_ The end time of the quest.
     */
    function createQuest(
        string calldata title_,
        uint8 reward_,
        uint256 numberOfRewards_,
        uint256 startTime_,
        uint256 endTime_
    ) external onlyAdmin {
        quests[nextQuestId].questId = nextQuestId;
        quests[nextQuestId].title = title_;
        quests[nextQuestId].reward = reward_;
        quests[nextQuestId].numberOfRewards = numberOfRewards_;
        quests[nextQuestId].startTime = startTime_;
        quests[nextQuestId].endTime = endTime_;
        nextQuestId++;
    }

    /**
     * @dev Edit the details of a quest.
     * @param questId The ID of the quest to edit.
     * @param title_ The new title of the quest.
     * @param reward_ The new reward amount for completing the quest.
     * @param numberOfRewards_ The new number of rewards available for the quest.
     * @param startTime_ The new start time of the quest.
     * @param endTime_ The new end time of the quest.
     */
    function editQuest(
        uint256 questId,
        string calldata title_,
        uint8 reward_,
        uint256 numberOfRewards_,
        uint256 startTime_,
        uint256 endTime_
    ) external onlyAdmin questExists(questId) {
        Quest storage quest = quests[questId];
        quest.title = title_;
        quest.reward = reward_;
        quest.numberOfRewards = numberOfRewards_;
        quest.startTime = startTime_;
        quest.endTime = endTime_;
    }

    /**
     * @dev Delete a quest.
     * @param questId The ID of the quest to delete.
     */
    function deleteQuest(uint256 questId) external onlyAdmin questExists(questId) {
        Quest storage quest = quests[questId];
        quest.isDeleted = true;
    }

    /**
     * @dev Allow a player to join a quest.
     * @param questId The ID of the quest to join.
     */
    function joinQuest(uint256 questId) external questExists(questId) {

        Quest storage quest = quests[questId];
        require(
        playerQuestStatuses[msg.sender][questId] == PlayerQuestStatus.NOT_JOINED,
        "Player has already joined/submitted this quest"
        );

        require(
        quest.startTime <= block.timestamp && block.timestamp <= quest.endTime,
        "Quest has not started or has already ended"
        );

        playerQuestStatuses[msg.sender][questId] = PlayerQuestStatus.JOINED;
        quest.numberOfPlayers++;
    }

    /**
    * @dev Allow a player to submit a quest.
    * @param questId The ID of the quest to submit.
    */
    function submitQuest(uint256 questId) external questExists(questId) {
        require(
            playerQuestStatuses[msg.sender][questId] == PlayerQuestStatus.JOINED,
            "Player must first join the quest"
        );
        playerQuestStatuses[msg.sender][questId] = PlayerQuestStatus.SUBMITTED;
    }

    /**
    * @dev Review a player's quest submission and either approve or reject it.
    * @param questId The ID of the quest.
    * @param player The address of the player.
    * @param approved Boolean indicating whether the submission is approved or rejected.
    * @param reward The reward amount to be given if the submission is approved.
    */
    function reviewQuest(
        uint256 questId,
        address player,
        bool approved,
        uint8 reward
    ) external onlyAdmin questExists(questId) {
        require(
            playerQuestStatuses[player][questId] == PlayerQuestStatus.SUBMITTED,
            "Player has not submitted the quest"
        );
        require(reward <= quests[questId].numberOfRewards, "Invalid reward amount");

        if (approved) {
            playerQuestStatuses[player][questId] = PlayerQuestStatus.APPROVED;
            // Reward the player with the specified reward amount
        } else {
            playerQuestStatuses[player][questId] = PlayerQuestStatus.REJECTED;
        }
    }

    /**
    * @dev Create a new campaign.
    * @param name The name of the campaign.
    * @param questIds The array of quest IDs included in the campaign.
    */
    function createCampaign(string calldata name, uint256[] calldata questIds) external onlyAdmin {
        campaigns[nextCampaignId].campaignId = nextCampaignId;
        campaigns[nextCampaignId].name = name;
        campaigns[nextCampaignId].questIds = questIds;
        nextCampaignId++;
    }

    /**
    * @dev Get the quest IDs of a campaign.
    * @param campaignId The ID of the campaign.
    * @return An array of quest IDs included in the campaign.
    */
    function getCampaignQuests(uint256 campaignId) external view returns (uint256[] memory) {
        return campaigns[campaignId].questIds;
    }
}