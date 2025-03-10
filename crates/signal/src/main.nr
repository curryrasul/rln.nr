mod utils;

use std::hash::poseidon::bn254::{hash_1, hash_2, hash_3};

use utils::{compute_merkle_root, less_than};

global DEPTH: u32 = 16;

struct Output {
    y: Field,
    root: Field,
    nullifier: Field,
}

fn main(
    identity_secret: Field,
    user_message_limit: Field,
    message_id: Field,
    siblings: [Field; DEPTH],
    path_indices: [Field; DEPTH],
    x: pub Field,
    external_nullifier: pub Field,
) -> pub Output {
    // Calculating leaf of a Merkle Tree
    let identity_commitment = hash_1([identity_secret]);
    let rate_commitment = hash_2([identity_commitment, user_message_limit]);

    // Membership check
    let root = compute_merkle_root(rate_commitment, path_indices, siblings);

    // message_id range check
    less_than(message_id, user_message_limit);

    // SSS share calculation
    let a1 = hash_3([identity_secret, external_nullifier, message_id]);
    let y = identity_secret + a1 * x;

    // nullifier calculation
    let nullifier = hash_1([a1]);

    Output {y, root, nullifier}
}