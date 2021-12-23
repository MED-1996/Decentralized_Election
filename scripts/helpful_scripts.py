from brownie import config, network, accounts

FORKED_LOCAL_ENVIRONMENTS = ["mainnet-fork", "mainnet-fork-dev"]
LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["development", "ganache-local"]

def get_account(_account):
    if _account == 0:
        return accounts.add(config["wallets"]["key0"])
    elif _account == 1:
        return accounts.add(config["wallets"]["key1"])
    elif _account == 2:
        return accounts.add(config["wallets"]["key2"])
    elif _account == 3:
        return accounts.add(config["wallets"]["key3"])
    elif _account == 4:
        return accounts.add(config["wallets"]["key4"])
    elif _account == 5:
        return accounts.add(config["wallets"]["key5"])
    else:
        pass