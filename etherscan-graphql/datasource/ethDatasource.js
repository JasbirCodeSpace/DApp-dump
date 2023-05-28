const { RESTDataSource } = require("apollo-datasource-rest");

const eth_address = "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045";

class EtherDataSource extends RESTDataSource {
  constructor() {
    super();
    this.baseURL = "https://api.etherscan.io/api";
  }

  async etherBalanceByAddress() {
    const response = await this.get("", {
      module: "account",
      action: "balance",
      address: eth_address,
      tag: "latest",
      apiKey: process.env.ETHERSCAN_API,
    });

    return {
      status: response.status,
      result: response.result,
    };
  }

  async totalSupplyOfEther() {
    const response = await this.get("", {
      module: "stats",
      action: "ethsupply",
      apiKey: process.env.ETHERSCAN_API,
    });

    return {
      status: response.status,
      message: response.message,
      result: response.result,
    };
  }
}

module.exports = EtherDataSource;
