# ixml-2022-01-25 test suite work log

## 2022-01-31

This directory contains a new attempt at a small test suite for ixml
that satisfies two relatively simple coverage criteria:

* The positive tests satisfy the choice coverage criterion: each
  branch of each choice in the grammar is taken in at least one test
  case, with E* and E+ taken as three-way branches (0, 1, and 2 or
  more E for E*, 1, 2, and 3 or more E for E+).

* The negative tests satisfy the arc-final coverage criterion on the
  O<sub>0</sub> regular superset approximation.  That means that in
  the FSA constructed by ignoring the stack management actions in the
  recursive transition network for the grammar, for each arc in the
  FSA that leads to a non-final state, there is at least one test case
  for which that is the last arc traversed.

For the positive tests, the work plan has four steps, each to be
automated as far as seems possible and sensible:

1 Rewrite the grammar in an equivalent flattened BNF form designed to
ensure that the choice coverage criterion is satisfied if and only if
every RHS in the flattened grammar is present in the (raw) parse tree
for at least one test case.

In the lib/ directory, ixml-20220125.flattened.xml is the flattened
grammar.

2 From the grammar, generate document fragments of maximum height 2,
one for each RHS in the grammar.  I sometimes refer to these as 'Lego
pieces'.

For example, consider this rule:

````
   <rule name="annotation" mark="-">
      <alt/>
      <alt>
         <nonterminal name="mark"/>
         <nonterminal name="s"/>
      </alt>
   </rule>
````

From it we will generate two Lego pieces:

   <nt name="annotation"><comment>* empty *</comment><nt>
   <nt name="annotation">
       <nt-socket name="mark"/>
       <nt-socket name="s"/>
   <nt>

The *nt-socket* children in the second tree are places where *nt*
elements with the appropriate names can be plugged in.

In the flattened grammar, there are 129 RHS, so there will be 129 Lego
pieces.

3 Put the lego pieces together into test-case skeletons or test-case
recipes; these will be XML documents rooted in an *nt* with
`name='ixml'` and no *nt-socket* elements.  All the pieces must be
used up, preferably with minimal repeated use.

4 For each such recipe, create a test case with the corresponding
structure.

The current state of play is that the Gingersnap tool kit now has a
transform (bnf-from-ebnf-tc) that flattens a grammar.

I don't have a good algorithm for putting the lego pieces together so
as to minimize re-use, so I must either find an algorithm or do it by
hand.

Since as the grammar changes we are going to want to update the test
suite but not necessarily replace it completely, it's perhaps simplest
to focus on the case where we have some test cases, check them for
coverage, and manually create test cases to complete the coverage.

So the next steps are probably:

* Collect test cases for the ixml specification grammar from the gxxx
  and arith grammars in the strawman tests, and from my old manually
  constructed test cases.

  This is manual work.

* Measure their coverage (and identify redundancies, so we can have
  both a small test set and a fuller one).
  
  Automation: write a function to make Aparecium return the raw parse
  tree.

  Automation: write a function to read a flattened grammar and write a
  set of XPath queries that can be used in XQuery or XSLT to create a
  coverage report from the collection of raw parse trees for a test
  set.

  Automation: write the appropriate XQuery and/or XSLT.

  Automation: write a query or transform to check a collection of
  tests for redundancy and identify test cases that can be omitted
  without damaging choice coverage.

* Build test cases for unused RHS in the flattened grammars.

