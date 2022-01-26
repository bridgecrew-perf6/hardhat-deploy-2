# 🎨 Solidity Template Monorepo

[![Netlify Status](https://api.netlify.com/api/v1/badges/0f749563-48cc-40bf-beda-52573fd31cef/deploy-status)](https://app.netlify.com/sites/nifty-options/deploys)


# Using hardhat (01/25/2022)

npm install
npx hardhat compile
npx hardhat deploy --rinkeby











# 🏄‍♂️ Quick Start (contracts)

Create the .env file in /packages/hardhat according to .env.template

```bash
yarn install
yarn contracts build
yarn contracts test mainnet
```


## How to Deploy

```
cd packages/hardhat

yarn deploy --network rinkeby

yarn etherscan-verify --network rinkeby --license MIT
```




🔏 Edit your smart contract `*.sol` in `packages/hardhat/contracts`

📝 Edit your frontend `App.jsx` in `packages/react-app/src`

💼 Edit your deployment scripts in `packages/hardhat/deploy`

📱 Open http://localhost:3000 to see the app
