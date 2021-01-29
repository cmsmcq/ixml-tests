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


### Size explosion

(Later)

It's now 5 pm, the determinizer has been running for going on eleven hours (without crashing!  Cool!).  Saxon has produced 800 MB of output so far, in which the number of states has (thus far) grown from 929 in the non-deterministic input to 9270 in what is now on disk.  The number of transitions has risen by about the same factor of 10, from 9979 to 96365, so the ratio of transitions to states is not exploding.  (Of course, I have no way of knowing how far the process is from finishing:  the states in the DFSA will be drawn from the power set of the states of the NFSA, so the upper bound is 2<sup>929</sup>, which a calculator tells me is 4.53E279.)  I'm a little puzzled by the disproportionate growth in size:  the NFSA uses 500-600 bytes per arc, 6000 bytes per state, and the DFSA fragment is at 8500 bytes per arc, 88000 bytes per state.  Looking at fragments using `head` and `tail` tells me there are a lot of complex inclusions, and I observe that I appear never to have removed the comments giving the hex equivalents of characters, which is not helping the file size any.

I'm going to let the process continue to run in the hopes of satisfying my curiosity about how long it takes and how big the result grows, but I suppose that instead of a proof of concept, an 800 MB description of a 10,000-state DFSA is a proof that the approach I have been using for negative test cases does not scale up to grammars of reasonable size, let alone to large grammars.

How can that problem be addressed?

* Taking the notion of pseudo-terminals more seriously will help control size, at the cost of more complexity in the work flow and (at least at first) more manual work.

* Moving to a different representation (and possibly a different implementation language) would probably help.

Let me think about these.


### Compact representation

To retain legibility and a connection to thinking about FSAs and regular grammars as interchangeable, I suppose I could use ixml (or, to be brutal, a subset of ixml that suffices for regular grammars and is easy to handle with a recursive descent parser) and process it in C or Pascal.

Then the state represented by about 700 bytes of XML (after stripping whitespace) that looks like this:

      <rule name="ixml_1">
        <alt>
          <inclusion tmark="-">
            <class code="Zs"/>
          </inclusion>
          <nonterminal name="ixml_1"/>
        </alt>
        <alt>
          <literal tmark="-" hex="9"/>
          <nonterminal name="ixml_2"/>
        </alt>
        <alt>
          <literal tmark="-" hex="a"/>
          <nonterminal name="ixml_3"/>
        </alt>
        <alt>
          <literal tmark="-" hex="d"/>
          <nonterminal name="ixml_4"/>
        </alt>
        <alt>
          <literal tmark="-" dstring="{"/>
          <nonterminal name="ixml_5"/>
        </alt>
        <alt>
          <inclusion>
            <literal dstring="@"/>
            <literal dstring="^"/>
            <literal dstring="-"/>
          </inclusion>
          <nonterminal name="rule_1"/>
        </alt>
        <alt>
          <inclusion>
            <literal dstring="_"/>
            <class code="Ll"/>
            <class code="Lu"/>
            <class code="Lm"/>
            <class code="Lt"/>
            <class code="Lo"/>
          </inclusion>
          <nonterminal name="rule_13"/>
        </alt>
      </rule>

becomes the more compact (109 bytes, after whitespace is removed):

    ixml_1: -[Zs], ixml_1;
        -#9, ixml_2;
        -#A, ixml_3;
        -#D, ixml_4;
        -"{", ixml_5;
        ["@^-"], rule_1; 
        ["_"; Ll; Lu; Lm; Lt; Lo], rule_13.

That 7:1 reduction seems less than I had expected.  I suppose that if states had shorter names we'd get a better compression ratio.  At this rate the switch from XML to ixml gets us an NFSA down to a bit less than 1 MB down from 5.5, and a DFSA which is at least 100 MB.  Still probably a bit of a challenge.

Minimizing the DFSA would help some, but that is also not a quick algorithm.


### Pseudo-terminals, error layering?

Every bit of hand work needed makes a higher barrier to use (see the Paoli Principle), so I don't think it was a mistake to try to build a workflow that did not require the user to identify or work with pseudo-terminals.  But I suspect that expanding the non-recursive nonterminals in place has a non-linear effect on the size of the RTN.

Let's try to be more precise, at least for this one case.

* The ixml grammar for ixml has (in XML) 45 `rule` elements and takes 11341 bytes.

* The manually constructed O0 grammar for ixml has (in XML) 41 `rule` elements and takes 11746 bytes (verbose comment).

* A recursive transition network constructed after expanding pseudo-terminals in place if they occur in more than one location (which turns out to mean all of them), saved in the ixml directory as ixml.O0.nfsa.xml, has 1195 states and 5058 transitions; it takes 668,138 bytes on disk.

* After normalizing terminals, eliminating unit rules (in this context, epsilon transitions), removing unreachable states, and simplifying epsilon expressions, the NFSA is down to 929 states and up to 9979 transitions (`rule` and `alt` elements, respectively), and takes eight times as much disk space:  5,582,015 bytes.  The key factor here is, I believe, the increased complexity of the inclusions (and the large size of the `gt:ranges` attribute that is the current way of detecting overlap).

If instead of expanding pseudo-terminals, we had left them unexpanded, so that we had an FSA whose arcs were labeled with the names of regular languages, what would we have?

* A recursive transition network constructed directly from the original grammar, including ixml, rule, and the eight recursive nonterminals (alts, alt, termin, repeat0, repeat1, option, sep, and factor), and treating all other nonterminal as pseudo-terminals, has (in XML) 62 states (`rule` elements) and 78 arcs (`alt` elements), and takes 17147 bytes.  

* Doing the same with the manually constructed O0 grammar produces an FSA with 52 states, 66 transitions, taking 15363 bytes.

