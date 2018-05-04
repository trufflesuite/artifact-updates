Use Cases
=========

.. include:: _include.rst

Compilation
-----------

At the core of smart contract development and deployment is the compilation
of high-level languages to the underlying EVM |Bytecode|.

Smart contract developers frequently compile/recompile |Sources| many times
throughout the entire lifecycle of development.


.. uml::

  left to right direction

  :Smart Contract Developer: as :Developer:

  rectangle Compilation {
    (Compile single source file) as (Compile)
    (Compile primary and related source files as a contract type) as (CompileMultiple)
  }

  Developer -- Compile
  Developer -- CompileMultiple


Compile a single source file as a contract type
```````````````````````````````````````````````

Resulting in a single |ContractType| with no |ContractInstances|.

Compile primary and related source files as a contract type
```````````````````````````````````````````````````````````

Primary source file and recursively all imports. Primary source declares
|ContractType|.


Reading contract metadata
-------------------------

Developers, auditors, business stakeholders, et al., all often need to access
metadata information about both |ContractTypes| and |ContractInstances|.

For example, stakeholders often need to view the JSON ABI, auditors need source
and compiler information, developers need to maintain records of source file
relations and deployment statuses, etc.

Beyond direct access of contract metadata, many other use cases rely on this
metadata heavily.

Metadata should be accessible both for current versions and for all historical
versions that may be in use.


.. uml::

  scale 0.60
  left to right direction

  :Smart Contract Developer: as :SmartContractDev:

  rectangle Metadata {
    (Read contract instance info) as (ReadContractInstance)
    (Read contract type info) as (ReadContractType)
    (Read historical contract instance type info) as (ReadHistoricalInstanceType)

    (Read instance) as (ReadInstanceData)
    (Read type) as (ReadTypeData)

    ReadInstanceData <|.up. ReadContractInstance
    ReadTypeData <|.up.. ReadContractType
    ReadTypeData <|.up.. ReadHistoricalInstanceType

    ' both
    (Read name) as (ReadName)
    (Read ABI) as (ReadABI)
    (Read bytecodes) as (ReadBytecodes)
    (Read source mappings) as (ReadSourceMaps)
    (Read link values) as (ReadLinkVals)
    (Read sources) as (ReadSources)
    (Read ASTs) as (ReadASTs)

    ' instance
    (Read link references) as (ReadLinkRefs)
    (Read address) as (ReadAddress)

    ReadTypeData --> ReadName
    ReadTypeData --> ReadABI
    ReadTypeData --> ReadBytecodes
    ReadTypeData --> ReadSourceMaps
    ReadTypeData --> ReadLinkRefs
    ReadTypeData --> ReadSources
    ReadTypeData --> ReadASTs

    ReadInstanceData --> ReadTypeData
    ReadInstanceData --> ReadLinkVals
    ReadInstanceData --> ReadAddress
  }

  SmartContractDev -- ReadContractInstance
  SmartContractDev -- ReadContractType
  SmartContractDev -- ReadHistoricalInstanceType


Read contract instance information
``````````````````````````````````

From saved data about a particular instance on a particular network.

Read contract type info
```````````````````````

From saved data about a particular type known, deployed or not.

Read contract instance historical type info
````````````````````````````````````````````

For a particular instance, read the type as known at deploy time.

Listing known contracts
-----------------------

Developers must be able to view all known |ContractInstances| on a given
network, or a list of networks with known instances of a given |ContractType|.


.. uml::

  left to right direction
  :Smart Contract Developer: as :Developer:

  rectangle Listing {
    (List all instances for a given network) as (ListNetwork)
    (List all networks for a given type) as (ListType)
    (List equivalent instances across networks) as (ListInstance)

    ListInstance .|> ListType
  }

  Developer -- ListNetwork
  Developer -- ListType
  Developer -- ListInstance

List all instances for a given network
``````````````````````````````````````

For a full view of the system in its current state of deployment/operation.

List all networks for a given type
``````````````````````````````````

To identify differences in versions, e.g., or to ensure front-end support
for multiple networks.

List equivalent instances across networks
`````````````````````````````````````````

An extenstion of listing networks for a given |ContractType|.

In the case of applications that maintain multiple |ContractInstances| for a
single type, perhaps with named roles, tooling should support the ability
to list all equivalent instances to a given role.


Interacting with deployed instances
-----------------------------------

Besides metadata information, users must be able to retrieve runtime state
information about |ContractInstances| and to be able to write to those
instances over the network.


.. uml::

  left to right direction

  :User: as :User:

  rectangle Metadata << external >> {
    (Read ABI) as (ReadABI)
    (Read instance) as (ReadInstance)
    (ReadInstance) -> ReadABI
  }

  rectangle Interaction {
    (Call read-only method) as (Call)
    (Invoke method via a transaction) as (SendTransaction)
    (Send ETH to a contract instance) as (Send)

    Call --> ReadInstance
    SendTransaction --> ReadInstance
  }

  User -- Call
  User -- SendTransaction
  User -- Send

Call read-only method
`````````````````````

In order to view the state of a contract instance at a particular time.

For accessing state variables as well as computed information exposed by the
contract's |ABI|.

Invoke method via a transaction
```````````````````````````````

Following the contract's |ABI|, users must be able to execute the allowable
"write" operations for a contract instance.


