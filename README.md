# Decentralized Election :bust_in_silhouette:

An ethereum smart contract that allows the deployer to setup an election on the ethereum blockchain. When deploying, the deployer must provide:

* Array of ethereum voter addresses.
* Array of ethereum candidate addresses.
* An election controller ethereum address (responsible for displaying the results of the election).
* How long they'd like the election to last for.

The goal of a decentralized election is to eliminate election fraud.

# What I Learned :notebook:

* Fundamentals of Solidity.
* Fundamentals of Brownie.
* How to interact with the ethereum blockchain.
* How to stage and commit changes from a local repository to a github repository.
* Difficulties in making a decentralized election.

# Image :framed_picture:

![Picture](https://github.com/MED-1996/Decentralized_Election/blob/main/Election_Voting_Results.png)

# How to Use

* Download this repository & have the brownie framework installed on your computer.
* Add a .env file that contains the private keys of 3-6 address. (These keys represent the voters addresses/keys)
* Open your computers terminal and "cd" to the repository folder.
* Enter the following command into your terminal:...

Run Command:

	brownie run scripts/deploy_election.py --network rinkeby