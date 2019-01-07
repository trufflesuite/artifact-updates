Data Model
==========

.. include:: _include.rst

This section serves to describe the relationships between the various
components in an |Artifact|.


.. uml::

   !include uml/macros.iuml

   object(ContractInstance) {
    + address : Address
    + network : Network
    + transactionHash : TransactionHash
    + constructorArgs : Array<Value>
    + contractType : ContractType
    + callBytecode : Bytecode
    + linkValues : Set<LinkValue>
   }

   object(ContractType) {
    + name : String
    + abi : ABI
    + compilation : Compilation
    + createBytecode : Bytecode
   }

   collection(ContractTypes) {
    + contractTypes : Set<ContractType>
   }

   object(Source) {
    + sourcePath : String
    + source : String
    + ast : AST
   }

   collection(Sources) {
    + sources : Map<FileIndex => Source>
   }

   object(Network) {
    + name : String
    + networkId : NetworkID
   }

   object(Compilation) {
    + compiler : Compiler
    + sources : Sources
    + contractTypes: ContractTypes
   }

   object(Compiler) {
    + name : String
    + version : String
    + settings : Object
   }

   object(Bytecode) {
    + unlinkedBinary : String
    + sourceMap : SourceMap
    + linkReferences : Set<LinkReference>
   }

   object(SourceMap) {
    + sourceMap : Map<ByteOffset => SourceRange>
    + sources: Sources
   }

   object(SourceRange) {
    + source : Source
    + start : ByteOffset
    + length : Length
    + meta : Object
   }

   object(LinkValue) {
    + linkReference : LinkReference
    + value : Bytes
   }

   object(LinkReference) {
    + offsets : Array<ByteOffset>
    + length : Integer
   }

   Network "1" o-- "n" ContractInstance

   ContractInstance o-- "1" ContractType
   ContractInstance *-- "1" Bytecode
   ContractInstance *-- "n" LinkValue

   ContractType "n" --o "1" ContractTypes
   ContractType *-- "1" Bytecode


   ContractTypes "n" --* Compilation

   Compilation *-down- "1" Compiler
   Compilation *-right- "1" Sources

   Sources *-- "n" Source

   Bytecode *-- "1" SourceMap

   SourceMap o-left- "1" Sources
   SourceMap *-- "n" SourceRange
   SourceRange o-left- "1" Source

   LinkReference "n" --* Bytecode

   LinkValue ..> "1" LinkReference

