Overview
========

Background
----------

Currently, Truffle artifacts are stored as JSON files in a project's
``build/contracts/`` directory.

Artifact files currently follow a formally-specified JSON-Schema [#jsonschema]_,
available in the `trufflesuite/truffle-contract-schema <https://github.com/trufflesuite/truffle-contract-schema>`_
repository. This schema's latest version is v2.0.0.


Purpose of this Document
------------------------

This document serves to aid in discussion around improvement to Truffle's
artifacts format, to facilitate additional use cases by users and tools.

The goal of this effort is to guide direction for *truffle-contract-schema*
towards its next major release, v3.0.0.


Notes
-----

.. [#jsonschema] `JSON Schema <http://json-schema.org>`_ is a vocabulary that
   allows you to annotate and validate JSON documents.
