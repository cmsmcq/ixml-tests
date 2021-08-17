# ixml-tests
Test suite(s) for ixml

This project contains collections of tests for invisible XML, together
with supporting materials.  For more on invisible XML, see
[https://invisiblexml.org](https://invisiblexml.org) and material linked from there.

The subdirectory organization is fairly simple:

* The A (admin) directory contains work plans and similar stuff.

  * A [work log](A/worklog.md) 
  * A [work plan](A/workplan.md) 

* The doc directory contains documentation and technical papers,
including:

  * A catalog sketch (in [XML](doc/catalog-sketch.xml) or [HTML](doc/catalog-sketch.html)]

* The lib directory contains schemas and other ancillary materials.

* The tests-straw directory contains a proof-of-concept test suite for
ixml parsing functionality, with catalog and test cases and results
(some as separate files, some in the catalog).  At the moment, these
include:

    * Test for a simple grammar of [arithmetic expressions](test-straw/arith/arith.md)

Further test suites may be added later in further tests-* directories.

For now, the default license is GPL 3.0, though I am not sure whether
that actually makes sense for test cases; other license terms may be
available.