Send ETH to a contract instance
```````````````````````````````

Many smart contracts expose methods for receiving payment in the form or ether
or other tokens.

Developers must be able to test the receipt of ether; business stakeholders may
have to provide initial funds, for applications that require it.


Saving externally-deployed instances
------------------------------------

Since a smart contract blockchain network is effectively a distributed global
database, developers may write their applications for the express or implicit
purpose of accessing other contract instances on that network.

Developers should be able to leverage tooling to interface with these external
contracts, either common, public libraries, or contract instances for other
applications. Tooling should integrate well with code written outside a given
project.

Additionally, some applications may not use tooling's built-in deployment
systems, and some |ContractInstances| may deploy others. Tooling should be
able to account for the record-keeping in such cases.

.. uml::

  left to right direction

  :Smart Contract Developer: as :SmartContractDev:

  rectangle saving {
    (Save contract instance) as (SaveInstance)
    (Save library instance) as (SaveLibrary)
    (Save interface instance) as (SaveInterface)
  }

  SmartContractDev -- SaveInstance
  SmartContractDev -- SaveLibrary
  SmartContractDev -- SaveInterface

Save contract instance
``````````````````````

Either deployed externally as part of another application on the network, or
as part of a factory contract internally.


Save library instance
`````````````````````

To avoid the extra gas expense of redeployment.


Save interface instance
```````````````````````

In cases where source is not known for an external contract, it may still
be required to keep a reference of that contract's interface (i.e. via
Solidity's ``interface`` mechanism).


Migrations
----------

During and after the process of creating smart contracts, smart contract
developers need to deploy |ContractTypes| on one or more |Networks|, creating
one or more |ContractInstances|.

In addition, smart contract developers must be able to track the states of
different networks separately. For instance, contract instances on different
networks can be of different versions of the same contract type. This
difference should be understood by the underlying tooling, and easy to
reason about for the user of the tool.

.. uml::

  scale 0.60
  left to right direction

  :Smart Contract Developer: as :Developer:

  rectangle Interacting << external >> {
    (Call read-only method) as (Call)
  }

  rectangle Migrations {
    (Run all migrations) as (RunMigrations)
    (Run specific migration) as (RunSpecific)

    RunMigrations --> RunSpecific

    (Run as historical) as (RunHistorical)
    RunHistorical .|> RunMigrations

    (Determine last completed migration) as (DetermineLastCompleted)

    DetermineLastCompleted -> Call : query Migrations instance

    RunMigrations --> DetermineLastCompleted

    (Link contract type to library) as (LinkType)
    (Link contract instance to library) as (LinkInstance)
    LinkInstance .left.|> LinkType

    RunSpecific --> LinkType

    (Deploy instance of a type) as (DeployInstance)
    (Deploy multiple instances) as (MultipleInstances)
    MultipleInstances .|> DeployInstance

    RunSpecific --> DeployInstance
  }

  Developer -- RunMigrations
  Developer -- RunSpecific
  Developer -- RunHistorical
  Developer -- DetermineLastCompleted


Determine last completed migration
``````````````````````````````````

On a particular network.

Run all migrations
``````````````````

On a particular network, resetting from the beginning and running in sequence.

Run specific migration
``````````````````````

Perform operations in a single migration.

Link contract type to library instance
``````````````````````````````````````

On a particular network, so that future deployments of that type are
pre-linked.

Link contract instance to library instance
``````````````````````````````````````````

On a particular network, to set specific link value for an instance.

Deploy instance of a type
`````````````````````````

On a particular network.

Deploy multiple instances
`````````````````````````

On a particular network, giving each instance a unique name.


Run with historical types
``````````````````````````

Specifying parent network, determine types for instances, and deploy
instances matching those types instead of current.




Testing
-------

Being able to validate that smart contracts behave as expected is of paramount
importance.

Development workflow best practices involve writing/running automated tests
early and often in the process. Developers should be able to test their
contracts locally before deployment, and once deployed, be able to test their
contract instances locally, matching expected behavior on the network itself.

.. uml::

  scale 0.80
  left to right direction

  :Smart Contract Developer: as :Developer:

  rectangle tests {
    (Run automated tests for contract type) as (TestType)
    (Run automated tests for contract instance) as (TestInstance)
    (Run automated tests for library type) as (TestLibrary)
    (Run automated tests for library instance) as (TestLibraryInstance)

    (Run test written in Solidity) as (RunSolidity)
    (Run test written in Javascript) as (RunJavascript)

    TestType ..|> RunSolidity
    TestType ..|> RunJavascript

    TestInstance ..|> RunSolidity
    TestInstance ..|> RunJavascript

    TestLibrary ..|> RunSolidity
    TestLibraryInstance ..|> RunSolidity
  }

  Developer -- TestType
  Developer -- TestInstance
  Developer -- TestLibrary
  Developer -- TestLibraryInstance


Run automated tests for contract type
`````````````````````````````````````

Run migrations to deploy fresh instances locally.

Run automated tests for contract instance
`````````````````````````````````````````

Contract instance may have a historical contract type (old source, etc.)

Run migrations assuming historical versions and deploy instances locally.

Run automated tests for library type
````````````````````````````````````

Run deploy new instance of library and run tests linked to it.

Run automated tests for library instance
````````````````````````````````````````

Library instance may represent a historical version of the library type.

Deploy instance of possibly-historical type and run tests linked to it.
