// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "../core/ModuleManager.sol";
import "../core/Fallback.sol";
import "../core/HookManager.sol";

import "../interfaces/IModule.sol";

struct BootstrapConfig {
    IModule module;
    bytes data;
}

contract MSABootstrap is ModuleManager, Fallback, HookManager {
    function initMSA(
        BootstrapConfig[] calldata _validators,
        BootstrapConfig[] calldata _executors,
        BootstrapConfig calldata _hook,
        BootstrapConfig calldata _fallback
    )
        external
    {
        _initModuleManager();

        // init validators
        for (uint256 i; i < _validators.length; i++) {
            _enableValidator(address(_validators[i].module), _validators[i].data);
        }

        // init executors
        for (uint256 i; i < _executors.length; i++) {
            _enableExecutor(address(_executors[i].module), _executors[i].data);
        }

        // init hook
        if (address(_hook.module) != address(0)) {
            _enableHook(address(_hook.module), _hook.data);
        }

        // init fallback
        if (address(_fallback.module) != address(0)) {
            _setFallback(address(_fallback.module));
        }
    }

    function _getInitMSACalldata(
        BootstrapConfig[] calldata _validators,
        BootstrapConfig[] calldata _executors,
        BootstrapConfig calldata _hook,
        BootstrapConfig calldata _fallback
    )
        external
        view
        returns (bytes memory init)
    {
        init = abi.encodeCall(this.initMSA, (_validators, _executors, _hook, _fallback));
    }
}