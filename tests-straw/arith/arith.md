# Tests for simple grammar for arithmetic expressions

This directory contains contains a collection of tests for an invisible-XML
grammar for simple arithmetic expressions.  Material here includes:

* The ixml grammar (in [ixml notation](arith.ixml) or in [XML](arith.ixml.xml)).

* A set of several test catalogs.

	* The [top-level catalog](arith.test-catalog.all.xml) points to all of the others.
Note that when last tried, some of the catalogs of negative test cases were too big to look at in a
browser on Github.

	* A set of [positive](arith.test-catalog.pos.xml) test cases. 

	* A set of 7638 [arc-complete negative](arith.O3.test-catalog.arc.neg.xml) test cases. 

	* A set of 2886 [arc-final negative](arith.O3.test-catalog.arc-final.neg.xml) test cases.

	* A set of 1020 [state-complete negative](arith.O3.test-catalog.state.neg.xml) test cases.

	* A set of 338 [state-final negative](arith.O3.test-catalog.state-final.neg.xml) test cases. 

Note that no attempt has been made to reduce (let alone eliminate) redundancy in the negative test sets.


