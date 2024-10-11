// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import {Test} from "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/FundMe.sol";
import {DepolyFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe public fundMe;
    address USER = makeAddr("user");

    function setUp() public {
        // 部署合约
        DepolyFundMe deployFundMe = new DepolyFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinUSDisOne() public view {
        assertEq(fundMe.minimumUSD(), 1e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testSepoliaVersionIsFour() public view {
        assertEq(fundMe.getVersion(), 4);
    }

    // function testFailFundWithoutEnoughETH() public {
    //     vm.expectRevert(InsufficientFunds.selector); // hey, the next line should revert!
    //     fundMe.fund(); // send 0 value
    // }

    function testFundUpdatesFundedDataStructure() public {
        vm.deal(USER, 1000 ether);
        vm.prank(USER); // The next TX will be sent by USER
        fundMe.fund{value: 10e18}();
        uint256 amountFunded = fundMe.addressToAmountFunded(USER);
        assertEq(amountFunded, 10e18);
    }

    function testOnlyOwnerCanWithdraw() public {
        vm.deal(USER, 1000 ether);
        vm.prank(USER);
        fundMe.fund{value: 10e18}();
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }
}
