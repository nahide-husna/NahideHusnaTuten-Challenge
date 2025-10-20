module challenge::hero;

use sui::object::{Self, UID, ID};
use sui::tx_context::{Self, TxContext};
use sui::transfer;
use std::string::String;

use sui::event;

// ========= EVENTS =========

// Event'ler 'copy' ve 'drop' yeteneklerine sahip olmalıdır.
public struct HeroCreated has copy, drop {
    id: ID,
    creator: address,
    power: u64,
}

// ========= STRUCTS =========

public struct Hero has key, store {
    id: UID,
    name: String,
    image_url: String,
    power: u64,
}

// HeroMetadata, Hero'nun kimin tarafından, ne zaman oluşturulduğunu izler
public struct HeroMetadata has key, store {
    id: UID,
    hero_id: ID,
    created_at: u64,
    creator: address,
}

// ========= FUNCTIONS =========

#[allow(lint(self_transfer))]
public fun create_hero(name: String, image_url: String, power: u64, ctx: &mut TxContext) {
    
    // TODO: Create a new Hero struct with the given parameters
    let hero = Hero {
        id: object::new(ctx),
        name,
        image_url,
        power,
    };
    
    // ID'yi nesne transfer edilmeden önce almalıyız (E06002 hatası çözümü).
    let hero_id_ref = object::id(&hero);
    
    // TODO: Transfer the hero to the transaction sender
    transfer::public_transfer(hero, tx_context::sender(ctx));

    // TODO: Create HeroMetadata and freeze it for tracking
    let metadata = HeroMetadata {
        id: object::new(ctx),
        hero_id: hero_id_ref,
        created_at: tx_context::epoch_timestamp_ms(ctx),
        creator: tx_context::sender(ctx),
    };
    
    //TODO: Use transfer::freeze_object() to make metadata immutable
    transfer::freeze_object(metadata);

    // HeroCreated event'ini yayınla
    event::emit(HeroCreated {
        id: hero_id_ref,
        creator: tx_context::sender(ctx),
        power,
    });
}

// ========= GETTER FUNCTIONS =========

public fun hero_power(hero: &Hero): u64 {
    hero.power
}

#[test_only]
public fun hero_name(hero: &Hero): String {
    hero.name
}

#[test_only]
public fun hero_image_url(hero: &Hero): String {
    hero.image_url
}

#[test_only]
public fun hero_id(hero: &Hero): ID {
    object::id(hero)
}
