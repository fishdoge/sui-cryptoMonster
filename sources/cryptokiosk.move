module cryptomonster::cryptokiosk {
    use sui::kiosk_test_utils::{Self as test, Asset};
    use sui::transfer_policy as policy;
    use sui::sui::SUI;
    use sui::kiosk;
    use sui::coin;

    #[test]
    fun test_set_owner_custom() {
        let ctx = &mut test::ctx();
        let (mut kiosk, owner_cap) = test::get_kiosk(ctx);

        let old_owner = kiosk::owner(&kiosk);
        kiosk::set_owner(&mut kiosk, &owner_cap, ctx);
        assert!(kiosk::owner(&kiosk) == old_owner, 0);

        kiosk::set_owner_custom(&mut kiosk, &owner_cap, @0xA11CE);
        assert!(kiosk::owner(&kiosk) != old_owner, 0);
        assert!(kiosk::owner(&kiosk) == @0xA11CE, 0);

        test::return_kiosk(kiosk, owner_cap, ctx);
    }
}