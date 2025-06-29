# NixOS and Flakes Book

## Getting Started

### Advantages and Disadvantages

#### Advantages
* Declarative Configuration, OS as code
    - NixOS uses a declarative configuration to manage entire system.
    - Can be managed directly by Git
    - System restore to any historical state.
    - Nix flakes enhance reproducibility by utilizing a version lock file, recording source addresses, hash values, and other info for all dependencies.    
* Highly Convenient System Customization
    - Various components of system can be altered or replaced with just a few config changes.
    - Modifications are safe, allowing easy switching between desktop environments, for example.
* Rollback Capability
    - Possible to roll back to any previous state of system.
* No dependency conflict issues
    - Every software package has unique hash, incorporated into installation path.
    - This allows multiple versions of software easily.
* Active Community
    - Large official package repo
    - Many published configs

#### Disadvantages

* High learning curve
    - Need to learn a lot about Nix's entire design to avoid pitfalls.
    - For example, blindly using `nix-env -i` as opposed to more robust and appropriate methods.
* Disorganized Docs
    - Nix flakes remain an experimental feature.
    - Limited documentation focused on that, in other areas.
* Increased Disk Space Usage
    - Ensuring roll back ability requires Nix to retain all historical environments by default, increasing disk usage.
* Obscure Error Messages
    - Due to complexity, error messages are quite poor.
* More Complex Underlying Implementation
    - The declarative abstraction of Nix introduces more complexity in the underlying code compared to traditional imperative approaches.
    - Increases implementation difficulty and makes it more challenging to make modifications at lower levels.

    

---
## NixOS With Flakes

### Get Started With NixOS

* Default configuration file for NixOS is located at `/etc/nixos/configuration.nix`.
    - Manually edit file to modify system state in reproducible manner.
    - Execute `sudo nixos-rebuild switch` which generates new system environment based on new config file.
* This approach is the classic method for configuring NixOS
    - Relies on data sources configured by `nix-channel`, but lacks version-locking mechanism.
    - Makes ensuring reproducibility of system challenging.
    - Better approach is to use Flakes
    
#### Configuring the System using `/etc/nixos/configuration.nix`

* `/etc/nixos/configuration.nix' is default, classic method of configuring NixOS.
    - Lacks advanced features of Flakes, but still widely used and provides flexibility.
* Example of Enabling SSH and add user:
```nix

{ config, pkgs, ...}:

{
    imports =
        [
            ./hardware-configuration.nix
        ];
    
    users.users.scott = 
    {
        isNormalUser = true;
        description = "User";
        extraGroups = [ "networkmanager" "wheel" ];
        openssh.authorizedKeys.keys = 
            [
                "public-key"
            ];
        packages = with pkgs; [
            firefox
        ];
    };
    
    # Enable OpenSSH daemon
    services.openssh = 
    {
        enable = true;
        settings = 
        {
            X11Forwarding = true;
            PermitRootLogin = "no"; # disable root login
            PasswordAuthentication = false; # disable password login
        };
        openFirewall = true;
    };
}
```

* Can add `--show-trace --print-build-logs --verbose` to `nixos-rebuild` command for detailed error messages.



---
### Introduction To Flakes

* Flakes is a (widely-used) experimental feature and major development for Nix.
* Policy for managing dependencies between Nix expressions -  improving reproducibility, composability, and usability in Nix ecosystem.
* Introduces `flake.nix` similar to `package.json` in Node, describing dependencies between Nix packages and how to build packages and projects.
* `flake.lock` akin to `package-lock.json` - locks versions of dependencies.
* Does not break original design, new files are just wrappers for other Nix configurations.

#### A Word of Caution About Flakes

* Many benefits to using Flakes, and lots of the NixOS community has embraced them. (More than half of the users).

> [!note] Flake is still an experimental feature
> * Issues might persist
> * Possibility of introducing breaking changes

* Recommended to use Flakes, but might run into problems.

#### The New CLI and the Classic CLI

* 2020 - Nix introduced two experimental features, `nix-command` and `flakes`.
	- New command-line interface
	- Standardized Nix package structure definition (Flakes feature)
	- `flake.lock` - version locking
- Experimental as of February, 1 2024 but have gained widespread adoption within community.
- Replace old commands with new commands (`nix-command` and `flakes`), except `nix-collect-garbage` as there is no alternative to command.

1. `nix-channel`: `nix-channel` is used to manage versions of inputs like nixpkgs through stable and unstable channels. Traditionally provides `<nixpkg>` in Nix language.
	1. In Flakes, this functionality is replaced by the Flake Registry (`nix registry`) which provides "some unspecified global version of nixpkjgs" for interactive CLI usage. Using a `flake.nix`, input versions are managed in the flake itself.
	2. Flakes use the `inputs` section in `flake.nix` to manage version of nixpkgs and other inputs in each Flake instead of global state.
2. `nix-env`: `nix-env` is the core CLI tool for classic Nix, which manages software packages in user environment.
	1. Installs packages added by `nix-channel`. Packages installed this way are not automatically recorded in Nix's declarative configuration and independent of its control. This makes it challenging to reproduce on other machines. Upgrading with `nix-env` is slow and may produce unexpected results.
	2. Corresponding command in new CLI is `nix profile`, but might not be recommended for beginners.

> [!warn] Not recommended to use `nix-env`
 
 3. `nix-shell`: `nix-shell` creates temporary shell environments, useful for devel and testing.
	 1. New CLI: Divided into three sub-commands: `nix develop`, `nix shell`, and `nix run`.
4. `nix-build` : `nix-build` builds Nix packages and places result in `/nix/store`, but does not record them in Nix's declarative configuration.
	1. New CLI: Replaced by `nix build`
5. `nix-collect-garbage`: Garbage collection command used to clean unused Store objects in `/nix/store`.

---

---
### NixOS With Flakes Enabled

* Flakes offers better reproducibility compared to default config method.

#### Enable Flakes Support For NixOS

* As mentioned, Flakes is still experimental and thus is not enabled by default.
* Manually modify `/etc/nixos/configuration.nix` to enable Flakes feature
```nix
{ config, pkgs, ... }:

