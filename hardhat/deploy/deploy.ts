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




const blockStaking = await deploy({
  contract: 'BlockStaking',
  skipIfAlreadyDeployed: false,
  hre,
})

const blockMint = await deploy({
  contract: 'BlockMint',
  args: [blockStaking.address],
  skipIfAlreadyDeployed: false,
  hre,
})

const sBlock = await deploy({
  contract: 'sBlock',
  // args: ['ipfs://QmcCsHvjMsCRRjG9YPLB1XepNoUVXoG5h3L93Yea8srd4w/'],
  skipIfAlreadyDeployed: false,
  hre,
})

}

deployOptions.tags = []
deployOptions.dependencies = []

export default deployOptions
