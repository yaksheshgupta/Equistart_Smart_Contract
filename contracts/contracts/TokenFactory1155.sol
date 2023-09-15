// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
import "./ERC1155Token.sol";

contract TokenFactory {
    event New1155Created(
        uint256 id,
        uint256[] tokenId,
        string[] tokenName,
        uint256[] tokenAmount,
        bytes[] tokenData
    );

    uint numOfProjects;

    struct projectMeta {
        uint256 id;
        string projectName;
        // string symbol;
        uint256[] tokenId;
        string[] tokenName;
        uint256[] initialSupply;
        address tokenBeneficiary;
        address contractAddress;
    }

    // projectMeta[] public deployedProjects;
    mapping(uint => projectMeta) private deployedProjects;

    function createProject(
        uint256[] memory _id,
        string memory projectName,
        string[] memory _name,
        // string memory symbol,
        uint256[] memory _amount,
        bytes[] memory _data,
        address beneficiary
    ) public {
        uint projectId = numOfProjects++;
        projectMeta storage project = deployedProjects[projectId];
        project.id = projectId;
        project.projectName = projectName;
        // project.symbol = symbol;
        project.initialSupply = _amount;
        project.tokenBeneficiary = beneficiary;
        project.contractAddress = address(
            new ERC1155_Equistart_V1(_id, _name, _amount, _data)
        );
        emit New1155Created(projectId,_id, _name, _amount,_data);
        // deployedProjects.push(newProject);
    }

    function getAllDeployedProjects()
        public
        view
        returns (projectMeta[] memory props)
    {
        // return deployedProjects;
        props = new projectMeta[](numOfProjects);

        for (uint256 index = 0; index < numOfProjects; index++) {
            props[index] = deployedProjects[index];
        }
    }

    function getProjectById(
        uint256 projectId
    ) public view returns (projectMeta memory) {
        return deployedProjects[projectId];
    }
}
