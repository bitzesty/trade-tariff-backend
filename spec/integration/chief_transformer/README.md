Differences between our Integration specs and ITSW scenarios
================================================

Explanation about how our specs differ from the ITSW documentation


Date & Time
-----------

Expressing times as dates was a limitation of the TARIC2 specification which we do not have, where in TARIC3 all dates are in DateTime format.

This means that CHIEF specs which deal with dates, specifically the rounding up/down of start/end dates are not applicable to our application. In these instances we have modified the tests to keep the original date and time stamp.

This should not cause many issues, there could be a caching issue, we should ensure we're not caching too much to avoid stale data as end dates could be mid-day for example.

Deletion
--------

Any alternatives or examples in the scenarios which delete records have been amended, as no data should ever be deleted and we should just set an end date.


Commodity Code formatting
--------------------------

We have stripped spaces in the commodity codes in our specs, because the processor will be able to handle white space.


Advalrate
---------

These are sent from CHIEF as decimals, not percent strings - so we have modified the tests to reflect this.


Measure SID
-----------
We do not test the exact value national measure sid that is generated on measures as it is not relevant, and as our processor is different we cannot guaranty a exact match with the ITSW proposal.


Additional Data
---------------

In some of our specs we have to create extra data, not mentioned in the scenario documentation for the transformations to complete successfully.


Invalid specs in the test scenarios
-----------------------------------

In the tests where we feel the data is invalid because of human error we have made a note of it with the NOTE: comment.