{
	imports = [
		./hardware-configuration.nix
	];

	# .....
# Enable Flakes feature and new nix CLI tool
nix.settings.experimental-features = [ "nix-command" "flakes" ];
environment.systemPackages = with pkgs; [
		# Flakes clones dependencies through git command, so git
		# must be installed first.
		git
		vim
		wget
	]
	# Set default editor
	environment.variables.EDITOR = "vim";

	# ....
}
```

#### Switching System Configuration to `flake.nix`

* After enabling Flakes, `sudo nixos-rebuild switch` command will prioritize the `/etc/nixos/flake.nix` file, and if not found, use `/etc/nixos/configuration.nix`.
* `nix flake show templates`
* `nix flake init -t templates#[template-name]`
* Currently flake would include these files:
	* `/etc/nixos/flake.nix` - Entry point for Flake, recognized and deployed when `sudo nixos-rebuild switch` is executed.
	* `/etc/nixos/flake.lock` - Automatically generated version lock file
	* `/etc/nixos/configuration.nix` - Previous configuration file, imported as a module in `flake.nix`. Currently, all system configurations are in this file.
	* `/etc/nixos/hardware-configuration/nix` - This is the system hardware configuration file, generated by NixOS, describing system hardware.


---
### NixOS's `flake.nix` Explained

#### 1. Flake Inputs

* `inputs` attribute: Attribute set that defines all the depencies of this flake.
* Depencies will be passed as arguments to `outputs` function after fetched.

```nix

{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
	};

	outputs = { self, nixpkgs, ...}@inputs: {
		# ...
	};
}
```

* The dependencies in `inputs` has many types and definitions. 
	* Can be another flake
	* Regular Git Repository
	* Local Path
* After defined in `inputs`, you can use it in the parameters of the subsequent `outputs` function.

#### 2. Flake Outputs

* `outputs`: Function that takes dependencies from `inputs` as its parameters, and its return value is an attribute set which represents the build results of the flake.

```nix

{
	description = "Simple NixOS flake";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
	};

	outputs = { self, nixpkgs, ...}@inputs: {
		nixosConfigurations.my-nixos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./configuration.nix
			];
		};
	};
}
```

* Flakes can have various purposes and thus different types of outputs.
* `nixosConfigurations`: Configure NixOS Syhstems
* Running `sudo nixos-rebuild switch`, looks for  `nixosConfigurations.my-nixos` attribute (`my-nixos` is hostname of current system) in the attribute set returned by the `outputs` function of `/etc/nixos/flake.nix`. The resulting definition is used to configure the NixOS system.
* Customize location of the flake nad the name of the NixOS configuration instead of defaults:
	* `sudo nixos-rebuild switch --flake /path/to/your/flake#host-name`
* Reference remote Github Repo for flake source:
	* `sudo nixos-rebuild switch --flake github:owner/repo#your-hostname`

#### 3. The Special Parameter `self` of the `outputs` function

* `self` is special parameter in `outputs` function

> ![note] `self`
> The special input named `self` refers to the outputs and source tree of this flake.

* `self` is the return value of the current flake's `outputs` function and also the path to the current flake's source folder.

#### 4. Simple Introduction to `nixpkgs.lib.nixosSystem` Function

* Flake can depend on other Flakes to utilize the feature they provide.
* Default, flake searches for a `flake.nix` file in the root directory of each of its dependencies (i.e., items in `inputs`) and **lazily** evaluates their `outputs` functions.
	* Passes the attribute set returned as arguments to its own `outputs` function, allowing use of features of other flakes.
* Evaluation of the `outputs` function for each dependency is lazy, meaning the flake's `outputs` function is only evaluated when actually used.


---
### The combination ability of Flakes and Nixpkgs module system

#### Nixpkgs Module Structure Explained

> [!question] Question
> Why does `/etc/nixos/configuraiton.nix` config file adhere to the Nixpkgs Module definition but can be referenced directly within the `flake.nix`

