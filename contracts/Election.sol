// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

contract Election {

    uint public electionEndTime;
    uint public totalVotes;
    uint public winningPercentage;
    uint public participation;
    address public electionController;
    address public winner;
    address[] public candidates;
    address[] public voters;
    mapping(address => uint) internal candidateVoteCount;
    mapping(address => bool) internal checkVoteStatus;
    mapping(address => address) internal whoYouVotedFor;
    
    modifier onlyElectionController() {
        require(msg.sender == electionController, "You aren't the election controller!");
        _;
    }

    modifier duringElection{
        require(block.timestamp < electionEndTime, "The election isn't taking place at this time!");
        _;
    }

    modifier afterElection {
        require(block.timestamp >= electionEndTime, "The election hasn't ended yet!");
        _;
    }

    /* Pass in an array of voters & candidates. 
     * Choose the election controller.
     * Select seconds/days/weeks [0 ==> seconds, 1 ==> days, 2 ==> weeks]
     * Then select how many seconds/days/weeks the election will last.
     */
    constructor(address[] memory _voters, address[] memory _candidates, address _electionController, uint _timeType, uint _timeQuantity) {
        require(((_timeType == 0) || (_timeType == 1) || (_timeType == 2)) && _timeQuantity > 0, "Not an acceptable entry for _timeType/_timeQuantity.");
        if (_timeType == 0) {
            electionEndTime = block.timestamp + (_timeQuantity * 1 seconds);
        }
        else if (_timeType == 1) {
            electionEndTime = block.timestamp + (_timeQuantity * 1 days);
        }
        else {
            electionEndTime = block.timestamp + (_timeQuantity * 1 weeks);
        }
        voters = _voters;
        candidates = _candidates;
        removeDuplicateVoters();
        removeDuplicateCandidates();
        electionController = _electionController;
    }

    // Deletes duplicate voters.
    function removeDuplicateVoters() private {
        for (uint i = 0; i < voters.length; i++) {
            for (uint j = i+1; j < voters.length; j++){
                if (voters[j] == voters[i]) {
                    delete voters[j];
                }
            }
        }
    }

    // Deletes duplicate candidates.
    function removeDuplicateCandidates() private {
        for (uint i = 0; i < candidates.length; i++) {
            for (uint j = i+1; j < candidates.length; j++){
                if (candidates[j] == candidates[i]) {
                    delete candidates[j];
                }
            }
        }
    }

    // The msg.sender votes for the specified candidate.
    function vote(address _candidate) public duringElection {
        isAnApprovedVoter(msg.sender);
        isAnApprovedCandidate(_candidate);
        if(checkVoteStatus[msg.sender]) {
            revert("You've already voted");
        }
        whoYouVotedFor[msg.sender] = _candidate;
        checkVoteStatus[msg.sender] = true;
        candidateVoteCount[_candidate] += 1;
        totalVotes++;
    }

    // Let's the msg.sender know if they have voted & who they have voted for.
    function checkVotingStatus() external view returns (bool _votingStatus, address _whoYouVotedFor) {
        isAnApprovedVoter(msg.sender);
        if (!checkVoteStatus[msg.sender]) {
            return (false, whoYouVotedFor[msg.sender]);
        }
        else {
            return (true, whoYouVotedFor[msg.sender]);
        }
    }

    // Returns the percent of voters who have currently voted.
    function percentOfVotesCast() public view returns (uint) {
        uint totalVoters = 0;
        // This for loop doesn't count the 0x0 addresses in the voters array.
        for (uint i = 0; i < voters.length; i++) {
            if (voters[i] != address(0)) {
                totalVoters++;
            }
        }
        return ((100*totalVotes)/totalVoters) ;
    }

    // Returns the results of the election [winner, candidate winning percentage , election participation].
    function finishElection() external onlyElectionController afterElection returns(address _winner, uint _winnerPercentageOfVotes, uint _participation) {
        uint _winningCount = 0;
        for(uint i = 0; i < candidates.length; i++) {
            if(candidateVoteCount[candidates[i]] >= _winningCount) {
                _winningCount = candidateVoteCount[candidates[i]];
                _winner = candidates[i];
            }
        }
        winner = _winner;
        _winnerPercentageOfVotes = (100 * _winningCount)/totalVotes;
        winningPercentage = _winnerPercentageOfVotes;
        _participation = percentOfVotesCast();
        participation = _participation;
        return (_winner, _winnerPercentageOfVotes, _participation);
    }

    // Checks to see if the supplied address is in the voters array.
    function isAnApprovedVoter(address _voter) public view {
        require(_voter != address(0), "Not an approved voter!");
        for(uint i = 0; i < voters.length; i++) {
            if(_voter == voters[i]) {
                break;
            }
            else if(i == (voters.length - 1)) {
                revert("Not an approved voter!");
            }
        }
    }

    // Checks to see if the supplied address is in the candidates array.
    function isAnApprovedCandidate(address _candidate) public view {
        require(_candidate != address(0), "Not an approved candidate!");
        for(uint i = 0; i < candidates.length; i++) {
            if(_candidate == candidates[i]) {
                break;
            }
            else if(i == (candidates.length - 1)) {
                revert("Not an approved candidate!");
            }
        }
    }

}