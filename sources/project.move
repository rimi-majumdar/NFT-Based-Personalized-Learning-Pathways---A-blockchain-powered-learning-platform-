module MyModule::Tipping {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct to track the creator's tips.
    struct Creator has store, key {
        total_tips: u64,
    }

    /// Function to initialize a creator with zero tips.
    public fun initialize_creator(creator: &signer) {
        let account = signer::address_of(creator);
        move_to(creator, Creator { total_tips: 0 });
    }

    /// Function to send a tip to the creator.
    public fun send_tip(sender: &signer, creator_address: address, amount: u64) acquires Creator {
        let creator = borrow_global_mut<Creator>(creator_address);

        // Transfer the tip from sender to creator
        let tip = coin::withdraw<AptosCoin>(sender, amount);
        coin::deposit<AptosCoin>(creator_address, tip);

        // Update total tips received
        creator.total_tips = creator.total_tips + amount;
    }
}
