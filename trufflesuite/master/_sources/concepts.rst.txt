Concepts
========

.. include:: _include.rst

This section serves to describe the relationships between the various
components in an |Artifact|.

Directory Structure
-------------------

In addition to the existing |ContractsDirectory|, this document
proposes the addition of a new |NetworkDirectories|, containing |Artifact|
files for that network.

.. uml::

   !include uml/macros.iuml

   directory(Project) {
    + resolve(name : String) : Artifact
    + resolve(name : String, network : String) : Artifact
   }


   directory(Network) {
    + name : String
   }

   file(Artifact) {
    + JSON
   }

   abstract class Contract {
    + name : String
    + snapshots : Snapshots
    + links : Map<String => LinkValue>
    + abi()
   }


   Project *-- "n" Artifact : build/contracts/
   Project *-right- "n" Network : build/networks/
   Network *-- "n" Artifact

   Artifact *-down- "1" Contract


Artifact Components
-------------------


.. uml::

   !include uml/macros.iuml

   collection(Snapshots) {
    + snapshots : Map<String => Snapshot>
    + currentId : String
    + getById(id : String) : Snapshot
    + getByBytecode(bytecode : String) : Snapshot
   }

   object(Source) {
    + sourcePath : String
    + source : String
    + ast : AST
   }

   abstract class Contract {
    + name : String
    + snapshots : Snapshots
    + links : Map<String => LinkValue>
    + abi()
   }

   class "Contract Instance" as Instance {
    + address
    + transactionHash
    + constructorArgs
    __
    + methods() : MethodsInterface
    + events() : EventsInterface
    + sendTransaction() : TransactionInterface
    + send()
    ..
    + type() : Type
   }

   class "Contract Type" as Type {
    __
    + link(name : String, value : String)
    ..
    + new() : Promise<Instance>
    + at(address : String) : Instance
   }

   object(Snapshot) {
    + {field} id
    + abi : ABI
    + callBytecode : Bytecode
    + createBytecode : Bytecode
    + compiler : Compiler
    + sources : Array<Source>
   }

   object(Compiler) {
    + name : String
    + version : String
    + settings : Object
   }

   object(Bytecode) {
    + unlinkedBinary : String
    + sourceMap : SourceMap
    + linkReferences : Map<String => LinkReference>
   }

   object(SourceMap) {
    + sourceMap : String
   }

   object(LinkReference) {
    + name : String
    + offsets : Array<Integer>
    + length : Integer
   }

   object(LinkValue) {
    + value : String
   }

   object(AST) {
    + root : ASTNode
   }

   Instance ..|> Contract
   Type ..|> Contract

   Contract *-down- "1" Snapshots
   Contract *-right- "n" LinkValue : maps by name


   Snapshots o-- "1" Snapshot : current
   Snapshots *-down- "n" Snapshot : all


   Snapshot *-right- "2" Bytecode
   Snapshot *-- "1" Compiler
   Snapshot *-left- "n" Source

   Source *-- "1" AST

   Bytecode *-- "1" SourceMap
   Bytecode *-up- "n" LinkReference : missing by name


   LinkValue ..> LinkReference : <<resolves>>
