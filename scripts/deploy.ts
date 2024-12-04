import { ethers } from "hardhat";

async function main() {
  // Deploying contracts
  const EvaToken = await ethers.getContractFactory("EvaToken");

  const evaToken = await EvaToken.deploy();

  await evaToken.waitForDeployment();

  console.log(
    `EvaToken deployed at  ${evaToken.target}`
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
