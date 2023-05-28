# GraphQL With Etherscan APIs Bounty

## Overview of Bounty
Based on the GraphQL with REST API module, you have learnt how to wrap multiple REST API endpoints into a single GraphQL API for more efficient querying. 

In this bounty, you will be working with Etherscan APIs and are tasked to wrap multiple Etherscan API endpoints under a single GraphQL API. The Etherscan APIs are as follows:

- Get Ether Balance for a Single Address (https://docs.etherscan.io/api-endpoints/accounts#get-ether-balance-for-a-single-address)
- Get Total Supply of Ether (https://docs.etherscan.io/api-endpoints/stats-1#get-total-supply-of-ether) 

## Getting Started
1. Sign up for a new Etherscan account to generate your API key if you do not have one. 
2. Proceed to clone the git repository 
3. Create a new .env file and create a `ETHERSCAN_API` key variable to insert your Etherscan API key value
4. Run the `$npm install` command to install the necessary dependencies
5. Make the code changes to `schema.graphql` and `ethDatasource.js`
6. Run the `$node index.js` command to initialise the GraphQL server and run your queries


