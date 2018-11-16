pragma solidity ^0.4.24;

import "truffle/Assert.sol";

import "../contracts/Election.sol";

import "./ThrowProxy.sol";

contract TestElection {

  Election instance = new Election("My Election");

  function testElectionNameisSet() public {
  string memory name = instance.name();
  Assert.notEqual(name, "", "election name should be set in constructor");
  }

  function testCandidateCountisZero() public {
  uint candidateCount = instance.getNumCandidate();
  Assert.equal(candidateCount, 0, "election should not have any candidates");
  }

  function testOwnerCanAddCandidates() public {
  instance.addCandidate("Jon Snow");
  uint candidateCount = instance.getNumCandidate();

  Assert.equal(candidateCount, 1, "owner can add candidates");
  }

  function testNonOwnerCannotAddCandidates() public {
  ThrowProxy proxy = new ThrowProxy(address(instance));
  Election(address(proxy)).addCandidate("Jon Snow");

  bool result = proxy.execute();

  Assert.isFalse(result, "non-owner cannot add candidates");
  }


}
