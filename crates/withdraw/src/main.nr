use std::hash::poseidon::bn254::hash_1;

fn main(
    identity_secret: Field,
    _address: pub Field,
) -> pub Field {
    hash_1([identity_secret])
}