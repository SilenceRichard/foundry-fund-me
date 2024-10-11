// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelpConfig} from "./HelpConfig.s.sol";

contract DepolyFundMe is Script {
    function run() external returns (FundMe) {
        // before startBroadcast, not a real "tx"
        HelpConfig helpConfig = new HelpConfig();
        address ethPriceFeed = helpConfig.activeNetWorkConfig();
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