So:  it's clear that treating some nontermionals as pseudo-terminals dramatically reduces the size of the FSA we have to deal with for the language as a whole.  And the cost may be lower than I had thought.  I was thinking of pseudo-terminals as something to be selected judiciously, the way one chooses the level at with to draw the boundary between the lexer and the parser in a yacc / lex application.  That would require the user to understand what their function is and to think about it.

But if the only thing riding on the choice of non-terminals is the size of the RTN, then the more the merrier.  Any recursive nonterminal needs to be broken out in the RTN.  Any nonterminal whose language is recursive needs to be broken out.  All others can be treated as pseudo-terminals.  (Actually, that's an oversimplification:  I am ignoring the fact that in ixml, `comment` is recursive and thus almost every nonterminal is recursive.  I am pretending that somehow the system knows to make a special arrangement for comments.  Since in ixml the recursion cycle for comments is disjoint from the recursion cycle for alts, etc., it is in fact possible for a machine to see that something special is happening.  I think the thing to do is to draw one RTN for each recursion cycle, and treat the nonterminals in the other cycles as non-recursive for purposes of the current RTN.

Actually, the case of `comment` in ixml suggests that I'm wrong to think that superior nonterminals (from which recursive nonterminals can be reached) need to be included in the RTN.  The RTN provides the languages for the nonterminals involved in a given cycle.  In creating a superset approximation O<sub>*k*</sub>, we make regular approximations of those languages and insert them into appropriate locations in the grammar for O<sub>*k*</sub>.  (Just as it's obvious we can do for `comment`.)  We don't need anything outside the cycle in the RTN:  anything outside the cycle cannot come back (otherwise it would be in the cycle), so it can be treated as a pseudo-terminal.  (I hope this is clear enough to understand, when I come back to it.  I am not able to explain any more clearly right now.)

But if we draw the small FSA with pseudo-terminals, how do we manage to get the kind of relative complete checking the character-based FSAs are getting us now?  And how do we determinize the FSA?  Those are two distinct questions, I think.  

Let us consider first the simple case in which the languages in the extended alphabet are all disjoint and in which no word in any language is a prefix of a word in any other language in the extended alphabet.  In this case, I think it seems clear that the RTN can be determinized in the usual way. 

If we use the small RTN for ixml, we have arcs labeled with some terminals, and with the names of exactly three regular languages:  `terminal`, `nonterminal`, and `S`.  (If we include `ixml` and `rule` in the mix, as I did when generating the FSAs described above, we also have `mark` and `name`.)  Call the set of terminals and named languages in the RTN the extended alphabet.  In the case of ixml, we do seem to have the situation that the items in the extended alphabet satisfy the condition mentioned.

I think we can distinguish two classes of errors in the construction of sentences in the language, or classes of non-sentences:

* Strings which can be partitioned into substrings which are all members of the extended alphabet, but which are put together in ungrammatical ways.  (So:  the parts of the string are all fine, as instances of L(nonterminal), L(terminal), L(S), or the terminal symbols in the RTN.  But they are badly joined.  For example:  `x: y z.` without a comma separating the two terms on the RHS.  Or `x^: y, z.` with the mark and the name on the LHS in the wrong order.)

* Strings which cannot be so partitioned.  (So: some part of the string cannot be used to traverse any arc, because it is not a member of the extended alphabet.  E.g. `23: y, z.` where what should be a name on the left hand side is not a name.)

Since the regular languages in the extended alphabet themselves have structure, the same analysis can be repeated for them, if we wish, but my inclination is to try to avoid that, unless there is a way to make it purely mechanical.  Either we reduce the entire regular language to an FSA and handle it using the methods we've already got, or we just take each production rule in the original grammar as a level:  L(`nonterminal`) becomes a very simple RTN whose extended alphabet is L(`mark`), L(`name`), and L(`S`); and so on.

This suggests that for any language (including the languages of nonterminals in the original grammar) we can construct negative cases in two ways:

* Using only tokens in the extended alphabet, create sequences which do not match the FSA.  To take the case of `nonterminal`, whose rule is `nonterminal: (mark, S)?, name, S.`, a purely mechanical operation (aided by the knowledge that S is nullable repeatable, i.e. S S = S) produces the patterns (S), (mark S mark ...), (mark), (mark S  mark ...), (name S mark ...), (name S name ...) (mark S name S mark ...) (mark S name S name ...), where ellipsis means any sequence can follow.  Fill these in with any values from L(`mark`), L(`name`), and L(`S`) and they will be non-sentences in L(`nonterminal`).

* For any sequence in the language, take one token, e.g. *L(N)* for some nonterminal *N*, and replace it with a token which is not in the language of *N*.

One problem is that if S were not nullable, the sequence (S mark S name S) would be a non-sentence in L(`nonterminal`) but would not suffice to make a legal rule into a negative test case for rule, because in context the S will in ixml be absorbed by some other rule.  I seem to remember crashing on this rock before.  I'll only observe that it is one thing for every good negative test case to fall into one or the other of these categories, and something different for every test case constructed in those ways to be a good one.


But in general the extended alphabet of an RTN is not going to be so well behaved as to be disjoint and free of confusing prefixes.  We need to face that.  In the Program grammar, for example, the keyword `if` is also legal as an identifier, so L(`if-statement`) and L(`call`) and L(`assignment`) all share the string `if` as a prefix. (And also, indeed, the letter `i`.)

I am remembering that my working without pseudo-terminals was not just an attempt to save human intervention, but also a result of not being able to find a way around these problems.

Maybe now, armed with the knowledge that determinizing my manuall constructed FSA for ixml's O0 superset has thus far taken 15 hours and 818 MB, I will be re-motivated to look again and try to find a solution.



