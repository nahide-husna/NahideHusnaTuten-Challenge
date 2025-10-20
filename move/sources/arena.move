module challenge::arena;

use sui::object::{Self, UID, ID};
use sui::tx_context::{Self, TxContext};
use sui::transfer;
use sui::event;
use sui::address;

use challenge::hero::{Hero, Self};


// ========= STRUCTS =========

public struct Arena has key, store {
    id: UID,
    warrior: Hero,
    owner: address,
}

// ========= EVENTS =========

public struct ArenaCreated has copy, drop {
    arena_id: ID,
    timestamp: u64,
}

public struct ArenaCompleted has copy, drop {
    winner_hero_id: ID,
    loser_hero_id: ID,
    timestamp: u64,
}

// ========= FUNCTIONS =========

public fun create_arena(hero: Hero, ctx: &mut TxContext) {

    // TODO: Create an arena object
    let arena = Arena {
        id: object::new(ctx), // unique ID
        warrior: hero, // Set warrior field to the hero parameter
        owner: tx_context::sender(ctx), // Set owner to ctx.sender()
    };
    
    let arena_id = object::id(&arena);

    // TODO: Emit ArenaCreated event with arena ID and timestamp
    event::emit(ArenaCreated {
        arena_id,
        timestamp: tx_context::epoch_timestamp_ms(ctx),
    });

    // TODO: Use transfer::share_object() to make it publicly tradeable
    transfer::share_object(arena);
}

#[allow(lint(self_transfer))]
public fun battle(hero: Hero, arena: Arena, ctx: &mut TxContext) {
    
    // TODO: Implement battle logic
    // Destructure arena to get id, warrior, and owner
    let Arena { id, warrior, owner } = arena;

    // Güçleri al
    let challenger_power = hero::hero_power(&hero);
    let warrior_power = hero::hero_power(&warrior);

    // ID'leri event için al
    let challenger_id = object::id(&hero);
    let warrior_id = object::id(&warrior);
    
    let winner_id: ID;
    let loser_id: ID;
    let recipient: address;

    // TODO: Compare hero.hero_power() with warrior.hero_power()
    if (challenger_power > warrior_power) {
        // Hero (saldıran) kazanır
        recipient = tx_context::sender(ctx);
        winner_id = challenger_id;
        loser_id = warrior_id;
    } else {
        // Warrior (arena sahibi) kazanır veya berabere kalır
        recipient = owner;
        winner_id = warrior_id;
        loser_id = challenger_id;
    };

    // Kazanan kim olursa olsun, iki Hero da kazanan adrese transfer edilir.
    // TODO: If hero wins: both heroes go to ctx.sender()
    // TODO: If warrior wins: both heroes go to battle place owner
    transfer::public_transfer(hero, recipient);
    transfer::public_transfer(warrior, recipient);

    // TODO: Emit BattlePlaceCompleted event with winner/loser IDs
    event::emit(ArenaCompleted {
        winner_hero_id: winner_id,
        loser_hero_id: loser_id,
        timestamp: tx_context::epoch_timestamp_ms(ctx),
    });

    // TODO: Delete the battle place ID 
    object::delete(id);
}
