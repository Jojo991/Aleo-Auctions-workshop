// The `program` scope defines the data types, functions, and state associated with the `auction` program.
program auction_new.aleo {

    // A bid in an auction.
    // - `owner`     : The address of the account that owns the record associated with this bid.
    //                 This is separate from the address of the account that placed the bid.
    // - `bidder`    : The address of the account that placed the bid.
    // - `amount`    : The amount of the bid.
    // - `is_winner` : Whether the bid is the winning bid.
    record Bid {
        owner: address,
        bidder: address,
        amount: u64,
        is_winner: bool,
    }
      // A prize in the auction.
    // - `owner`   : The address of the account that owns the prize.
    // - `amount`  : The amount of the prize.
    record Prize {
        owner: address,
        amount: u64,
    }

    // Returns a new bid.
    // - `bidder` : The address of the account that placed the bid.
    // - `amount` : The amount of the bid.
    // Requires that `bidder` matches the function caller.
    // The owner of the record is set to the entity responsible for running the auction (auction runner).
    // The address of the auction runner is aleo107sjt28ujthkxevzaz90jt38l6vqs8lwk7fynchfemj0540dluqspg2qpk.
    transition place_bid(bidder: address, amount: u64) -> Bid {
        // Ensure the caller is the auction bidder.
        assert_eq(self.caller, bidder);
        // Return a new 'Bid' record for the auction bidder.
        return Bid {
            owner: aleo107sjt28ujthkxevzaz90jt38l6vqs8lwk7fynchfemj0540dluqspg2qpk,
            bidder: bidder,
            amount: amount,
            is_winner: false,
        };
    }

    // Returns the winning bid.
    // - `first`  : The first bid.
    // - `second` : The second bid.
    // Requires that the function caller is the auction runner.
    // Assumes that the function is invoked only after the bidding period has ended.
    // In the event of a tie, the first bid is selected.
    transition resolve(first: Bid, second: Bid) -> Bid {
        // Ensure the caller is the auctioneer.
        assert_eq(self.caller, aleo107sjt28ujthkxevzaz90jt38l6vqs8lwk7fynchfemj0540dluqspg2qpk);
        // Resolve the winner of the auction.
        if (first.amount >= second.amount) {
            return first;
        } else {
            return second;
        }
    }

    // Returns ownership of the bid to bidder.
    // - `bid` : The winning bid.
    // Requires that the function caller is the auction runner.
    // Assumes that the function is invoked only after all bids have been resolved.
    transition finish(bid: Bid) -> Bid {
        // Ensure the caller is the auctioneer.
        assert_eq(self.caller, aleo107sjt28ujthkxevzaz90jt38l6vqs8lwk7fynchfemj0540dluqspg2qpk);
        // Return 'is_winner' as 'true' in the winning 'Bid'.
        return Bid {
            owner: bid.bidder,
            bidder: bid.bidder,
            amount: bid.amount,
            is_winner: true,
        };
    }
    // Allows the winning bidder to retrieve their prize.
    transition retrieve_prize(bid: Bid) -> Prize {
        assert_eq(self.caller, bid.bidder);
        assert_eq(bid.is_winner, true);
        // Return the prize to the winning bidder.
        return Prize {
            owner: bid.bidder,
            amount: 30u64, // Example prize amount
        };
    }
}
