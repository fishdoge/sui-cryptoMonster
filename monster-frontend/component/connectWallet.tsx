import { ConnectButton } from '@mysten/dapp-kit';

export function ConnectWallet() {
	return  <div className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                <ConnectButton/>
            </div>;
}