* All implementation code of NixOS is stored in Nixpkgs/nixos directory, and most is written in the Nix language.
* Writing and maintaining such a large amount of Nix requires a modular system for NIx code.
* Modular system for NIx is also implemented within Nixpkgs repo and primarily used for modularizing NixOS system configs.
* As NixOS is built on modular system, natural its config files (even `/etc/nixos/configuration.nix`) are Nixpkgs modules.

##### Simplified Structure of a Nixpkgs Module:

```nix

{lib, config, options, pkgs, ...}:
{
	# Importing Other Modules
	imports = [
		# ...
		./module.nix
	];

	for.bar.enable = true;
	# Other option declarations
	# ...
}
```

* Definition is actually a Nix function, and has **five automatically generated, automatically injected, and declaration-free parameters**:
	* `lib`: Built-in function library included with nixpkgs, offering many practical functions for operating Nix expressions.
	* `config`: A set of all options' values in the current environment, which will be used extensively in subsequent section on module system.
	* `options`: A set of all options defined in all Modules in current env.
	* `pkgs`: A collection containing all nixpkgs packages, along with several related utility functions
	* modulesPath: A parameter available only in NixOS, which is a path pointing to nixpkgs/nixos/modules
		* Typically used to import additional NixOS modules; found in most NixOS auto-generated `hardware-configuration.nix` files.
#### Passing Non-Default Parameters to Submodules

* To pass other non-default parameters to submodules, will need to use some special methods to manually specify these non-default parameters.
* Nixpkgs module system provides two ways to pass non-default parameters:
	* `specialArgs`: Parameter of the `nixpkgs.lib.nixosSystem` function
	* `_module.args` option in any module to pass parameters.
* `specialArgs`: 
	* [Module System - Nixpkgs](https://github.com/NixOS/nixpkgs/blob/nixos-25.05/doc/module-system/module-system.chapter.md)
	* [NixOS Manual](https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/doc/manual/development/option-types.section.md?plain=1#L237-L244)
* `_module.args`:
	* NixOS Manual: [Appendix A. Configuration Options](https://nixos.org/manual/nixos/stable/options#opt-_module.args)
	* [Source Code](https://github.com/NixOS/nixpkgs/blob/nixos-25.05/lib/modules.nix#L122-L184)
* Both require an attribute set as their value, and serve the same purpose - to pass all parameters in the attribute set to all submodules.
* Difference:
	* `_module.args` option can be used in any module to pass parameters to each other, thus more flexible than `specialArgs` which can only be used in `nixpkgs.lib.nixosSystem` function.
	* `_module.args` is declared within a module, so must be evaluated after all modules have been evaluated before it can be used. 
		* **Means if you use the parameters passed through `_module.args` in `imports = [ ... ];` it will result in an `infinite-recursion` error.** In this instance, use `specialArgs` instead.
* `specialArgs` might be more straightforward and easier to use.

> [!note] `specialArgs`

```nix
{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkjgs/nixos-25.05";
		another-input.url = "github:username/repo-name/branch-name";
	};

	outputs = inputs@{self, nixpkjgs, another-input, ...}: {
		nixosConfiguraitons.my-nixos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";

			# Set all inputs parameters as special arguments for all submodule
			# so you can directly use all depencies in inputs in submodules
			specialArgs = { inherit inputs; }
			modules = [
				./configuration.nix
			];
		};
	};
}
```

> [!note] `_module.args`

```nix
{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkjgs/nixos-25.05";
		another-input.url = "github:username/repo-name/branch-name";
	};

	outputs = inputs@{self, nixpkjgs, another-input, ...}: {
		nixosConfigurations.my-nixos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./configuration.nix
				{
					# Set all inputs params as special args for all submodules
					# so you can directly use all dependencies in inputs in
					# submodules.
					_module.args = { inherit inputs; };_
				}
			];
		};
	};
}
```

#### Installing System Software from other Flake Sources

* Already seen how to install packages from official nixpkgs repo using `environment.systemPackages`. 
* These packages come from the official nixpkgs repo.
* Installing software packages from other flake sources is more flexible than installing directly from nixpkgs.
	* Main use case is to install the latest version of a software that is not yet added or updated in Nixpkgs.
* Helix editor as an example - compiling and installing the master branch of Helix directly

1. First, add the helix input data source to `flake.nix`:

```nix
{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

		# Helix Editor - master branch
		helix.url = "github:helix-editor/helix/master";
	};

	outputs = inputs@{self, nixpkgs, ...}: {
		nixosConfigurations.my-nixos = nixpkgs.lib.nixosSystem {
			system = "x86-64-linux";
			specialArgs = { inherit inputs; };
			modules = [
				./configuration.nix
			]
		}
	}
}
```

2. Next, reference this flake input data source in `configuration.nix`:

```nix
{ config, pkgs, inputs, ...}:
{
	# ...

	environment.systemPackages = with pkgs; [
		git
		vim
		wget
		# Here, helix package is installed from the helix data source
		inputs.helix.packages."${pkgs.system}".helix
	];
	
	# ...
}
```

* Just try out latest version of Helix and decide whether to install on system later, you can use: `nix run github:helix-editor/helix/master`

