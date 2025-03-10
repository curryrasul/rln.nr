use std::hash::poseidon::bn254::hash_2;

use crate::DEPTH;

pub fn compute_merkle_root(leaf: Field, path_indices: [Field; DEPTH], siblings: [Field; DEPTH]) -> Field {
    let n = siblings.len();
    let mut current = leaf;

    for i in 0..n {
        let is_right = (path_indices[i] == 1) as bool;
        let nodes = [current, siblings[i]];
        let (hash_left, hash_right) = (nodes[is_right as u8], nodes[1 - is_right as u8]);
        current = hash_2([hash_left, hash_right]);
    };

    current
}

pub fn less_than(message_id: Field, limit: Field) {
    let message_id: u32 = message_id as u32;
    let limit: u32 = limit as u32;

    assert(message_id < limit, "Value exceeds the maximum allowed");
}