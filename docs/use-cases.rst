Use Cases
=========

Compilation
-----------

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

Resulting in a single contract type with no contract instances.

Compile primary and related source files as a contract type
```````````````````````````````````````````````````````````

Primary source file and recursively all imports. Primary source declares
contract type


Migrations
----------

.. uml::

  scale 0.65
  left to right direction

  :Smart Contract Developer: as :Developer:

  rectangle Migrations {
    (Run all migrations) as (RunMigrations)
    (Run specific migration) as (RunSpecific)

    RunMigrations --> RunSpecific

    (Run as historical) as (RunHistorical)
    RunHistorical .|> RunMigrations

    (Determine last completed migration) as (DetermineLastCompleted)

    RunMigrations -right-> DetermineLastCompleted

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


Interacting with externally-deployed contracts
----------------------------------------------

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

On a given network, with a given address, as a given contract type.


Save library instance
`````````````````````

On a given network, with a given address, as a given library type.

Save interface instance
```````````````````````

On a given network, with a given address, as a given interface type.


Reading contract information
----------------------------

.. uml::

  scale 0.60
  left to right direction

  :Smart Contract Developer: as :SmartContractDev:

  rectangle reading {
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

From saved data about a particular instance on a particular network

Read contract type info
```````````````````````

From saved data about a particular type known, deployed or not

Read contract instance historical type info
````````````````````````````````````````````

For a particular instance, read the type as known at deploy time.
