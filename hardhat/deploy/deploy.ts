import { DeployFunction } from 'hardhat-deploy/types'

import { deploy } from '../utils/deploy-helpers'
import { BigNumberish, BigNumber as BN } from 'ethers'
import { HardhatRuntimeEnvironment } from 'hardhat/types'
import { getTokens, getNetworkName} from '../config'

const deployOptions: DeployFunction = async (hre) => {
  const { getNamedSigner, run, network, log } = hre
  const deployer = await getNamedSigner('deployer')

  const tokens = getTokens(network)

  // Make sure contracts are compiled
  await run('compile')

  log('')
  log('********** Deploying **********', { indent: 1 })
  log('')


  const wethDeploy = await deploy({
    contract: 'dBank',
    args: ['0x734F763eEF50CB868F4371395Fe4eBc9B6b13543'],
    skipIfAlreadyDeployed: false,
    hre,
})

//   const wethDeploy = await deploy({
//     contract: 'Token',
//     args:[],
//     skipIfAlreadyDeployed: false,
//     hre,
//   })
}

deployOptions.tags = []
deployOptions.dependencies = []

export default deployOptions
