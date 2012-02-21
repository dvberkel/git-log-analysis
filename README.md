Git Log Analysis
================

This project provides an executable perl script which reports on the
various commit conventions. 

Conventions
-----------

When I write my commit message is try to specify the kind of
commit. For example if the commit is a fix I will within brackets.

The following keywords are used

* REFACTORING
* FIX

Others may be present

Output
------

The output that is to be expected is a listing of the number of times
a certain keyword is present in the a commit.

For example

    default    37
    [REFACTOR] 51
    [FIX]      5