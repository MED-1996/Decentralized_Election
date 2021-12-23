from brownie import Election, network, config
from scripts.helpful_scripts import get_account
import time

# You will add your own voters/candidates/election controller data, you must create some test accounts and add their private keys
# to the a .env file
voters = ['0x42422f1ed5389A6b74fD52Fb94fcD2d05C121fe0', '0x2bc2FD69D438e490be453AAA2222320131da4C39', '0x51b81E4E2bd3F64a7d51205Fb1D5126E487ceB16', '0xce10c539233571fcD2d13345dC1bec1cA80FA0e9']
candidates = ['0xEb8F5675fC1ca830de263866d78B855Fa7d0CF08', '0x75f280CbFfD4b2157D0a8FD761cB8F1F02B17250']
election_controller = '0x2a5d3e586379EcC976803830D8F0AAcEb873b37B'
time_type = 0 # 0 is seconds, 1 is days, 2 is weeks
time_quantity = 100

# This function deploy's a new Election contract.
def deploy_election():
    account = get_account(0)
    election = Election.deploy(voters, candidates, election_controller, time_type, time_quantity, {"from": account})
    print('Election Deployed!')
    return election

# This function casts a vote. The voter & candidate are taken in as args.
def vote(_voter, _candidate):
    
    # For the given voter, you must obtain their private key. This is neccesary for the election.vote() method to transact.
    account = 0
    if _voter == voters[0]:
        account = get_account(1)
    elif _voter == voters[1]:
        account = get_account(2)
    elif _voter == voters[2]:
        account = get_account(3)
    elif _voter == voters[3]:
        account = get_account(4)
    else:
        pass

    election = Election[-1]
    election.vote(_candidate, {"from": account})

    print(f'Congratulations {account}, you have voted for {_candidate}!')

# This function ends the election & prints out the election results. The election controller is the only account that can end the election.
def end_election():
    _election_controller = get_account(5)
    election = Election[-1]
    election.finishElection({"from": _election_controller})
    #(winner, winner_percentage, participation_percentage) = tx.return_value
    print(f'The winner of the election is {election.winner()}.')
    print(f'The percent of votes {election.winner()} had was %{election.winningPercentage()}.')
    print(f'The total participation in the election was %{election.participation()}.')

def main():
    # deploy election (this worked!) [T]
    deploy_election()
    # have a few votes (this worked![T])
    counter = 0
    for voter in voters:
        if (counter < 1):
            vote(voter, candidates[0])
            counter += 1
        else:
            vote(voter, candidates[1])
            counter += 1
    print('Votes have been cast!')
    # end_the election / display results

    # Delay's the main function so that end_election() is not executed before the end of the election.
    time.sleep(100)
    end_election()