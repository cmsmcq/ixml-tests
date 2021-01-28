# Work log for ixml-tests

## 2021-01-25 planning, setup

My current goal is to have a proof-of-concept test suite in place here by the time the invisible-XML group meets on Thursday.

Today I have spent a couple of hours reviewing the schemas for the XSD and QT3 (XSLT/XQuery/XPath 3.0 and 3.1) test suites, have created an empty directory structure for the work, and sketched out a dummy test catalog, which I have used to guide the creation of an RNC schema.

I have also yoked the whole thing to a github repository.


## 2021-01-26

This morning I cautiously generalized the Makefile I was using to test the positive test-case generation, and used it to generate positive test catalogs for the gxxx grammars.

I am also working to extend the generic Makfile to help with negative test case generation as well.

Wrote a stylesheet to display the test catalogs in the browser, which works locally.  But of course github does not work that way, or if it does I do not know how to make it happen.  Anyone who wants to look at a catalog is going to have to look at the XML or download the catalog and the XSLT to style it.


## 2021-01-28 Current status of play

I have spent the last few days generating tests, and stumbling over bugs and infelicities in the tools.

The positive test generation seems to run more or less as expected:  the tests can fairly be described as eccentric and repetitive -- the tests for ixml have an absolute obsession with nested comments -- but generation is for the most part uneventful.  The most complicated thing I had to do was run ln-from-parsetrees and parsetree-pointing two or three times to complete the ixml parses.  And one of the trees ended up being rooted in term because it grew past the limit before reaching the start symbol, while growing upward.  (And I know why there are so many nested comments, now that I think about it:  I regenerated everything from scratch and did not manually edit the disjunctive normal form to eliminate most of the uninteresting and repetitive cases of recursive right-hand sides for comment.)

The negative test generation, by contrast, has been more problematic.  Bugs in ixml-to-saprg, over-simplifications in the R0-subset stylesheet, and recalcitrant FSAs.  It took a long time to construct the O3 superset for the toy arithmetic expression grammar -- three nonterminals need simplification, and none of them benefit as much as one might have hoped from the others' simplification pipelines.  For ixml itself, Java failed with an out-of-memory error on the u3 subset.  The u2 and even u1 subsets were too large to contemplate turning into FSAs (7000 and 1000 nonterminals, respectively), and while u0 looked tractable (207 rules) there were nine symbols for which O0 expressions were needed, and I gave up on the idea of generating the O0 grammar via the usual approach of knitting rules from O<sub>k</sub> into u<sub>k</sub>.  Instead I exploited the fact that ixml is so simple to construct an O<sub>0</sub> grammar manually, by adding Kleene stars to the parens around *alt* in the rule for *factor*, and making an equivalent change of a different shape to *comment* (which I later changed just to forbid nested comments).  The resulting grammar should be left- and right-embedding but not center-embedding, so it should be regular.  Inlining frequently used non-recursive rules and simplifying similar rules to reduce size (we are producing negative cases, not parse trees, so the structure need not be retained) got the grammar down to six rules.  The NFSA for the recursive transition network has 1195 states.  Trying to build test cases from it, though, has not yet succeeded.  The pipeline died after some hours (not sure when) during the determinization step, again due to lack of memory.  (Maybe I just need to invoke Java with a larger virtual machine?)  I am now running the determinizer as a stand-alone program to see if that helps, but even if it runs to completion it seems unlikely that it will finish before show-and-tell this morning.

