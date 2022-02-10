# Work plan for Wisps test set 

C. M. Sperberg-McQueen, started 2022-02-09

The Wisps test set includes tests collected in 2018 and 2019 when I
was first working on my invisible-XML parser Aparecium.  I would like
first to translate the test set into the current test-catalog format,
and then to improve on it if I can.

## Steps to complete the test set

* Add test sets for grammars 70-102.

* For all grammars, generate parse trees and add grammar-test elements.

* Correct any unintentional grammar errors (saving the error cases for
  negative grammar tests).

* Ensure that for all test sets, the language recognized by the
  grammar is characterized formally or informally, and the test set
  has at least a few positive and negative test cases.

* For all test cases generate and include expected results.

## Steps to improve the test set

* For each grammar, if L(G) is regular, generate a regular expression
  for it.  If L(G) is not regular, generate regular superset and
  subset approximations (at least O<sub>0</sub>, u<sub>2</sub>,
  O<sub>2</sub>).  If the FSAs are small enough to understand, make
  drawings.

* For each grammar, generate positive and negative test cases from the
  FSAs (if feasible -- when the grammar gets too big the FSAs get much
  too big).
  