# Work log for ixml-tests

## 2021-01-25 planning, setup

My current goal is to have a proof-of-concept test suite in place here by the time the invisible-XML group meets on Thursday.

Today I have spent a couple of hours reviewing the schemas for the XSD and QT3 (XSLT/XQuery/XPath 3.0 and 3.1) test suites, have created an empty directory structure for the work, and sketched out a dummy test catalog, which I have used to guide the creation of an RNC schema.

I have also yoked the whole thing to a github repository.


## 2021-01-26

This morning I cautiously generalized the Makefile I was using to test the positive test-case generation, and used it to generate positive test catalogs for the gxxx grammars.

I am also working to extend the generic Makfile to help with negative test case generation as well.

Wrote a stylesheet to display the test catalogs in the browser, which works locally.  But of course github does not work that way, or if it does I do not know how to make it happen.  Anyone who wants to look at a catalog is going to have to look at the XML or download the catalog and the XSLT to style it.
