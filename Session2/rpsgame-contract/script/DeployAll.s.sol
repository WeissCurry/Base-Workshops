// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";

// 1. Impor semua contract yang akan di-deploy
import {BasedToken} from "../src/Soal1.sol";     
import {BasedCertificate} from "../src/Soal2.sol"; 
import {BasedBadge} from "../src/Soal3.sol";     

contract DeployAll is Script {
    function run() external {
        // Ambil private key dari file .env Anda
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Mulai siarkan transaksi ke blockchain
        vm.startBroadcast(deployerPrivateKey);
        console.log("Memulai proses deployment...");

        // Deploy Contract #1: Soal1 (BasedToken)
        uint256 initialSupply = 1_000_000 ether;
        console.log("Deploying BasedToken with initial supply of:", initialSupply / 1e18);
        BasedToken basedToken = new BasedToken(initialSupply);
        console.log("Soal1 (BasedToken) deployed to:", address(basedToken));

        // Deploy Contract #2: Soal2 (BasedCertificate)
        console.log("Deploying BasedCertificate...");
        BasedCertificate basedCertificate = new BasedCertificate();
        console.log("Soal2 (BasedCertificate) deployed to:", address(basedCertificate));

        // Deploy Contract #3: Soal3 (BasedBadge)
        console.log("Deploying BasedBadge...");
        BasedBadge basedBadge = new BasedBadge();
        console.log("Soal3 (BasedBadge) deployed to:", address(basedBadge));

        // Hentikan siaran transaksi
        vm.stopBroadcast();

        console.log("Semua contract berhasil di-deploy!");
    }
}
