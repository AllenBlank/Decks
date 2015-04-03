== Decks README

Decks is a web app in rails jquery-ui and bootstrap to help me search through magic cards and build decks.
Decks and Cards, and Sideboards and Cards have a many to many relationship, Users have decks, decks have sideboards.

Cards were imported from a large json database at mtgjson.
Cards are searchable using basic exclusion by field matching, and by structured boolean search.Cards
For instance you can search (o:flying OR o:reach) AND c!uw to get all cards that are both white and blue and either fly or have reach.

The card partial that gives users the preview of the card in search and preview panes has buttons that add 
that card to the User's most recently created deck via an asynchronous patch request. If the deck edit screen is up,
and if there hasn't been a flurry of requests, the deck list is fetched, regenerated and injected back into the page.
