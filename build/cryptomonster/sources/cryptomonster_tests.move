
#[test_only]
module cryptomonster::cryptomonster_tests {
    // uncomment this line to import the module
    // use cryptomonster::cryptomonster;
    use sui::sui::SUI;
    use sui::coin::{Self, Coin, mint_for_testing as mint};
    use sui::test_scenario::{Self as test, Scenario, next_tx, ctx};
    use cryptomonster::pool::{Self, Pool, LSP};
    use sui::transfer;
    use sui::test_utils;

    /// Gonna be our test token.
    public struct BEEP {}

    /// A witness type for the pool creation;
    /// The pool provider's identifier.
    public struct POOLEY has drop {}

    const ENotImplemented: u64 = 0;
    const SUI_AMT: u64 = 1000000000;
    const BEEP_AMT: u64 = 1000000;

    #[test]
    fun test_cryptomonster() {
        // pass
    }

    #[test, expected_failure(abort_code = ::cryptomonster::cryptomonster_tests::ENotImplemented)]
    fun test_cryptomonster_fail() {
        abort ENotImplemented
    }

    #[test]
    fun test_pool() {
        let mut scenario = scenario();
        test_init_pool_(&mut scenario);
        test::end(scenario);
    }

    #[test_only]
    fun burn<T>(x: Coin<T>): u64 {
        let value = coin::value(&x);
        test_utils::destroy(x);
        value
    }

    /// Init a Pool with a 1_000_000 BEEP and 1_000_000_000 SUI;
    /// Set the ratio BEEP : SUI = 1 : 1000.
    /// Set LSP token amount to 1000;
    fun test_init_pool_(test: &mut Scenario) {
        let (owner, _) = people();

        next_tx(test, owner);
        {
            pool::init_for_testing(ctx(test));
        };

        next_tx(test, owner);
        {
            let lsp = pool::create_pool(
                POOLEY {},
                mint<BEEP>(BEEP_AMT, ctx(test)),
                mint<SUI>(SUI_AMT, ctx(test)),
                3,
                ctx(test)
            );

            //assert!(burn(lsp) == 31622000, 0);
            transfer::public_transfer(lsp, tx_context::sender(ctx(test)));
        };

        next_tx(test, owner);
        {
            let pool = test::take_shared<Pool<POOLEY, BEEP>>(test);
            let (amt_sui, amt_tok, lsp_supply) = pool::get_amounts(&pool);

            assert!(lsp_supply == 31622000, 0);
            assert!(amt_sui == SUI_AMT, 0);
            assert!(amt_tok == BEEP_AMT, 0);

            test::return_shared(pool)
        };

        next_tx(test, owner);
        {
            //let pool = test::take_shared<Pool<POOLEY, BEEP>>(test);
            //let lsp = test::take_from_sender<Coin<LSP<BEEP,SUI>>>(test);
            //assert!(burn(lsp) == 31622000, 0);
        }
    }

    // utilities
    fun scenario(): Scenario { test::begin(@0x1) }
    fun people(): (address, address) { (@0xBEEF, @0x1337) }
}
