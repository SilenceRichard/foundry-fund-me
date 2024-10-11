// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import {Test} from "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/FundMe.sol";
import {DepolyFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe public fundMe;
    address USER = makeAddr("user");
    uint256 public constant SEND_VALUE = 10e18;

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
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.addressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    modifier funded() {
        vm.deal(USER, 1000 ether);
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithDrawWithASingleFunder() public funded {
        // Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        // Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingFundMeBalance + startingOwnerBalance,
            endingOwnerBalance
        );
    }

    function testWithdrawFromMultipleFunders() public funded {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startFunderIndex = 2;
        for (uint160 i = startFunderIndex; i < numberOfFunders; i++) {
            // vm.prank new address
            // vm.deal new address
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();
        // Assert
        assert(address(fundMe).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance ==
                fundMe.getOwner().balance
        );
    }
}
