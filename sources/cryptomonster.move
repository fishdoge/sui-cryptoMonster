/*
/// Module: cryptomonster
module cryptomonster::cryptomonster {

}
*/

module cryptomonster::cryptomonster {
  // ---- Libraries Being Used -----
  use std::debug;
  use std::string::{String};
  use std::type_name::{Self, TypeName};
  
  //use cetus_clmm::position::{PositionManager, PositionInfo};
  //use cetus_clmm::tick::{Tick, TickManager};
  //use cetus_clmm::rewarder::{RewarderManager, RewarderGlobalVault};
  //use cetus_amm::position;
  use cryptomonster::pool::{Self, Pool, LSP};
  use integer_mate::i32::{Self as i32, I32};
  use sui::sui::SUI;
  use sui::clock::{Self, Clock};
  use sui::tx_context::sender;
  use sui::balance::Balance;
  use sui::bag::{Self, Bag};

  // ---- Object That Can Be Deployed ----
  public struct Balloon has key {
    id: UID,
    popped: bool
  }

  public struct A has key, store {
    id: UID,
    a: TypeName,
    b: TypeName,
  }

  // Cetus LP Token
  #[allow(unused_field)]
  public struct Position has key, store {
    id: UID,
    pool: ID,
    index: u64,
    coin_type_a: TypeName,
    coin_type_b: TypeName,
    name: String,
    description: String,
    url: String,
    tick_lower_index: I32,
    tick_upper_index: I32,
    liquidity: u128,
  }

  // Monster
  public struct Monster has key, store {
    id: UID,
    lp: A,
    birth_day: u64,
    last_time_groom: u64,
    coin_a: u64,
    coin_b: u64,
  }

  // Garden
  public struct Monster_garden has key, store {
    id: UID,
    monsters: Bag,
  }

  // ---- Initial ----
  fun init(ctx: &mut TxContext) {
  }

  // ---- Dummy/Entity Function ----
  // A dummy
  fun a_dummy(ctx: &mut TxContext) {
    let a_dummy = A {
      id: object::new(ctx),
      a: std::type_name::get<SUI>(),
      b: std::type_name::get<SUI>(),
    };
    transfer::transfer(a_dummy, sender(ctx));
  }

  // Monster Dummy
  fun monster_dummy<T1: drop, T2: drop>(clock: &mut Clock, ctx: &mut TxContext) {
    let a_dummy = A {
      id: object::new(ctx),
      a: std::type_name::get<T1>(),
      b: std::type_name::get<T2>(),
    };
    let monster_dummy = Monster {
      id: object::new(ctx),
      lp: a_dummy,
      birth_day: clock::timestamp_ms(clock),
      last_time_groom: clock::timestamp_ms(clock),
      coin_a: 0,
      coin_b: 0,
    };
    transfer::transfer(monster_dummy,sender(ctx));
  }
    
  // Position Dummy
  #[allow(unused_variable)]
  fun position_dummy(ctx: &mut TxContext) {
    let position_name = 0x1::string::utf8(b"Cetus LP | Pool");
    let position_id = object::new(ctx);
    let pool_id = object::uid_to_inner(&position_id);

    let a_dummy =  Position {
      id: position_id,
      pool: pool_id,
      index: 1,
      coin_type_a: std::type_name::get<SUI>(),
      coin_type_b: std::type_name::get<SUI>(),
      name: position_name,
      description: position_name,
      url: position_name,
      tick_lower_index: i32::from(10000),
      tick_upper_index: i32::from(70000),
      liquidity: 2000000,
    };
    transfer::transfer(a_dummy,sender(ctx));
  }

  // Monster Entity
  fun monster_entity<T1: drop, T2: drop>(clock: &mut Clock, ctx: &mut TxContext): Monster {
    let a_dummy = A {
      id: object::new(ctx),
      a: std::type_name::get<T1>(),
      b: std::type_name::get<T2>(),
    };
    let monster_entity = Monster {
      id: object::new(ctx),
      lp: a_dummy,
      birth_day: clock::timestamp_ms(clock),
      last_time_groom: clock::timestamp_ms(clock),
      coin_a: 0,
      coin_b: 0,
    };
    monster_entity
  }

  fun destroy_monster_entity<T1: drop, T2: drop>(mon: Monster) {
    let Monster {
      id: monster_id,
      lp: lp_entity,
      birth_day: _,
      last_time_groom: _,
      coin_a: _,
      coin_b: _,
    } = mon;
    let A {
      id: a_id,
      a: _,
      b: _,
    } = lp_entity;
    monster_id.delete();
    a_id.delete();
  }

  // Garden Entity
  fun garden_entity(ctx: &mut TxContext): Monster_garden {
    let garden = Monster_garden {
      id: object::new(ctx),
      monsters: sui::bag::new(ctx),
    };
    garden
  }

  fun destroy_garden_entity(garden: Monster_garden){
    let Monster_garden {
      id: garden_id,
      monsters: mon_bag,
    } =  garden;
    garden_id.delete();
    bag::destroy_empty(mon_bag);
  }

  // ---- Entity Operation Function ----
  // Garden Entity Operation
  // Garden add Monster

  // ---- Print/Debug Function ----
  #[allow(unused_variable)]
  public entry fun position_show(_position: &mut Position, ctx: &mut TxContext){
    debug::print(_position);
  }

  #[allow(unused_variable)]
  public entry fun a_show(_a: &mut A, ctx: &mut TxContext){
    debug::print(_a);
  }

  //-------------------Test Scenario Function-----------------------

  #[test]
  fun test_id_generation() {
    let mut ctx = tx_context::dummy();
    assert!(ctx.get_ids_created() == 0);

    let id1 = object::new(&mut ctx);
    let id2 = object::new(&mut ctx);

    // new_id should always produce fresh ID's
    assert!(&id1 != &id2);
    assert!(ctx.get_ids_created() == 2);
    id1.delete();
    id2.delete();
  }

  #[test]
  fun test_a_dummy() {
    let mut ctx = tx_context::dummy();
    let clock = clock::create_for_testing(&mut ctx);
    a_dummy(&mut ctx);
    clock::destroy_for_testing(clock);
  }

  #[test]
  fun test_position_dummy() {
    let mut ctx = tx_context::dummy();
    let clock = clock::create_for_testing(&mut ctx);
    position_dummy(&mut ctx);
    clock::destroy_for_testing(clock);
  }

  #[test]
  fun test_monster_dummy() {
    let mut ctx = tx_context::dummy();
    let mut clock = clock::create_for_testing(&mut ctx);
    monster_dummy<SUI,SUI>(&mut clock, &mut ctx);
    clock::destroy_for_testing(clock);
  }

  #[test]
  fun test_monster_entity() {
    let mut ctx = tx_context::dummy();
    let mut clock = clock::create_for_testing(&mut ctx);
    let mon = monster_entity<SUI,SUI>(&mut clock, &mut ctx);
    destroy_monster_entity<SUI,SUI>(mon);
    clock::destroy_for_testing(clock);
  }

  #[test]
  fun test_garden_entity() {
    let mut ctx = tx_context::dummy();
    let mut clock = clock::create_for_testing(&mut ctx);
    //let mon = monster_entity<SUI,SUI>(&mut clock, &mut ctx);
    //destroy_monster_entity<SUI,SUI>(mon);
    let garden = garden_entity(&mut ctx);
    destroy_garden_entity(garden);
    clock::destroy_for_testing(clock);
  }

  #[test]
  fun test_dummy() {
    test_monster_dummy();
  }
            
}
